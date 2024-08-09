-- Найдите среднюю скорость ПК-блокнотов, цена которых превышает 1000 дол.	
SELECT AVG(speed)
From laptop
WHERE price > 1000