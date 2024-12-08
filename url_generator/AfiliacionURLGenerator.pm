package AfiliacionURLGenerator;

use strict;
use warnings;
use parent 'URLGeneratorBase'; # Hereda de URLGeneratorBase
use URI::Escape;

sub validate_params {
    my ($self, $params) = @_;
    
    # Parámetros obligatorios
    my @required_params = qw(dominio_tracking sitio nombre_soporte nombre_campania nombre_banner formato_banner url_destino);
    
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

sub generate_urls {
    my ($self, $params) = @_;
    
    # Limpiar espacios en blanco y manejar valores nulos
    foreach my $key (keys %$params) {
        $params->{$key} = defined $params->{$key} ? $params->{$key} =~ s/^\s+|\s+$//gr : '';
    }

    # Generar URL de clic (redirección)
    my $url_click_redirect = sprintf(
        "https://%s/dynclick/%s/?eaf-publisher=%s&eaf-name=%s-%s&eaf-creative=%s-%s&eaf-creativetype=%s&eseg-name=%s&eseg-item=%s&eaf-mediaplan=%s&ea-android-adid=%s&ea-ios-idfa=%s&eurl=%s",
        $params->{dominio_tracking}, $params->{sitio}, $params->{nombre_soporte}, $params->{nombre_campania},
        $params->{nombre_soporte}, $params->{nombre_banner}, $params->{formato_banner}, $params->{formato_banner},
        $params->{nombre_segmento} // '', $params->{valor_segmento} // '', $params->{nombre_plan_medios} // '',
        $params->{adid} // '', $params->{idfa} // '', $self->encode_url($params->{url_destino})
    );

    # Generar URL de impresión
    my $url_impression = sprintf(
        '<img src="https://%s/dynview/%s/1x1.b?eaf-publisher=%s&eaf-name=%s-%s&eaf-creative=%s-%s&eaf-creativetype=%s&eseg-name=%s&eseg-item=%s&eaf-mediaplan=%s&ea-android-adid=%s&ea-ios-idfa=%s&ea-rnd=[RANDOM]" border="0" width="1" height="1" />',
        $params->{dominio_tracking}, $params->{sitio}, $params->{nombre_soporte}, $params->{nombre_campania},
        $params->{nombre_soporte}, $params->{nombre_banner}, $params->{formato_banner}, $params->{formato_banner},
        $params->{nombre_segmento} // '', $params->{valor_segmento} // '', $params->{nombre_plan_medios} // '',
        $params->{adid} // '', $params->{idfa} // ''
    );

    # Generar URL de clic (tracking por parámetros)
    my $url_click_params = sprintf(
        "%s?eaf-publisher=%s&eaf-name=%s-%s&eaf-creative=%s-%s&eaf-creativetype=%s&eseg-name=%s&eseg-item=%s&eaf-mediaplan=%s&ea-android-adid=%s&ea-ios-idfa=%s",
        $params->{url_destino}, $params->{nombre_soporte}, $params->{nombre_campania}, $params->{nombre_soporte},
        $params->{nombre_banner}, $params->{formato_banner}, $params->{formato_banner},
        $params->{nombre_segmento} // '', $params->{valor_segmento} // '', $params->{nombre_plan_medios} // '',
        $params->{adid} // '', $params->{idfa} // ''
    );

    return ($url_click_redirect, $url_impression, $url_click_params);
}

sub new {
    my ($class, $input_file) = @_;
    my $self = $class->SUPER::new($input_file);
    $self->{canal} = 'Afiliacion'; # Nombre del canal
    return $self;
}

1;