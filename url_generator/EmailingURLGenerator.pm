package EmailingURLGenerator;

use strict;
use warnings;
use parent 'URLGeneratorBase'; # Hereda de URLGeneratorBase
use URI::Escape;

sub validate_params {
    my ($self, $params) = @_;
    
    # Parámetros obligatorios
    my @required_params = qw(dominio_tracking sitio nombre_soporte nombre_campania url_destino);
    
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
        "https://%s/dynclick/%s/?eml-publisher=%s&eml-name=%s-%s&eseg-name=%s&eseg-item=%s&eml-mediaplan=%s&uid=%s&ea-android-adid=%s&ea-ios-idfa=%s&eurl=%s",
        $params->{dominio_tracking}, $params->{sitio}, $params->{nombre_soporte}, $params->{nombre_soporte}, $params->{nombre_campania},
        $params->{nombre_segmento} // '', $params->{valor_segmento} // '', $params->{nombre_plan_medios} // '',
        $params->{id_cliente} // '', $params->{adid} // '', $params->{idfa} // '', $self->encode_url($params->{url_destino})
    );

    # Agregar mail_usuario si está presente
    if ($params->{mail_usuario}) {
        $url_click_redirect .= sprintf("&eemail=%s", $params->{mail_usuario});
    }

    # Generar URL de impresión
    my $url_impression = sprintf(
        '<img src="https://%s/dynview/%s/1x1.b?eml-publisher=%s&eml-name=%s-%s&eseg-name=%s&eseg-item=%s&eml-mediaplan=%s&uid=%s&ea-android-adid=%s&ea-ios-idfa=%s&ea-rnd=[RANDOM]" border="0" width="1" height="1" />',
        $params->{dominio_tracking}, $params->{sitio}, $params->{nombre_soporte}, $params->{nombre_soporte}, $params->{nombre_campania},
        $params->{nombre_segmento} // '', $params->{valor_segmento} // '', $params->{nombre_plan_medios} // '',
        $params->{id_cliente} // '', $params->{adid} // '', $params->{idfa} // ''
    );

    # Generar URL de clic (tracking por parámetros)
    my $url_click_params = sprintf(
        "%s?eml-publisher=%s&eml-name=%s-%s&eseg-name=%s&eseg-item=%s&eml-mediaplan=%s&uid=%s&ea-android-adid=%s&ea-ios-idfa=%s",
        $params->{url_destino}, $params->{nombre_soporte}, $params->{nombre_soporte}, $params->{nombre_campania},
        $params->{nombre_segmento} // '', $params->{valor_segmento} // '', $params->{nombre_plan_medios} // '',
        $params->{id_cliente} // '', $params->{adid} // '', $params->{idfa} // ''
    );

    # Agregar mail_usuario si está presente
    if ($params->{mail_usuario}) {
        $url_click_params .= sprintf("&eemail=%s", $params->{mail_usuario});
    }

    return ($url_click_redirect, $url_impression, $url_click_params);
}

sub new {
    my ($class, $input_file) = @_;
    my $self = $class->SUPER::new($input_file);
    $self->{canal} = 'Emailing'; # Nombre del canal
    return $self;
}

1; # Fin del paquete