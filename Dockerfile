# Usa una imagen base de Debian
FROM debian:latest

# Instala Apache2, Perl, Markdown y MariaDB
RUN apt-get update && \
    apt-get install -y apache2 libapache2-mod-perl2 perl vim libcgi-pm-perl tree\
    mariadb-server mariadb-client libdbi-perl libdbd-mysql-perl markdown && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
# Configuracion de directorios y permisos
RUN mkdir -p /home/pweb /usr/lib/cgi-bin/pages && \
    useradd pweb -m && echo "pweb:12345678" | chpasswd && \
    echo "root:12345678" | chpasswd && \
    chown -R www-data:www-data /usr/lib/cgi-bin/ /var/www/html/ && \
    chmod -R 750 /usr/lib/cgi-bin/ /var/www/html/

# Enlaces simbólicos
RUN ln -s /usr/lib/cgi-bin /home/pweb/cgi-bin && \
    ln -s /var/www/html/ /home/pweb/html && \
    ln -s /home/pweb /usr/lib/cgi-bin/toHOME && \
    ln -s /home/pweb /var/www/html/toHOME

# Habilita CGI en Apache
RUN a2enmod cgid

# Copia el script Perl
COPY ./cgi-bin/*.pl /usr/lib/cgi-bin/
COPY ./html/*.html /var/www/html/
COPY ./css/styles.css /var/www/html/css/
COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf

# Configura la base de datos MariaDB
RUN service mariadb start && \
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS wiki;" && \
    mysql -u root -e "USE wiki; \
        CREATE TABLE paginas (id INT PRIMARY KEY AUTO_INCREMENT, titulo VARCHAR(100), contenido TEXT);" 

# Exponer el puerto 80
EXPOSE 80

# Iniciar servicios al ejecutar el contenedor
CMD service mariadb start && apache2ctl -D FOREGROUND
