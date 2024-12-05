#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);
use Text::Markdown 'markdown';

print header, start_html("Ver Página");

my $file = param('file') || die "Archivo no especificado";
my $file_path = "../pages/$file.md";

open my $fh, '<', $file_path or die "No se puede abrir el archivo: $!";
my $content = do { local $/; <$fh> };
close $fh;

print h1($file);
print div({ style => "border: 1px solid #ccc; padding: 10px;" }, markdown($content));
print "<br>", a({ href => "list.pl" }, "Volver al Listado");

print end_html;
