-- LIMPIEZA DE TABLAS

DROP TABLE region CASCADE CONSTRAINTS PURGE;

DROP TABLE nacionalidad CASCADE CONSTRAINTS PURGE;

DROP TABLE escuela CASCADE CONSTRAINTS PURGE;

DROP TABLE idioma CASCADE CONSTRAINTS PURGE;

DROP TABLE comuna CASCADE CONSTRAINTS PURGE;

DROP TABLE asociacion CASCADE CONSTRAINTS PURGE;

DROP TABLE club_futbol CASCADE CONSTRAINTS PURGE;

DROP TABLE trabajador CASCADE CONSTRAINTS PURGE;

DROP TABLE jugador CASCADE CONSTRAINTS PURGE;

DROP TABLE trabajador_planta CASCADE CONSTRAINTS PURGE;

DROP TABLE dominio_idioma CASCADE CONSTRAINTS PURGE;

DROP TABLE historial_club CASCADE CONSTRAINTS PURGE;

DROP SEQUENCE seq_club;

--SECUENCIAS
--secuencia club_futbol

CREATE SEQUENCE seq_club START WITH 703 INCREMENT BY 4;

-- CREACION DE TABLAS
CREATE TABLE region (
    id_region     NUMBER(2),
    nombre_region VARCHAR2(50) NOT NULL,
    CONSTRAINT pk_region PRIMARY KEY ( id_region )
);

CREATE TABLE nacionalidad (
    id_nacion   NUMBER(4)
        GENERATED ALWAYS AS IDENTITY ( START WITH 210 INCREMENT BY 2 ),
    descripcion VARCHAR(30) NOT NULL,
    CONSTRAINT pk_nacionalidad PRIMARY KEY ( id_nacion )
);

CREATE TABLE escuela (
    id_escuela      NUMBER(4),
    nombre_escuela  VARCHAR(50) NOT NULL,
    capacidad       NUMBER(4) NOT NULL,
    fecha_fundacion DATE NOT NULL,
    CONSTRAINT pk_escuela PRIMARY KEY ( id_escuela )
);

CREATE TABLE idioma (
    id_idioma     NUMBER(3),
    nombre_idioma VARCHAR2(30) NOT NULL,
    CONSTRAINT pk_id_idioma PRIMARY KEY ( id_idioma )
);

CREATE TABLE comuna (
    id_comuna     NUMBER(4),
    nombre_comuna VARCHAR2(30) NOT NULL,
    id_region     NUMBER(2) NOT NULL,
    CONSTRAINT pk_comuna PRIMARY KEY ( id_comuna ),
    CONSTRAINT fk_comuna_region FOREIGN KEY ( id_region )
        REFERENCES region ( id_region )
);

CREATE TABLE asociacion (
    id_asociacion     NUMBER(4),
    nombre_asociacion VARCHAR2(50) NOT NULL,
    fecha_creacion    DATE NOT NULL,
    tipo_asociacion   CHAR(1) NOT NULL,
    CONSTRAINT pk_asociacion PRIMARY KEY ( id_asociacion ),
    CONSTRAINT ck_asociacion_fecha CHECK ( fecha_creacion >= TO_DATE('31-12-1980', 'DD-MM-YYYY') ),
    CONSTRAINT ck_tipo_asociacion CHECK ( tipo_asociacion IN ( 'P', 'A' ) )
);

CREATE TABLE club_futbol (
    id_club     NUMBER(5),
    nombre_club VARCHAR2(50) NOT NULL,
    patrimonio  NUMBER(12) NOT NULL,
    direccion   VARCHAR2(60) NOT NULL,
    tipo_club   VARCHAR(20) NOT NULL,
    CONSTRAINT pk_club_futbol PRIMARY KEY ( id_club ),
    CONSTRAINT un_nombre_club UNIQUE ( nombre_club )
);

