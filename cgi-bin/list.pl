#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);

print header, start_html("Listado de Páginas Wiki");

print h1("Nuestras páginas de wiki");

my $directory = "../pages"; # Directorio donde se almacenan las páginas
mkdir $directory unless -d $directory;

# Listar archivos
opendir(my $dh, $directory) or die "No se puede abrir el directorio: $!";
while (my $file = readdir($dh)) {
    next if $file =~ /^\./; # Ignorar archivos ocultos
    next unless $file =~ /\.md$/; # Solo archivos Markdown

    my $file_path = "$directory/$file";
    my $name = $file;
    $name =~ s/\.md$//;

    print li(
        a({ href => "view.pl?fn=$name" }, $name),
        " ",
        a({ href => "edit.pl?fn=$name" }, "[E]"),
        " ",
        a({ href => "delete.pl?fn=$name" }, "[X]")
    );
}
closedir($dh);

print a({ href => "new.html" }, "Nueva Página");
print "<br>", a({ href => "index.html" }, "Volver al Inicio");

print end_html;
