#!/usr/bin/perl
use warnings;
use DBI;


print "Content-type: text/html\n\n";

my $id = $ENV{'QUERY_STRING'} =~ /id=(\d+)/ ? $1 : 0;

my $dsn = "DBI:mysql:wiki:localhost";
my $user = "root";
my $password = "newpassword";
my $dbh = DBI->connect($dsn, $user, $password) or die "No se pudo conectar a la base de datos";

my $sth = $dbh->prepare("SELECT titulo, contenido FROM paginas WHERE id = ?");
$sth->execute($id);
my ($titulo, $contenido) = $sth->fetchrow_array;

print "<html><body><h1>$titulo</h1>";
print "<div>" . `echo '$contenido' | markdown` . "</div>";
print "<a href='/cgi-bin/list.pl'>Volver</a></body></html>";

$sth->finish();
$dbh->disconnect();