CREATE TABLE trabajador (
    nro_inscripcion  NUMBER(6),
    rut              NUMBER(8) NOT NULL,
    dv               CHAR(1) NOT NULL,
    primer_nombre    VARCHAR2(30) NOT NULL,
    segundo_nombre   VARCHAR2(30),
    apellido_paterno VARCHAR2(30) NOT NULL,
    apellido_materno VARCHAR2(30) NOT NULL,
    sueldo_base      NUMBER(9) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    genero           CHAR(1) NOT NULL,
    estado_civil     VARCHAR2(20) NOT NULL,
    telefono         VARCHAR2(12) NOT NULL,
    email            VARCHAR2(50),
    id_comuna        NUMBER(4) NOT NULL,
    id_nacionalidad  NUMBER(4) NOT NULL,
    CONSTRAINT pk_trabajador PRIMARY KEY ( nro_inscripcion ),
    CONSTRAINT un_trabajador_rut UNIQUE ( rut ),
    CONSTRAINT fk_trabajador_nacionalidad FOREIGN KEY ( id_nacionalidad )
        REFERENCES nacionalidad ( id_nacion ),
    CONSTRAINT fk_trabajador_comuna FOREIGN KEY ( id_comuna )
        REFERENCES comuna ( id_comuna )
);

CREATE TABLE jugador (
    nro_inscripcion     NUMBER(6),
    posicion            VARCHAR2(20) NOT NULL,
    monto_premios_total NUMBER(10) NOT NULL,
    anio_graduacion     NUMBER(4),
    id_asociacion       NUMBER(4) NOT NULL,
    id_escuela          NUMBER(4),
    CONSTRAINT pk_jugador PRIMARY KEY ( nro_inscripcion ),
    CONSTRAINT fk_jugador_trabajador FOREIGN KEY ( nro_inscripcion )
        REFERENCES trabajador ( nro_inscripcion ),
    CONSTRAINT fk_jugador_asociacion FOREIGN KEY ( id_asociacion )
        REFERENCES asociacion ( id_asociacion ),
    CONSTRAINT fk_jugador_escuela FOREIGN KEY ( id_escuela )
        REFERENCES escuela ( id_escuela )
);

CREATE TABLE trabajador_planta (
    nro_inscripcion       NUMBER(6),
    valor_sobretiempo     NUMBER(8),
    sobretiempo_acumulado NUMBER(4),
    CONSTRAINT pk_trabajador_planta PRIMARY KEY ( nro_inscripcion ),
    CONSTRAINT fk_trabajador_planta_trabajador FOREIGN KEY ( nro_inscripcion )
        REFERENCES trabajador ( nro_inscripcion )
);

CREATE TABLE dominio_idioma (
    nro_jugador_inscripcion NUMBER(6),
    id_idioma               NUMBER(3),
    nivel_dominio           NUMBER(1) NOT NULL,
    CONSTRAINT pk_dominio_idioma PRIMARY KEY ( nro_jugador_inscripcion,
                                               id_idioma ),
    CONSTRAINT fk_dominio_idioma_jugador FOREIGN KEY ( nro_jugador_inscripcion )
        REFERENCES jugador ( nro_inscripcion ),
    CONSTRAINT fk_dominio_idioma_idioma FOREIGN KEY ( id_idioma )
        REFERENCES idioma ( id_idioma )
);

CREATE TABLE historial_club (
    nro_jugador_inscripcion NUMBER(6),
    id_club                 NUMBER(5),
    fecha_inicio            DATE NOT NULL,
    fecha_termino           DATE,
    CONSTRAINT pk_historial_club PRIMARY KEY ( nro_jugador_inscripcion,
                                               id_club,
                                               fecha_inicio ),
    CONSTRAINT fk_historial_jugador FOREIGN KEY ( nro_jugador_inscripcion )
        REFERENCES jugador ( nro_inscripcion ),
    CONSTRAINT fk_historial_club FOREIGN KEY ( id_club )
        REFERENCES club_futbol ( id_club )
);

