-- Найдите производителей ПК с процессором не менее 450 Мгц. Вывести: Maker
SELECT DISTINCT product.maker
FROM product
inner join pc
ON  product.model = pc.model
WHERE speed >= 450