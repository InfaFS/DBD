/* 1 */
SELECT nombre,apellido,DNI,telefono,direccion
FROM Cliente
WHERE (apellido LIKE ("Pe%"))
ORDER BY DNI 

-- Listar nombre, apellido, DNI, teléfono y dirección de clientes que realizaron compras solamente
-- durante 2017.

SELECT nombre,apellido,DNI,telefono,direccion
FROM Cliente c NATURAL JOIN Factura f
WHERE (f.fecha BETWEEN 01/01/2017 and 31/12/2017)
EXCEPT (
SELECT nombre,apellido,DNI,telefono,direccion
FROM Cliente c NATURAL JOIN Factura f
WHERE (f.fecha < 01/01/2017 and f.fecha > 31/12/2017)
)

-- 3. Listar nombre, descripción, precio y stock de productos vendidos al cliente con DNI 45789456,
-- pero que no fueron vendidos a clientes de apellido ‘Garcia’.

SELECT p.nombreP,p.descripción,p.precio,p.preciounitario
FROM Cliente c NATURAL JOIN Factura f NATURAL JOIN Detalle d NATURAL JOIN Producto p
WHERE (c.DNI = 45789456)
EXCEPT (
SELECT p.nombreP,p.descripción,p.precio,p.preciounitario
FROM Cliente c NATURAL JOIN Factura f NATURAL JOIN Detalle d NATURAL JOIN Producto p
WHERE (c.apellido = "Garcia")
)

-- 4. Listar nombre, descripción, precio y stock de productos no vendidos a clientes que tengan
-- teléfono con característica 221 (la característica está al comienzo del teléfono). Ordenar por
-- nombre.
--Me pide productos que NO fueron vendidos a esa persona, peuden ser productos que nunca se hayan vendido tambien, como no aclara tomamos todos los productos
SELECT p.nombreP,p.descripción,p.precio,p.stock
from p Producto
WHERE p.idProducto NOT IN (
SELECT d.idProducto
FROM Cliente c NATURAL JOIN Factura f NATURAL JOIN Detalle d 
WHERE (c.telefono NOT LIKE ("221%"))
)
ORDER BY p.nombreP

-- 5. Listar para cada producto nombre, descripción, precio y cuantas veces fue vendido. Tenga en
-- cuenta que puede no haberse vendido nunca el producto.
--Como funciona el group by bien?

SELECT p.nombreP, p.descripcion, p.precio, p.stock, SUM (d.cantidad) as Cantidad --SI no hacemos el sum no se podra juntar en una sola tupla todas las tuplas resultantes para cada producto
FROM Producto p LEFT JOIN Detalle d ON (p.idProducto = d.idProducto)
GROUP BY p.idProducto, p.nombreP, p.descripcion, p.precio --El group by lo necesita para juntar todas las tablas que encontro en una, dependiendo los criterios
--Por ejemplo aca junta tablas segun los 4 criterios en una sola tupla

-- 6. Listar nombre, apellido, DNI, teléfono y dirección de clientes que compraron los productos con
-- nombre ‘prod1’ y ‘prod2’ pero nunca compraron el producto con nombre ‘prod3’.

SELECT c.nombre,c.apellido,c.telefono,c.DNI,c.direccion 
FROM Cliente c NATURAL JOIN Factura f NATURAL JOIN Detalle d NATURAL JOIN Producto p
WHERE (p.nombreP = "prod1")  and (c.idCliente IN (
SELECT c.idCliente
FROM Cliente c NATURAL JOIN Factura f NATURAL JOIN Detalle d NATURAL JOIN Producto p    
Where (p.nombreP = "prod2")))
EXCEPT (
SELECT c.nombre,c.apellido,c.telefono,c.DNI,c.direccion 
FROM Cliente c NATURAL JOIN Factura f NATURAL JOIN Detalle d NATURAL JOIN Producto p
WHERE (p.nombreP = "prod3"))

-- 7. Listar nroTicket, total, fecha, hora y DNI del cliente, de aquellas facturas donde se haya
-- comprado el producto ‘prod38’ o la factura tenga fecha de 2019.

SELECT f.nroTicket,f.total,f.fecha,f.hora,c.DNI 
FROM Cliente c NATURAL JOIN Factura f NATURAL JOIN Detalle d NATURAL JOIN Producto p
WHERE (p.nombreP = "prod38") OR (f.fecha BETWEEN 01/01/2019 and 31/12/2019)

-- Agregar un cliente con los siguientes datos: nombre:’Jorge Luis’, apellido:’Castor’, DNI:
-- 40578999, teléfono: ‘221-4400789’, dirección:’11 entre 500 y 501 nro:2587’ y el id de cliente:
-- 500002. Se supone que el idCliente 500002 no existe.

INSERT INTO Cliente (idCliente,nombre,apellido,DNI,telefono,direccion) VALUES (500002,"Jorge Luis","Castor",40578999,"221-4400789","11 entre 500 y 501 nro:2587")

-- Listar nroTicket, total, fecha, hora para las facturas del cliente  ́Jorge Pérez ́ donde no haya
-- comprado el producto 'Z'

SELECT f.nroTicket,f.total,f.fecha,f.hora 
FROM Cliente c NATURAL JOIN Factura f NATURAL JOIN Detalle d
WHERE (c.nombre = "Jorge") and (c.apellido = "Perez") and (d.idProducto NOT IN ( --Puedo usar el d.idProducto pese a no estar en el select?
SELECT idProducto
FROM Producto
WHERE (nombreP = "Z")
))

-- 10. Listar DNI, apellido y nombre de clientes donde el monto total comprado, teniendo en cuenta
-- todas sus facturas, supere $10.000.000.

SELECT c.nombre,c.apellido,c.DNI, -- SUM(f.total) as Total Cliente Podria no ir porque no lo pide
FROM Cliente c NATURAL JOIN Factura f
GROUP BY c.DNI, c.apellido, c.nombre
HAVING SUM(f.total) > 10000000

