use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'pytrackeres',
    VERSION      => '1.0.4',
    AUTHOR       => 'abutrag <a.butragueno@eulerian.com>',
    ABSTRACT     => 'Herramienta para la generación de URLs de tracking en Eulerian.',
    LICENSE      => 'MIT',
    PREREQ_PM    => {},
    EXE_FILES    => ['main.pl'], # Punto de entrada principal
    META_MERGE   => {
        resources => {
            homepage    => 'https://github.com/abutrag/pytrackeres',
        },
    },
    MIN_PERL_VERSION => '5.010',
);