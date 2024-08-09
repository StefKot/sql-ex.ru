-- Для каждого производителя, выпускающего ПК-блокноты c объёмом жесткого диска не менее 10 Гбайт, найти скорости таких ПК-блокнотов. 
-- Вывод: производитель, скорость.
SELECT DISTINCT maker, speed
FROM product
INNER JOIN laptop ON Product.model = laptop.model
WHERE hd >= 10