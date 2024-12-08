use strict;
use warnings;

# Añadir la ruta al directorio de módulos
use lib './url_generator';

# Cargar los módulos
use URLGeneratorBase;
use DisplayURLGenerator;
use AfiliacionURLGenerator;
use EmailingURLGenerator;
use ColaboracionURLGenerator;
use ComparadorPreciosURLGenerator;
use GoogleAdsURLGenerator;
use BingAdsURLGenerator;
use SocialURLGenerator;

my %CSV_TEMPLATES = (
    dy => {
        headers   => "dominio_tracking,sitio,nombre_soporte,nombre_campania,nombre_ubicacion,nombre_banner,formato_banner,nombre_segmento,valor_segmento,url_destino,adid,idfa",
        mandatory => "yes,yes,yes,yes,yes,yes,yes,no,no,yes,no,no",
        example   => "aaa1.cliente.com,cliente-com,amazon,verano_2024,ROS,crea1,300x250,,,https://www.cliente.com?param=example,,",
    },
    # Otros canales como 'af', 'em', 'co', 'cp', 'ga', 'ba', 'sc'...
);

sub show_csv_template {
    my ($channel) = @_;
    my $template = $CSV_TEMPLATES{$channel};
    
    if ($template) {
        print "\nA continuación dispones de la plantilla de las cabeceras del CSV esperado con un ejemplo y con los campos obligatorios para este canal.\n";
        print "\nHEADERS: $template->{headers}\n";
        print "MANDATORY: $template->{mandatory}\n";
        print "EXAMPLE: $template->{example}\n\n";
    } else {
        print "No hay una plantilla disponible para este canal.\n";
    }
}

sub main {
    my ($canal_input, $input_file) = @_;
    
    unless ($canal_input) {
        print "Introduce el nombre del canal para procesar (dy, af, em, co, cp, ga, ba, sc): ";
        chomp($canal_input = <STDIN>);
    }
    
    my %canal_map = (
        dy => 'DisplayURLGenerator',
        af => 'AfiliacionURLGenerator',
        em => 'EmailingURLGenerator',
        co => 'ColaboracionURLGenerator',
        cp => 'ComparadorPreciosURLGenerator',
        ga => 'GoogleAdsURLGenerator',
        ba => 'BingAdsURLGenerator',
        sc => 'SocialURLGenerator',
    );
    
    unless (exists $canal_map{$canal_input}) {
        print "Canal no encontrado. Por favor usa el código correcto.\n";
        return;
    }
    
    show_csv_template($canal_input);
    
    unless ($input_file) {
        print "Por favor, introduce la ruta completa del fichero CSV: ";
        chomp($input_file = <STDIN>);
    }
    
    unless (-e $input_file) {
        print "El fichero $input_file no existe.\n";
        return;
    }
    
    my $generator_class = $canal_map{$canal_input};
    eval "require $generator_class";
    if ($@) {
        die "Error al cargar el generador $generator_class: $@";
    }
    
    my $generator = $generator_class->new($input_file);
    $generator->process_csv();
}

main(@ARGV);