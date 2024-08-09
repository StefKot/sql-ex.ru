-- Найдите номера моделей и цены всех имеющихся в продаже продуктов (любого типа) производителя B (латинская буква).
SELECT product.model,price
FROM pc INNER JOIN 
product ON product.model = pc.model
WHERE product.maker = 'B'

UNION

SELECT printer.model, printer.price 
FROM printer INNER JOIN 
product ON product.model = printer.model
WHERE product.maker = 'B'

UNION
SELECT laptop.model, laptop.price 
FROM Laptop INNER JOIN 
product ON product.model = laptop.model
WHERE product.maker = 'B'