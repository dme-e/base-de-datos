DROP DATABASE IF EXISTS Gestion_Personal_Hospitalario;
CREATE DATABASE Gestion_Personal_Hospitalario;
USE Gestion_Personal_Hospitalario;

-- REGIONES
CREATE TABLE REGIONES (
  region_id INT PRIMARY KEY,
  nombre_region VARCHAR(50)
);

-- PAISES
CREATE TABLE PAISES (
  pais_id CHAR(2) PRIMARY KEY,
  nombre_pais VARCHAR(50),
  region_id INT,
  FOREIGN KEY (region_id) REFERENCES REGIONES(region_id)
);

-- HOSPITALES
CREATE TABLE HOSPITALES (
  hospital_id INT PRIMARY KEY,
  ciudad VARCHAR(50),
  provincia VARCHAR(50),
  pais_id CHAR(2),
  FOREIGN KEY (pais_id) REFERENCES PAISES(pais_id)
);

-- CARGOS
CREATE TABLE CARGOS (
  cargo_id VARCHAR(10) PRIMARY KEY,
  nombre_cargo VARCHAR(50),
  salario_min DECIMAL(10,2),
  salario_max DECIMAL(10,2)
);

-- EMPLEADOS
CREATE TABLE EMPLEADOS (
  empleado_id INT PRIMARY KEY,
  nombre VARCHAR(50),
  apellido VARCHAR(50),
  email VARCHAR(100),
  fecha_contratacion DATE,
  cargo_id VARCHAR(10),
  salario DECIMAL(10,2),
  gerente_id INT,
  FOREIGN KEY (cargo_id) REFERENCES CARGOS(cargo_id),
  FOREIGN KEY (gerente_id) REFERENCES EMPLEADOS(empleado_id)
);

-- DEPARTAMENTOS
CREATE TABLE DEPARTAMENTOS (
  departamento_id INT PRIMARY KEY,
  nombre_departamento VARCHAR(50),
  gerente_id INT,
  hospital_id INT,
  FOREIGN KEY (gerente_id) REFERENCES EMPLEADOS(empleado_id),
  FOREIGN KEY (hospital_id) REFERENCES HOSPITALES(hospital_id)
);

-- Añadir columna de departamento
ALTER TABLE EMPLEADOS
ADD COLUMN departamento_id INT,
ADD FOREIGN KEY (departamento_id) REFERENCES DEPARTAMENTOS(departamento_id);

-- HISTORIAL
CREATE TABLE HISTORIAL (
  empleado_id INT,
  fecha_inicio DATE,
  fecha_fin DATE,
  cargo_id VARCHAR(10),
  departamento_id INT,
  PRIMARY KEY (empleado_id, fecha_inicio),
  FOREIGN KEY (empleado_id) REFERENCES EMPLEADOS(empleado_id),
  FOREIGN KEY (cargo_id) REFERENCES CARGOS(cargo_id),
  FOREIGN KEY (departamento_id) REFERENCES DEPARTAMENTOS(departamento_id)
);

-- Inserciones
INSERT INTO REGIONES VALUES (1, 'Costa'), (2, 'Sierra');
INSERT INTO PAISES VALUES ('EC', 'Ecuador', 1), ('PE', 'Perú', 2);
INSERT INTO HOSPITALES VALUES (1, 'Guayaquil', 'Guayas', 'EC'), (2, 'Quito', 'Pichincha', 'EC');
INSERT INTO CARGOS VALUES ('C1', 'Doctor', 1200, 2500), ('C2', 'Enfermero', 800, 1500), ('C3', 'Administrador', 1500, 3000);

-- Inserta empleados correctamente (ahora con todas las columnas)
INSERT INTO EMPLEADOS (empleado_id, nombre, apellido, email, fecha_contratacion, cargo_id, salario, gerente_id)
VALUES
(1, 'Carlos', 'Vera', 'carlos@hospital.com', '2020-05-01', 'C1', 2000, NULL),
(2, 'Lucía', 'Pérez', 'lucia@hospital.com', '2021-02-10', 'C2', 1000, 1),
(3, 'Andrés', 'Gómez', 'andres@hospital.com', '2022-06-15', 'C3', 1800, 1);

INSERT INTO DEPARTAMENTOS VALUES
(1, 'Cardiología', 1, 1),
(2, 'Enfermería', 2, 1),
(3, 'Administración', 3, 2);

UPDATE EMPLEADOS SET departamento_id = 1 WHERE empleado_id = 1;
UPDATE EMPLEADOS SET departamento_id = 2 WHERE empleado_id = 2;
UPDATE EMPLEADOS SET departamento_id = 3 WHERE empleado_id = 3;

INSERT INTO HISTORIAL VALUES
(1, '2020-05-01', '2022-05-01', 'C1', 1),
(2, '2021-02-10', '2023-02-10', 'C2', 2),
(3, '2022-06-15', NULL, 'C3', 3);

SELECT * FROM EMPLEADOS;

SELECT e.nombre, e.apellido, c.nombre_cargo
FROM EMPLEADOS e
JOIN CARGOS c ON e.cargo_id = c.cargo_id;

SELECT d.nombre_departamento, e.nombre AS nombre_gerente, e.apellido AS apellido_gerente
FROM DEPARTAMENTOS d
JOIN EMPLEADOS e ON d.gerente_id = e.empleado_id;

SELECT h.ciudad, d.nombre_departamento
FROM HOSPITALES h
JOIN DEPARTAMENTOS d ON h.hospital_id = d.hospital_id;

SELECT e.nombre, e.apellido, p.nombre_pais
FROM EMPLEADOS e
JOIN DEPARTAMENTOS d ON e.departamento_id = d.departamento_id
JOIN HOSPITALES h ON d.hospital_id = h.hospital_id
JOIN PAISES p ON h.pais_id = p.pais_id;

SELECT e.nombre, h.fecha_inicio, h.fecha_fin
FROM EMPLEADOS e
JOIN HISTORIAL h ON e.empleado_id = h.empleado_id;
