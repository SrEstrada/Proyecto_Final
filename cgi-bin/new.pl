#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);

print header, start_html("Nueva Página");

print start_form(-method => 'POST', -action => 'save.pl'),
      p("Nombre de la nueva página:"),
      textfield(-name => 'name'),
      p("Contenido:"),
      textarea(-name => 'content', -rows => 10, -cols => 50),
      br,
      submit(-value => 'Guardar'),
      end_form;

print "<br>", a({ href => "list.pl" }, "Volver al Listado");

print end_html;
