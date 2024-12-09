#!/usr/bin/perl
use warnings;
use CGI;

my $cgi = CGI->new;
print $cgi->header();

my $titulo = $cgi->param('titulo');
my $contenido = $cgi->param('contenido');

if ($titulo && $contenido) {
    # my $dsn = "DBI:mysql:wiki:localhost";
    # my $user = "root";
    # my $password = "";
    # my $dbh = DBI->connect($dsn, $user, $password) or die "No se pudo conectar a la base de datos";

    # my $sth = $dbh->prepare("INSERT INTO paginas (titulo, contenido) VALUES (?, ?)");
    # $sth->execute($titulo, $contenido);

    print "<html><body><h1>¡Página creada con éxito!</h1>";
    print "<a href='/cgi-bin/list.pl'>Ver listado</a></body></html>";

    # $sth->finish();
    # $dbh->disconnect();
} else {
    print "<html><body><h1>Error: Faltan datos</h1></body></html>";
}