-- POBLAMIENTO DE TABLAS

--  tabla region
INSERT INTO region (
    id_region,
    nombre_region
) VALUES (
    1,
    'ARICA Y PARINACOTA Y TARAPACA'
);

INSERT INTO region (
    id_region,
    nombre_region
) VALUES (
    2,
    'ANTOFAGASTA'
);

INSERT INTO region (
    id_region,
    nombre_region
) VALUES (
    3,
    'ATACAMA Y COQUIMBO'
);

INSERT INTO region (
    id_region,
    nombre_region
) VALUES (
    5,
    'VALPARAISO'
);

INSERT INTO region (
    id_region,
    nombre_region
) VALUES (
    13,
    'METROPOLITANA'
);
-- tabla comuna
INSERT INTO comuna (
    id_comuna,
    id_region,
    nombre_comuna
) VALUES (
    101,
    13,
    'Santiago'
);

INSERT INTO comuna (
    id_comuna,
    id_region,
    nombre_comuna
) VALUES (
    102,
    5,
    'Valparaiso'
);

INSERT INTO comuna (
    id_comuna,
    id_region,
    nombre_comuna
) VALUES (
    103,
    8,
    'Concepcion'
);

INSERT INTO comuna (
    id_comuna,
    id_region,
    nombre_comuna
) VALUES (
    104,
    2,
    'Antofagasta'
);

INSERT INTO comuna (
    id_comuna,
    id_region,
    nombre_comuna
) VALUES (
    105,
    16,
    'Chillan'
);
-- tabla nacionalidad
INSERT INTO nacionalidad ( descripcion ) VALUES ( 'Chilena' );

INSERT INTO nacionalidad ( descripcion ) VALUES ( 'Argentina' );

INSERT INTO nacionalidad ( descripcion ) VALUES ( 'Peruana' );

INSERT INTO nacionalidad ( descripcion ) VALUES ( 'Boliviana' );

INSERT INTO nacionalidad ( descripcion ) VALUES ( 'Brasileña' );
-- tabla asociacion
INSERT INTO asociacion (
    id_asociacion,
    nombre_asociacion,
    fecha_creacion,
    tipo_asociacion
) VALUES (
    25,
    'ASOCIACION DE FUTBOL DE SANTIAGO',
    TO_DATE('15-05-2001', 'DD-MM-YYYY'),
    'P'
);

INSERT INTO asociacion (
    id_asociacion,
    nombre_asociacion,
    fecha_creacion,
    tipo_asociacion
) VALUES (
    26,
    'ASOCIACION NACIONAL DE FUTBOL AMATEUR',
    TO_DATE('10-03-1998', 'DD-MM-YYYY'),
    'A'
);

INSERT INTO asociacion (
    id_asociacion,
    nombre_asociacion,
    fecha_creacion,
    tipo_asociacion
) VALUES (
    27,
    'ASOCIACION DE FUTBOL DE VALPARAISO',
    TO_DATE('27-07-1997', 'DD-MM-YYYY'),
    'P'
);

INSERT INTO asociacion (
    id_asociacion,
    nombre_asociacion,
    fecha_creacion,
    tipo_asociacion
) VALUES (
    28,
    'ASOCIACION DE FUTBOL DE CONCEPCION',
    TO_DATE('30-11-1995', 'DD-MM-YYYY'),
    'A'
);

INSERT INTO asociacion (
    id_asociacion,
    nombre_asociacion,
    fecha_creacion,
    tipo_asociacion
) VALUES (
    29,
    'ASOCIACION DE FUTBOL DE ANTOFAGASTA',
    TO_DATE('25-06-2003', 'DD-MM-YYYY'),
    'P'
);

INSERT INTO asociacion (
    id_asociacion,
    nombre_asociacion,
    fecha_creacion,
    tipo_asociacion
) VALUES (
    30,
    'ASOCIACION DE FUTBOL DE TEMUCO',
    TO_DATE('12-01-2010', 'DD-MM-YYYY'),
    'A'
);

