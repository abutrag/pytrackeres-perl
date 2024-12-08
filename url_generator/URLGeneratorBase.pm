package URLGeneratorBase;

use strict;
use warnings;
use Text::CSV;
use URI::Escape;
use POSIX qw(strftime);
use Carp;

sub new {
    my ($class, $input_file) = @_;
    my $self = {
        input_file => $input_file,
        urls       => [],
        canal      => 'default_channel', # Cambiar dinámicamente si es necesario
    };
    bless $self, $class;
    return $self;
}

# Método abstracto: implementar en subclases
sub validate_params {
    croak "validate_params debe ser implementado en una subclase";
}

# Método abstracto: implementar en subclases
sub generate_urls {
    croak "generate_urls debe ser implementado en una subclase";
}

sub encode_url {
    my ($self, $url) = @_;
    return uri_escape($url);
}

sub process_csv {
    my ($self) = @_;
    my $csv = Text::CSV->new({ binary => 1, auto_diag => 1 });
    my $input_file = $self->{input_file};

    unless (-e $input_file) {
        print "El archivo $input_file no existe.\n";
        return;
    }

    open my $fh, "<:encoding(utf-8)", $input_file or die "No se puede abrir el archivo $input_file: $!";
    my $header = $csv->getline($fh);
    $csv->column_names(@$header);

    while (my $row = $csv->getline_hr($fh)) {
        eval {
            # Limpiar espacios en blanco y valores nulos
            foreach my $key (keys %$row) {
                $row->{$key} = defined $row->{$key} ? $row->{$key} =~ s/^\s+|\s+$//gr : '';
            }

            # Validar y procesar filas
            $self->validate_params($row);
            my ($url_click_redirect, $url_impression, $url_click_params) = $self->generate_urls($row);
            push @{$self->{urls}}, {
                'URL de Clic (Redireccion)'        => $url_click_redirect,
                'URL de Impresion'                => $url_impression,
                'URL de Clic (Tracking por Parametros)' => $url_click_params,
            };
        };
        if ($@) {
            print "Error en la fila: $row->{id} - $@"; # Agregar clave identificadora si existe
        }
    }

    close $fh;
    $self->write_csv();
}

sub generate_output_filename {
    my ($self) = @_;
    my $now = strftime "%Y_%m_%d_%H_%M_%S", localtime;
    my $canal = $self->{canal} // 'unknown'; # Usa el canal o 'unknown' si no está definido
    return "${now}_urls_${canal}_generadas.csv";
}

sub write_csv {
    my ($self) = @_;
    my $output_file = $self->generate_output_filename();
    my $csv = Text::CSV->new({ binary => 1, eol => $/ });

    open my $fh, ">:encoding(utf-8)", $output_file or die "No se puede escribir el archivo $output_file: $!";

    # Escribir las cabeceras del CSV
    $csv->say($fh, ['URL de Clic (Redireccion)', 'URL de Impresion', 'URL de Clic (Tracking por Parametros)']);

    # Escribir las filas generadas
    foreach my $url (@{$self->{urls}}) {
        $csv->say($fh, [
            $url->{'URL de Clic (Redireccion)'},
            $url->{'URL de Impresion'},
            $url->{'URL de Clic (Tracking por Parametros)'}
        ]);
    }

    close $fh;
    print "Las URLs generadas se han guardado en $output_file.\n";
}

1;