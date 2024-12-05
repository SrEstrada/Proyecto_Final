#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);

# Cabeceras
print header;

# Obtener el nombre del archivo desde el parámetro
my $filename = param('fn') || die "Nombre del archivo no especificado";

# Ruta del archivo Markdown
my $file_path = "../pages/$filename.md";

# Eliminar el archivo
unlink $file_path or die "No se pudo eliminar el archivo $file_path: $!";

# Confirmar y redirigir al listado
print p("El archivo ha sido eliminado."),
      a({ href => "list.pl" }, "Volver al listado");
