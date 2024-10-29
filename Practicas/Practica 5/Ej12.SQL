-- Barberia = (codBarberia, razon_social, direccion, telefono)
-- Cliente = (nroCliente, DNI, nombYAp, direccionC, fechaNacimiento, celular)
-- Barbero = (codEmpleado, DNIB, nombYApB, direccionB, telefonoContacto, mail)
-- Atencion = (codEmpleado(fk), fecha, hora, codBarberia(fk), nroCliente(fk),descTratamiento, valor)

-- 1. Listar DNI, nombre y apellido, dirección, fecha de nacimiento y celular de clientes que no tengan
-- atenciones durante 2024.

SELECT c.DNI,c.nombYAp,c.direccionC,c.fechaNacimiento,c.celular
FROM Cliente c NATURAL JOIN Atencion a
EXCEPT (
    SELECT c.DNI,c.nombYAp,c.direccionC,c.fechaNacimiento,c.celular
    FROM Cliente c NATURAL JOIN Atencion a
    WHERE (a.fecha BETWEEN "01/01/2024" AND "31/12/2024")
)

-- 2. Listar para cada barbero cantidad de atenciones que realizaron durante 2023. Listar DNI,
-- nombre y apellido, dirección, teléfono de contacto, mail y cantidad de atenciones.

--IMPORTANTE USAR LEFT JOIN PORQUE NOS INTERESA SI UN BARBERO TUVO 0 ATENCIONES! (creo)
SELECT b.DNIB,b.nombYApB,b.direccionB,b.telefonoContacto,b.mail, COUNT(*) as Cantidad atenciones
FROM Barbero b LEFT JOIN Atencion a ON(b.codEmpleado = a.codEmpleado)
WHERE (a.fecha BETWEEN "01/01/2023" AND "31/12/2024")
GROUP BY b.DNIB,b.nombYApB,b.direccionB,b.telefonoContacto,b.mail

-- 3. Listar razón social, dirección y teléfono de barberías que tengan atenciones para el cliente con
-- DNI 22283566. Ordenar por razón social y dirección ascendente.

SELECT b.razon_social,b.direccion,b.telefono
FROM Barberia b NATURAL JOIN Atencion a NATURAL JOIN Cliente c
WHERE (c.DNI = 22283566)
ORDER BY b.razon_social, b.direccion 

-- 4. Listar DNI, nombre y apellido, dirección, teléfono de contacto y mail de barberos que tengan
-- atenciones con valor superior a $5000.

--Aca no haria left join porque va a comparar con todas las atenciones que hay, por ende si existe una de 5000 la va a mostrar pero no
--me interesan barberos que no hayan tenido esos valores 

SELECT b.DNIB,b.nombYApB,b.direccionB,b.telefonoContacto,b.mail
FROM Barbero b NATURAL JOIN Atencion a
WHERE (a.valor > 5000)

-- 5. Listar DNI, nombYAp, direccionC, fechaNacimiento y celular de clientes que tengan atenciones
-- en la barbería con razón social: ‘Corta barba’ y también se hayan atendido en la barbería con
-- razón social: ‘Barberia Barbara’.

SELECT c.DNI,c.nombYAp,c.direccionC,c.fechaNacimiento,c.celular
FROM Cliente c NATURAL JOIN Atencion a NATURAL JOIN Barberia b 
WHERE (b.razon_social = "Corta Barba")
INTERSECT
SELECT c.DNI,c.nombYAp,c.direccionC,c.fechaNacimiento,c.celular
FROM Cliente c NATURAL JOIN Atencion a NATURAL JOIN Barberia b 
WHERE (b.razon_social = "Barberia Barbara")

-- 6. Eliminar el cliente con DNI 22222222.

DELETE FROM Cliente WHERE DNI = 22222222

DELETE FROM Atencion WHERE nroCliente IN (
    SELECT nroCliente
    FROM Cliente
    WHERE DNI = 22222222
)