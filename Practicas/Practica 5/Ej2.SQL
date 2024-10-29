--Preguntar la parte de como hacer en SQL (segun la catedra) cuando te piden SOLO, y como funciona exactamente el HAVING

-- 1. Listar especie, años, calle, nro y localidad de árboles podados por el podador ‘Juan Perez’ y por
-- el podador ‘Jose Garcia’.

SELECT a.especie,a.anios,a.calle,a.nro,l.nombreL
FROM Podador pd NATURAL JOIN Poda p NATURAL JOIN Arbol a NATURAL JOIN Localidad l
WHERE (pd.nombre = "Juan") and (pd.apellido = "Perez") AND a.nroArbol IN (
SELECT
FROM Podador pd NATURAL JOIN Poda p NATURAL JOIN Arbol a
WHERE (pd.nombre = "Jose") and (pd.apellido = "Garcia")
)

--Podemos tambien hacer una interseccion de dos tablas con esquemas iguales en donde uno es para juan perez y el otro para
--Jose garcia

-- 2. Reportar DNI, nombre, apellido, fecha de nacimiento y localidad donde viven de aquellos
-- podadores que tengan podas realizadas durante 2023.

SELECT p.DNI,p.nombre,p.apellido,p.fnac,l.nombreL
FROM Podador pd NATURAL JOIN Poda p INNER JOIN Localidad l ON (pd.codigoPostalVive = l.codigoPostal)
WHERE (p.fecha BETWEEN "01/01/2023" and "31/12/2023")

-- 3. Listar especie, años, calle, nro y localidad de árboles que no fueron podados nunca.

SELECT especie,anios,calle,nro,l.nombreL
FROM Arbol a NATURAL JOIN Localidad l
EXCEPT (
SELECT especie,anios,calle,nro,l.nombreL
FROM Arbol a NATURAL JOIN Localidad l NATURAL JOIN Poda
)

--Solucion 2

SELECT a.especie, a.años, a.calle, a.nro, l.nombreL
FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.CodigoPostal)
    LEFT JOIN Poda po ON (a.nroArbol = po.nroArbol)
WHERE po.nroArbol IS NULL

-- 4. Reportar especie, años,calle, nro y localidad de árboles que fueron podados durante 2022 y no
-- fueron podados durante 2023.

SELECT a.especie,a.anios,a.calle,a.nroArbol,l.nombreL
FROM Arbol a NATURAL JOIN Localidad l NATURAL JOIN Poda p
WHERE (p.fecha BETWEEN "01/01/2022" AND "31/12/2022") and a.nroArbol NOT IN (
SELECT a.nroArbol
FROM Arbol a NATURAL JOIN Poda p
WHERE (p.fecha BETWEEN "01/01/2023" AND "31/12/2023")
)

-- 5 Reportar DNI, nombre, apellido, fecha de nacimiento y localidad donde viven de aquellos
-- podadores con apellido terminado con el string ‘ata’ y que tengan al menos una poda durante
-- 2024. Ordenar por apellido y nombre.

SELECT p.DNI,p.nombre,p.apellido,p.fnac,l.nombreL
FROM Podador p INNER JOIN Localidad l ON (p.codigoPostalVive = l.codigoPostal)
WHERE (p.apellido LIKE ("%ata")) AND p.DNI IN (
SELECT po.DNI
FROM Poda po
WHERE po.fecha BETWEEN "01/01/2024" AND "31/12/2024"
)

-- 6. Listar DNI, apellido, nombre, teléfono y fecha de nacimiento de podadores que solo podaron
-- árboles de especie ‘Coníferas’.

--CHEQUEAR PORQUE NO SE SI ESTA BIEN, DUDAS CUANDO HAY QUE HACER "SOLO"

SELECT p.DNI, p.nombre, p.apellido, p.telefono, p.fnac
FROM Podador p INNER JOIN Poda po ON (p.DNI = po.DNI)
    INNER JOIN Arbol a ON (po.nroArbol = a.nroArbol)
WHERE a.especie = "Coniferas" 
EXCEPT (
    SELECT p.DNI, p.nombre, p.apellido, p.telefono, p.fnac
    FROM Podador p INNER JOIN Poda po ON (p.DNI = po.DNI)
        INNER JOIN Arbol a ON (po.nroArbol = a.nroArbol)
        WHERE NOT (a.especie = "Coniferas")
)

--Agarra a los que NO podaron especie coniferas

-- Listar especies de árboles que se encuentren en la localidad de ‘La Plata’ y también en la
-- localidad de ‘Salta’.

SELECT a.especie
FROM Arbol a NATURAL JOIN Localidad l 
where (l.nombreL = "La Plata") and a.nroArbol IN (
    SELECT a.nroArbol
    FROM Arbol a NATURAL JOIN Localidad l
    where (l.nombreL = "Salta")
)

--Solucion alternativa
SELECT a.especie
FROM Arbol a NATURAL JOIN Localidad l 
where (l.nombreL = "La Plata") 
INTERSECT
SELECT a.especie
FROM Arbol a NATURAL JOIN Localidad l
where (l.nombreL = "Salta")

-- Eliminar el podador con DNI 22234566.

DELETE FROM Poda WHERE DNI=22234566
DELETE FROM Podador WHERE DNI=22234566

-- Reportar nombre, descripción y cantidad de habitantes de localidades que tengan menos de 100
-- árboles.

SELECT l.nombreL,l.descripcion,l.habitantes 
FROM Arbol a NATURAL JOIN Localidad l
GROUP BY l.CodigoPostal, l.nombreL, l.descripcion, l.habitantes
HAVING COUNT(*) < 100