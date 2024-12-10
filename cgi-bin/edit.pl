#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

# Crear objeto CGI
my $cgi = CGI->new;

# Generar encabezado HTTP
print $cgi->header();

# Capturar parámetros
my $id = $cgi->param('id');
my $nuevo_titulo = $cgi->param('titulo');
my $nuevo_contenido = $cgi->param('contenido');

# Validar ID
if (!$id) {
    print "<html><body><h1>Error: No se proporcionó un ID válido</h1>";
    print "<a href='/cgi-bin/list.pl'>Volver al listado</a></body></html>";
    exit;
}

# Conectar a la base de datos
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

# Si se recibió nuevo título y contenido, actualiza la página
if ($nuevo_titulo && $nuevo_contenido) {
    my $contenido_html_actualizado = `echo '$nuevo_contenido' | markdown`;
    my $sth_update = $dbh->prepare("UPDATE paginas SET titulo = ?, contenido = ? WHERE id = ?");
    eval {
        $sth_update->execute($nuevo_titulo, $contenido_html_actualizado, $id);
    };
    if ($@) {
        print "<html><body><h1>Error al actualizar la página: $@</h1></body></html>";
        $dbh->disconnect();
        exit;
    }
    print "<html><body><h1>¡Página actualizada con éxito!</h1>";
    print "<a href='/cgi-bin/list.pl'>Volver al listado</a></body></html>";
    $sth_update->finish();
    $dbh->disconnect();
    exit;
}

# Mostrar formulario con contenido actual para editar
my $sth = $dbh->prepare("SELECT titulo, contenido FROM paginas WHERE id = ?");
$sth->execute($id);
my ($titulo_actual, $contenido_html_actual) = $sth->fetchrow_array;

if (!$titulo_actual) {
    print "<html><body><h1>Error: No se encontró una página con el ID especificado</h1>";
    print "<a href='/cgi-bin/list.pl'>Volver al listado</a></body></html>";
    $sth->finish();
    $dbh->disconnect();
    exit;
}

# Convertir HTML a Markdown si es necesario (opcional)
my $contenido_markdown_actual = $contenido_html_actual; # Aquí podrías revertir HTML a Markdown si es necesario.

print <<HTML;
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Página</title>
    <link rel="stylesheet" href="/css/styles.css">
</head>
<body>
    <h1>Editar Pagina</h1>
    <form action="/cgi-bin/edit.pl" method="post">
        <input type="hidden" name="id" value="$id">
        <label for="titulo">Título:</label><br>
        <input type="text" id="titulo" name="titulo" value="$titulo_actual" required><br><br>
        <label for="contenido">Contenido (Markdown):</label><br>
        <textarea id="contenido" name="contenido" rows="10" cols="50" required>$contenido_markdown_actual</textarea><br><br>
        <input type="submit" value="Actualizar Pagina">
    </form>
    <a href="/cgi-bin/list.pl">Volver al listado</a>
</body>
</html>
HTML

$sth->finish();
$dbh->disconnect();
