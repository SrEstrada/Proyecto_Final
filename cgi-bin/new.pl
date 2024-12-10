#!/usr/bin/perl
use warnings;
use CGI;
use DBI;


my $cgi = CGI->new;

print $cgi->header();

my $titulo = $cgi->param('titulo');
my $contenido = $cgi->param('contenido');
if ($titulo && $contenido) {
        
    my $database = "wiki";
    my $user     = "root";
    my $password = "newpassword";
    my $hostname = "localhost";
    my $dsn      = "DBI:mysql:database=$database;host=$hostname;port=3306";

    my $dbh = DBI->connect($dsn, $user, $password, { RaiseError => 1, PrintError => 0 });
    if (!$dbh) {
        print "<html><body><h1>Error: No se pudo conectar a la base de datos</h1></body></html>";
        exit;
    }

    # Convertir contenido de Markdown a HTML
    my $contenido_html = `echo '$contenido' | markdown`;

    # Insertar datos en la base de datos
    my $sth = $dbh->prepare("INSERT INTO paginas (titulo, contenido) VALUES (?, ?)");
    eval {
        $sth->execute($titulo, $contenido_html);
    };

    if ($@) {
        print "<html><body><h1>Error al insertar en la base de datos: $@</h1></body></html>";
        $dbh->disconnect();
        exit;
    }

    # Confirmar creación exitosa
    print "<html><body><h1>Pagina creada con exito!</h1>";
    print "<p>Titulo: $titulo</p>";
    print "<p>Contenido procesado:</p><div>$contenido_html</div>";
    print "<a href='/cgi-bin/list.pl'>Ver listado</a></body></html>";

    $sth->finish();
    $dbh->disconnect();
} else {
    print "<html><body><h1>Error: Faltan datos</h1></body></html>";
    print "<a href='../new.html'>Volver</a></body></html>";
}
