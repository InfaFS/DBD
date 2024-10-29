-- Box = (nroBox, m2, ubicación, capacidad, ocupacion) // ocupación es un numérico indicando cantidad
-- de mascotas en el box actualmente, capacidad es una descripción.
-- Mascota = (codMascota,nombre, edad, raza, peso, telefonoContacto)
-- Veterinario = (matricula, CUIT, nombYAp, direccion, telefono)
-- Supervision = (codMascota(fk), nroBox(fk), fechaEntra, fechaSale?, matricula(fk), descripcionEstadia)
-- //fechaSale tiene valor null si la mascota está actualmente en el box

-- 1. Listar para cada veterinario cantidad de supervisiones realizadas con fecha de salida (fechaSale)
-- durante enero de 2024. Indicar matrícula, CUIT, nombre y apellido, dirección, teléfono y cantidad
-- de supervisiones.

SELECT v.matricula,v.CUIT,v.nombreYAp,v.direccion,v.telefono, COUNT(*) as Cantidad supervisiones
FROM Veterinario v NATURAL JOIN Supervision s
WHERE (s.fecha BETWEEN "01/01/2024" AND "12/31/2024")
GROUP BY v.matricula,v.CUIT,v.nombreYAp,v.direccion,v.telefono

-- 2. Listar CUIT, matrícula, nombre, apellido, dirección y teléfono de veterinarios que no tengan
-- mascotas bajo supervisión actualmente

SELECT v.matricula,v.CUIT,v.nombreYAp,v.direccion,v.telefono
FROM Supervision s LEFT JOIN Veterinario v ON(s.matricula = v.matricula)
WHERE (s.fechaSale IS NULL)

-- 3. Listar nombre, edad, raza, peso y teléfono de contacto de mascotas que fueron atendidas por el
-- veterinario ‘Oscar Lopez’. Ordenar por nombre y raza de manera ascendente.

SELECT m.nombre,m.edad,m.raza,m.peso,m.telefonoContacto
FROM Veterinario v NATURAL JOIN Supervision s NATURAL JOIN Mascota m
WHERE (v.nombreYAp = "Oscar Lopez")
ORDER BY m.nombre,m.raza

-- 4. Modificar el nombre y apellido al veterinario con matricula ‘MP 10000’, deberá llamarse: ‘Pablo
-- Lopez’.

UPDATE Veterinario SET nombYAp='Pablo Lopez' WHERE matricula=10000

-- 5. Listar nombre, edad, raza y peso de mascotas que tengan supervisiones con el veterinario con
-- matricula ‘MP 1000’ y con el veterinario con matricula ‘MN 4545’.

SELECT m.nombre,m.edad,m.raza,m.peso
FROM Supervision s NATURAL JOIN Mascota m
WHERE (s.matricula = 1000) 
INTERSECT
SELECT m.nombre,m.edad,m.raza,m.peso
FROM Supervision s NATURAL JOIN Mascota m
WHERE (s.matricula = 4545) 

-- 6. Listar número de box, m2, ubicación, capacidad y nombre de mascota para supervisiones con
-- fecha de entrada durante 2024.

SELECT b.nroBox,b.m2,b.ubicación,b.capacidad,m.nombre
FROM Supervision s NATURAL JOIN Mascota m NATURAL JOIN Box b
WHERE (s.fechaEntra BETWEEN "01/01/2024" AND "31/12/2024")