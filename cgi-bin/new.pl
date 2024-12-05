#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);

print header, start_html("Nueva Página");

# Obtener datos del formulario
my $title = param('title') || die "Falta el título";
my $text = param('text') || die "Falta el texto";

# Sanitizar el nombre del archivo
$title =~ s/[^\w-]//g;
my $file_path = "../pages/$title.md";

# Guardar el archivo
open my $fh, '>', $file_path or die "No se pudo crear el archivo: $!";
print $fh $text;
close $fh;

# Confirmar y mostrar enlace al listado
print h1($title);
print pre($text);
print p("Página grabada ", a({ href => "list.pl" }, "Listado de Páginas"));

print end_html;
