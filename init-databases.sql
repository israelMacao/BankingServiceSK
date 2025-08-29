-- Script para inicializar las bases de datos y usuarios
-- Este script se ejecutará automáticamente cuando se inicie el contenedor de PostgreSQL

-- Crear usuarios para cada servicio
CREATE USER cliente_user WITH PASSWORD 'cliente_pass123';
CREATE USER cuenta_user WITH PASSWORD 'cuenta_pass123';

-- Crear base de datos para el servicio cliente
CREATE DATABASE "DBcliente"
    WITH
    OWNER = cliente_user
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.utf8'
    LC_CTYPE = 'en_US.utf8'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

-- Crear base de datos para el servicio cuenta
CREATE DATABASE "DBcuenta"
    WITH
    OWNER = cuenta_user
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.utf8'
    LC_CTYPE = 'en_US.utf8'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

-- Conectar a la base de datos del cliente y crear tablas
\c "DBcliente";

-- Crear tablas para el servicio cliente
CREATE TABLE persona (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    genero VARCHAR(1) CHECK (genero IN ('M', 'F')),
    edad INT CHECK (edad >= 0),
    identificacion VARCHAR(20) UNIQUE NOT NULL,
    direccion VARCHAR(255),
    telefono VARCHAR(15)
);

CREATE TABLE cliente (
    id BIGINT PRIMARY KEY REFERENCES persona(id), 
    clienteid VARCHAR(20) UNIQUE, 
    contrasena VARCHAR(20),
    estado BOOLEAN
);

-- Otorgar permisos al usuario cliente
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO cliente_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO cliente_user;
GRANT USAGE ON SCHEMA public TO cliente_user;

-- Conectar a la base de datos de cuentas y crear tablas
\c "DBcuenta";

-- Crear tablas para el servicio cuenta
CREATE TABLE cuenta (
    numeroCuenta INTEGER PRIMARY KEY,
    tipoCuenta VARCHAR(10) NOT NULL CHECK (tipoCuenta IN ('AHORROS', 'CORRIENTE')),
    saldoInicial DECIMAL(15,2) NOT NULL CHECK (saldoInicial >= 0),
    estado BOOLEAN NOT NULL,
    clienteId BIGINT NOT NULL
    -- Nota: La referencia FK se maneja a nivel de aplicación ya que está en otra BD
);

CREATE TABLE movimiento (
    id VARCHAR(36) PRIMARY KEY,
    fecha DATE NOT NULL,
    tipoMovimiento VARCHAR(10) NOT NULL CHECK (tipoMovimiento IN ('DEPOSITO', 'RETIRO')),
    valor DECIMAL(15,2) NOT NULL,
    saldo DECIMAL(15,2) NOT NULL,
    cuentaId INTEGER NOT NULL,
    FOREIGN KEY (cuentaId) REFERENCES cuenta(numeroCuenta) ON DELETE CASCADE
);

-- Otorgar permisos al usuario cuenta
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO cuenta_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO cuenta_user;
GRANT USAGE ON SCHEMA public TO cuenta_user;

-- Insertar datos de prueba en DBcliente
\c "DBcliente";

INSERT INTO persona (nombre, genero, edad, identificacion, direccion, telefono) VALUES
('Juan Pérez', 'M', 30, '1234567890', 'Calle 123 #45-67', '555-1234'),
('María García', 'F', 25, '0987654321', 'Carrera 45 #12-34', '555-5678'),
('Carlos López', 'M', 35, '1122334455', 'Avenida 67 #89-01', '555-9012');

INSERT INTO cliente (id, clienteid, contrasena, estado) VALUES
(1, 'CLI001', 'pass123', true),
(2, 'CLI002', 'pass456', true),
(3, 'CLI003', 'pass789', false);

-- Insertar datos de prueba en DBcuenta
\c "DBcuenta";

INSERT INTO cuenta (numeroCuenta, tipoCuenta, saldoInicial, estado, clienteId) VALUES
(1001, 'AHORROS', 1000.00, true, 1),
(1002, 'CORRIENTE', 500.00, true, 1),
(1003, 'AHORROS', 2000.00, true, 2),
(1004, 'CORRIENTE', 1500.00, false, 3);

INSERT INTO movimiento (id, fecha, tipoMovimiento, valor, saldo, cuentaId) VALUES
('mov-001', '2025-01-01', 'DEPOSITO', 500.00, 1500.00, 1001),
('mov-002', '2025-01-02', 'RETIRO', 200.00, 300.00, 1002),
('mov-003', '2025-01-03', 'DEPOSITO', 1000.00, 3000.00, 1003);