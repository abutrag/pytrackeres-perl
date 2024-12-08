# PyTracker (Versión Perl)

**PyTracker** es una herramienta modular de generación de URLs para diferentes canales de marketing digital. Esta versión ha sido desarrollada en Perl, basada en la versión original escrita en Python.

## Características

- **Canales Soportados**:
  - Display
  - Afiliación
  - Emailing
  - Colaboración
  - Comparador de Precios
  - Links patrocinados Google Ads
  - Links patrocinados Bing Ads
  - Social

- **Validación Automática**:
  - Cada canal valida que los parámetros requeridos estén presentes.
  - Generación de URLs específicas para cada canal.

- **Salida en CSV**:
  - Se genera un archivo CSV con las URLs resultantes de cada canal.

## Requisitos

- **Perl 5.10 o superior**
- Módulos requeridos (pueden instalarse con CPAN):
  - `Text::CSV`
  - `URI::Escape`

## Instalación

1. Clona este repositorio:
   ```bash
   git clone https://github.com/abutrag/pytrackeres-perl.git
   cd pytrackeres-perl
   ```

2. Instala los módulos requeridos:
   ```bash
   cpan Text::CSV URI::Escape
   ```

## Uso

1. Ejecuta el archivo `main.pl`:
   ```bash
   perl main.pl
   ```

2. Selecciona el canal a traficar:
   - `dy` para Display
   - `af` para Afiliación
   - `em` para Emailing
   - `co` para Colaboración
   - `cp` para Comparador de Precios
   - `ga` para Links patrocinados Google Ads
   - `ba` para Links patrocinados Bing Ads
   - `sc` para Social

3. Introduce la ruta completa del archivo CSV.

4. El programa generará un archivo CSV con las URLs generadas en la misma carpeta que el archivo de entrada.

## Plantillas de CSV

Cada canal tiene una estructura específica de CSV. Aquí tienes las plantillas para los canales soportados:

### Display

```
HEADERS: dominio_tracking,sitio,nombre_soporte,nombre_campania,nombre_ubicacion,nombre_banner,formato_banner,nombre_segmento,valor_segmento,url_destino,adid,idfa
MANDATORY: yes,yes,yes,yes,yes,yes,yes,no,no,yes,no,no
```

### Afiliación

```
HEADERS: dominio_tracking,sitio,nombre_soporte,nombre_campania,nombre_banner,formato_banner,nombre_segmento,valor_segmento,url_destino,nombre_plan_medios,adid,idfa
MANDATORY: yes,yes,yes,yes,yes,yes,no,no,yes,no,no,no
```

### Emailing

```
HEADERS: dominio_tracking,sitio,nombre_soporte,nombre_campania,mail_usuario,nombre_segmento,valor_segmento,url_destino,nombre_plan_medios,id_cliente,adid,idfa
MANDATORY: yes,yes,yes,yes,no,no,no,yes,no,no,no,no
```

### Colaboración

```
HEADERS: dominio_tracking,sitio,nombre_soporte,nombre_campania,nombre_ubicacion,nombre_banner,formato_banner,nombre_segmento,valor_segmento,url_destino,adid,idfa
MANDATORY: yes,yes,yes,yes,yes,yes,yes,no,no,yes,no,no
```

### Comparador de Precios

```
HEADERS: dominio_tracking,sitio,nombre_soporte,nombre_campania,nombre_banner,nombre_segmento,valor_segmento,url_destino,nombre_plan_medios,adid,idfa
MANDATORY: yes,yes,yes,yes,no,no,no,yes,no,no,no,no
```

### Links patrocinados Google Ads

```
HEADERS: dominio_tracking,sitio,nombre_soporte,nombre_campania,nombre_ubicacion,nombre_banner,formato_banner,nombre_segmento,valor_segmento,url_destino,adid,idfa
MANDATORY: yes,yes,yes,yes,yes,yes,yes,no,no,yes,no,no
```

### Links patrocinados Bing Ads

```
HEADERS: dominio_tracking,sitio,nombre_soporte,nombre_campania,nombre_ubicacion,nombre_banner,formato_banner,nombre_segmento,valor_segmento,url_destino,adid,idfa
MANDATORY: yes,yes,yes,yes,yes,yes,yes,no,no,yes,no,no
```

### Social

```
HEADERS: dominio_tracking,sitio,nombre_soporte,nombre_campania,nombre_ubicacion,nombre_banner,formato_banner,nombre_segmento,valor_segmento,url_destino,nombre_plan_medios,adid,idfa
MANDATORY: yes,yes,yes,yes,yes,yes,yes,no,no,yes,no,no
```

## Contribuciones

Si deseas contribuir a este proyecto, abre un _pull request_ o crea un _issue_ en GitHub.

## Licencia

Este proyecto está bajo la Licencia MIT.
```
