-- Найдите среднюю скорость ПК, выпущенных производителем A.		
SELECT AVG(pc.speed)
FROM pc
INNER JOIN product
ON pc.model = product.model
WHERE maker = 'A'