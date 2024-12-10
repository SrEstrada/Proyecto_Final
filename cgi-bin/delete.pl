#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

# Crear objeto CGI
my $cgi = CGI->new;

# Generar encabezado HTTP
print $cgi->header();

# Capturar el ID de la página
my $id = $cgi->param('id');

# Validar el ID
if (!$id) {
    print "<html><body><h1>Error: No se proporcionó un ID válido</h1>";
    print "<a href='/cgi-bin/list.pl'>Volver al listado</a></body></html>";
    exit;
}

# Datos de conexión a la base de datos
my $database = "wiki";
my $user     = "root";
my $password = "newpassword";
my $hostname = "localhost";
my $dsn      = "DBI:mysql:database=$database;host=$hostname;port=3306";

# Conexión a la base de datos
my $dbh = DBI->connect($dsn, $user, $password, { RaiseError => 1, PrintError => 0 });
if (!$dbh) {
    print "<html><body><h1>Error: No se pudo conectar a la base de datos</h1></body></html>";
    exit;
}

# Eliminar la página
my $sth = $dbh->prepare("DELETE FROM paginas WHERE id = ?");
eval {
    $sth->execute($id);
};
if ($@) {
    print "<html><body><h1>Error al eliminar la página: $@</h1></body></html>";
    $dbh->disconnect();
    exit;
}

# Confirmar eliminación
print "<html><body><h1>¡Página eliminada con éxito!</h1>";
print "<a href='/cgi-bin/list.pl'>Volver al listado</a></body></html>";

$sth->finish();
$dbh->disconnect();
