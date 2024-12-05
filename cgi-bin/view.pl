#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);
use Text::Markdown 'markdown';

# Cabeceras
print header, start_html("Visualizar");

# Obtener el nombre del archivo desde el parámetro
my $filename = param('fn') || die "Nombre del archivo no especificado";

# Ruta del archivo Markdown
my $file_path = "../pages/$filename.md";

# Leer el contenido del archivo
open my $fh, '<:utf8', $file_path or die "No se pudo abrir el archivo $file_path: $!";
my $markdown_content = do { local $/; <$fh> };
close $fh;

# Convertir Markdown a HTML
my $html_content = markdown($markdown_content);

# Mostrar el contenido convertido
print h1("Visualizar"),
      a({ href => "list.pl" }, "Retroceder"),
      hr,
      $html_content;

print end_html;