INSERT INTO asociacion (
    id_asociacion,
    nombre_asociacion,
    fecha_creacion,
    tipo_asociacion
) VALUES (
    31,
    'ASOCIACION DE FUTBOL DE RANCAGUA',
    TO_DATE('08-09-1999', 'DD-MM-YYYY'),
    'P'
);

INSERT INTO asociacion (
    id_asociacion,
    nombre_asociacion,
    fecha_creacion,
    tipo_asociacion
) VALUES (
    32,
    'ASOCIACION DE FUTBOL DE PUERTO MONTT',
    TO_DATE('20-04-2005', 'DD-MM-YYYY'),
    'A'
);

INSERT INTO asociacion (
    id_asociacion,
    nombre_asociacion,
    fecha_creacion,
    tipo_asociacion
) VALUES (
    33,
    'ASOCIACION DE FUTBOL DE LA SERENA',
    TO_DATE('14-08-2012', 'DD-MM-YYYY'),
    'P'
);

INSERT INTO asociacion (
    id_asociacion,
    nombre_asociacion,
    fecha_creacion,
    tipo_asociacion
) VALUES (
    34,
    'ASOCIACION DE FUTBOL DE CHILLAN',
    TO_DATE('01-12-2018', 'DD-MM-YYYY'),
    'A'
);
-- tabla club_futbol
INSERT INTO club_futbol (
    id_club,
    nombre_club,
    patrimonio,
    direccion,
    tipo_club
) VALUES (
    seq_club.NEXTVAL,
    'Colo-Colo',
    '500000000',
    'Av. Marathon 5300',
    'Profesional'
);

INSERT INTO club_futbol (
    id_club,
    nombre_club,
    patrimonio,
    direccion,
    tipo_club
) VALUES (
    seq_club.NEXTVAL,
    'Universidad de Chile',
    '450000000',
    'Av. El Parron 0931',
    'Profesional'
);

INSERT INTO club_futbol (
    id_club,
    nombre_club,
    patrimonio,
    direccion,
    tipo_club
) VALUES (
    seq_club.NEXTVAL,
    'Deportes Antofagasta',
    '180000000',
    'Avenida Angamos 01606',
    'Profesional'
);

INSERT INTO club_futbol (
    id_club,
    nombre_club,
    patrimonio,
    direccion,
    tipo_club
) VALUES (
    seq_club.NEXTVAL,
    'Huachipato',
    '220000000',
    'Avenida Desiderio Garcia 909',
    'Profesional'
);

INSERT INTO club_futbol (
    id_club,
    nombre_club,
    patrimonio,
    direccion,
    tipo_club
) VALUES (
    seq_club.NEXTVAL,
    'Ñublense',
    '170000000',
    'Avenida Pedro Aguirre Cerda 1003',
    'Profesional'
);

-- RECUPERACION DE DATOS

--informe 1

SELECT
    'ID '
    || id_asociacion
    || '*'
    || nombre_asociacion AS "ASOCIACION",
    fecha_creacion       AS "CREADA",
    tipo_asociacion      AS "TIPO"
FROM
    asociacion
WHERE
        tipo_asociacion = 'P'
    AND fecha_creacion > TO_DATE('31-12-2000', 'DD-MM-YYYY')
ORDER BY
    fecha_creacion DESC;
    
-- informe 2

SELECT
    id_club          AS "CLUB",
    nombre_club      AS "NOMBRE CLUB",
    patrimonio       AS "PATRIMONIO EN PESOS",
    patrimonio / 955 AS "PATRIMONIO EN DOLARES"
FROM
    club_futbol
WHERE
    nombre_club LIKE '%a%'
    AND patrimonio > 200000000
    AND tipo_club = 'Profesional'
ORDER BY
    id_club DESC;


COMMIT;