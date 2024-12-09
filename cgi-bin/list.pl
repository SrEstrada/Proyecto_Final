#!/usr/bin/perl
use warnings;
use DBI;

print "Content-type: text/html\n\n";

# my $dsn = "DBI:mysql:wiki:localhost";
# my $user = "root";
# my $password = "";
# my $dbh = DBI->connect($dsn, $user, $password) or die "No se pudo conectar a la base de datos";

# my $sth = $dbh->prepare("SELECT id, titulo FROM paginas");
# $sth->execute();

print "<html><body><h1>Listado de Páginas</h1><ul>";
# while (my @row = $sth->fetchrow_array) {
#     my ($id, $titulo) = @row;
#     print "<li><a href='/cgi-bin/view.pl?id=$id'>$titulo</a> ";
#     print "<a href='/cgi-bin/edit.pl?id=$id'>[E]</a> ";
#     print "<a href='/cgi-bin/delete.pl?id=$id'>[X]</a></li>";
# }
print "</ul><a href='../new.html'>Crear Nueva Página</a></body></html>";

$sth->finish();
$dbh->disconnect();
