#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);

# Cabeceras
print header, start_html("Editar Página");

# Obtener el nombre del archivo desde el parámetro
my $filename = param('fn') || die "Nombre del archivo no especificado";

# Ruta del archivo Markdown
my $file_path = "../pages/$filename.md";

# Leer el contenido actual del archivo
open my $fh, '<:utf8', $file_path or die "No se pudo abrir el archivo $file_path: $!";
my $current_content = do { local $/; <$fh> };
close $fh;

# Mostrar el formulario con el contenido actual prellenado
print h1($filename),
      start_form(-method => 'POST', -action => 'save_edit.pl'),
      hidden(-name => 'filename', -value => $filename),  # Mantener el nombre del archivo
      p("Texto:"),
      textarea(-name => 'content', -rows => 10, -cols => 50, -default => $current_content),
      br,
      submit(-value => 'Enviar'),
      " ",
      a({ href => "list.pl" }, "Cancelar"),
      end_form;

print end_html;
