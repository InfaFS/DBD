-- Preguntar si los IN funcionan con campos que se llamen igual o tiene que ser si o si de una tabla del mismo tipo, ejemplo idEntrenador de entrenamiento 
--Tener que comparar con In de idEntrenador de una tabla tambien de entrenamineto y no de entrenador

-- 1. Listar nombre, fecha de nacimiento y dirección de entrenadores que hayan tenido
-- entrenamientos durante 2023.

SELECT e.nombreEntrenador,e.fechaNacimiento,e.direccion
FROM Entrenador e NATURAL JOIN Entrenamiento en
WHERE (en.fecha BETWEEN "01/01/2023" AND "31/12/2023")

-- 2. Listar para cada cancha del complejo “Complejo 1”, la cantidad de entrenamientos que se
-- realizaron durante el 2022. Informar nombre de la cancha y cantidad de entrenamientos.

SELECT c.nombreCancha, COUNT(*) as Cantidad Entrenamientos
FROM Cancha c NATURAL JOIN Complejo com NATURAL JOIN Entrenamiento e
WHERE (com.nombreComplejo = "Complejo 1")  and (e.fecha BETWEEN "01/01/2022" AND "31/12/2022")
GROUP BY c.idCancha, c.nombreCancha

-- 3. Listar los complejos donde haya realizado entrenamientos el entrenador “Jorge Gonzalez”.
-- Informar nombre de complejo, ordenar el resultado de manera ascendente.

SELECT com.nombreComplejo 
FROM Cancha c NATURAL JOIN Complejo com NATURAL JOIN Entrenamiento e NATURAL JOIN Entrenador en
WHERE (en.nombreEntrenador = "Jorge Gonzalez")
ORDER BY com.nombreComplejo

-- 4. Listar nombre, fecha de nacimiento y dirección de entrenadores que hayan entrenado en los
-- clubes con nombre “Everton” y “Estrella de Berisso”.

SELECT en.nombreEntrenador,en.fechaNacimiento,en.direccion
FROM Club c NATURAL JOIN Complejo com NATURAL JOIN Cancha can NATURAL JOIN Entrenamiento e NATURAL JOIN Entrenador en
WHERE (c.nombreClub = "Estrella de Berisso")
INTERSECT
SELECT en.nombreEntrenador,en.fechaNacimiento,en.direccion
FROM Club c NATURAL JOIN Complejo com NATURAL JOIN Cancha can NATURAL JOIN Entrenamiento e NATURAL JOIN Entrenador en
WHERE (c.nombreClub = "Everton")

-- 5. Listar todos los clubes en los que entrena el entrenador “Marcos Perez”. Informar nombre del
-- club y ciudad.
SELECT c.nombreClub, c.ciudad
FROM Club c NATURAL JOIN Complejo com NATURAL JOIN Cancha can NATURAL JOIN Entrenamiento e NATURAL JOIN Entrenador en
WHERE (en.nombreEntrenador = "Marcos Perez")

-- 6 Eliminar los entrenamientos del entrenador ‘Juan Perez’.

DELETE FROM Entrenamiento WHERE idEntrenador IN (
    SELECT idEntrenador
    FROM Entrenador 
    WHERE (nombreEntrenador = "Juan Perez")
) 