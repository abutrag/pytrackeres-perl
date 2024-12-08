package DisplayURLGenerator;

use strict;
use warnings;
use parent 'URLGeneratorBase'; # Hereda de URLGeneratorBase
use URI::Escape;

sub validate_params {
    my ($self, $params) = @_;
    
    # Parámetros obligatorios
    my @required_params = qw(dominio_tracking sitio nombre_soporte nombre_campania nombre_ubicacion nombre_banner formato_banner url_destino);
    
    # Limpiar espacios en blanco y manejar valores nulos
    foreach my $key (keys %$params) {
        $params->{$key} = defined $params->{$key} ? $params->{$key} =~ s/^\s+|\s+$//gr : '';
    }
    
    # Verificar parámetros faltantes
    my @missing_params = grep { !exists $params->{$_} || !$params->{$_} } @required_params;
    
    if (@missing_params) {
        die "Faltan parámetros obligatorios: " . join(', ', @missing_params) . "\n";
    }
}

sub adjust_for_special_cases {
    my ($self, $params) = @_;
    my $nombre_soporte = lc $params->{nombre_soporte}; # Convertir a minúsculas para la comparación
    
    if ($nombre_soporte =~ /google/) {
        $params->{nombre_soporte} = 'google-ads';
        $params->{domain_prefix} = 'https://ew3.io/c/a/';
        $params->{domain_prefix_impression} = 'https://ew3.io/v/a/';
    } elsif ($nombre_soporte =~ /amazon/) {
        $params->{nombre_soporte} = 'Amazon';
        $params->{domain_prefix} = 'https://ew3.io/c/a/';
        $params->{domain_prefix_impression} = 'https://ew3.io/v/a/';
    } elsif ($nombre_soporte =~ /outbrain/) {
        $params->{nombre_soporte} = 'Outbrain';
        $params->{domain_prefix} = 'https://ew3.io/c/a/';
        $params->{domain_prefix_impression} = 'https://ew3.io/v/a/';
    } else {
        $params->{domain_prefix} = "https://$params->{dominio_tracking}/dynclick/";
        $params->{domain_prefix_impression} = "https://$params->{dominio_tracking}/dynview/";
    }
    
    return $params;
}

sub generate_urls {
    my ($self, $params) = @_;
    
    # Limpiar espacios en blanco y manejar valores nulos
    foreach my $key (keys %$params) {
        $params->{$key} = defined $params->{$key} ? $params->{$key} =~ s/^\s+|\s+$//gr : '';
    }

    # Ajustar para casos especiales (Google, Amazon, Outbrain)
    $params = $self->adjust_for_special_cases($params);

    # Generar URL de clic (redirección)
    my $url_click_redirect = sprintf(
        "%s%s/?ead-publisher=%s&ead-name=%s-%s&ead-location=%s-%s&ead-creative=%s-%s&ead-creativetype=%s&eseg-name=%s&eseg-item=%s&ead-mediaplan=%s&ea-android-adid=%s&ea-ios-idfa=%s&eurl=%s",
        $params->{domain_prefix}, $params->{sitio}, $params->{nombre_soporte}, $params->{nombre_soporte}, $params->{nombre_campania},
        $params->{nombre_ubicacion}, $params->{formato_banner}, $params->{nombre_banner}, $params->{formato_banner}, $params->{formato_banner},
        $params->{nombre_segmento} // '', $params->{valor_segmento} // '', $params->{nombre_plan_medios} // '',
        $params->{adid} // '', $params->{idfa} // '', $self->encode_url($params->{url_destino})
    );

    # Generar URL de impresión
    my $url_impression = sprintf(
        '<img src="%s%s/1x1.b?ead-publisher=%s&ead-name=%s-%s&ead-location=%s-%s&ead-creative=%s-%s&ead-creativetype=%s&eseg-name=%s&eseg-item=%s&ead-mediaplan=%s&ea-android-adid=%s&ea-ios-idfa=%s&ea-rnd=[RANDOM]" border="0" width="1" height="1" />',
        $params->{domain_prefix_impression}, $params->{sitio}, $params->{nombre_soporte}, $params->{nombre_soporte}, $params->{nombre_campania},
        $params->{nombre_ubicacion}, $params->{formato_banner}, $params->{nombre_banner}, $params->{formato_banner}, $params->{formato_banner},
        $params->{nombre_segmento} // '', $params->{valor_segmento} // '', $params->{nombre_plan_medios} // '',
        $params->{adid} // '', $params->{idfa} // ''
    );

    # Generar URL de clic (tracking por parámetros)
    my $url_click_params = sprintf(
        "%s?ead-publisher=%s&ead-name=%s-%s&ead-location=%s-%s&ead-creative=%s-%s&ead-creativetype=%s&eseg-name=%s&eseg-item=%s&ead-mediaplan=%s&ea-android-adid=%s&ea-ios-idfa=%s",
        $params->{url_destino}, $params->{nombre_soporte}, $params->{nombre_soporte}, $params->{nombre_campania},
        $params->{nombre_ubicacion}, $params->{formato_banner}, $params->{nombre_banner}, $params->{formato_banner}, $params->{formato_banner},
        $params->{nombre_segmento} // '', $params->{valor_segmento} // '', $params->{nombre_plan_medios} // '',
        $params->{adid} // '', $params->{idfa} // ''
    );

    return ($url_click_redirect, $url_impression, $url_click_params);
}

sub new {
    my ($class, $input_file) = @_;
    my $self = $class->SUPER::new($input_file);
    $self->{canal} = 'Display'; # Nombre del canal
    return $self;
}

1; # Fin del paquete