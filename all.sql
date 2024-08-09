-- Найдите номер модели, скорость и размер жесткого диска для всех ПК стоимостью менее 500 дол. Вывести: model, speed и hd
        SELECT model, speed, hd
        FROM pc
        WHERE price<500

-- Найдите производителей принтеров. Вывести: maker
		SELECT DISTINCT maker
		FROM product
		WHERE type='printer'
		
-- Найдите номер модели, объем памяти и размеры экранов ПК-блокнотов, цена которых превышает 1000 дол.
		SELECT model, ram, screen
		From laptop
		WHERE price >1000


-- Найдите все записи таблицы Printer для цветных принтеров.
		SELECT *
		From printer
		WHERE color = 'y'
		
		
-- Найдите номер модели, скорость и размер жесткого диска ПК, имеющих 12x или 24x CD и цену менее 600 дол.	
        SELECT model,speed,hd
        FROM pc
        WHERE cd IN ('12x','24x')
        AND price<600
			
			
-- Для каждого производителя, выпускающего ПК-блокноты c объёмом жесткого диска не менее 10 Гбайт, найти скорости таких ПК-блокнотов. 
-- Вывод: производитель, скорость.
		SELECT DISTINCT maker, speed
		FROM product
		INNER JOIN laptop ON Product.model=laptop.model
		WHERE hd>=10

-- Найдите номера моделей и цены всех имеющихся в продаже продуктов (любого типа) производителя B (латинская буква).
		SELECT product.model,price
		FROM pc INNER JOIN 
		product ON product.model=pc.model
		WHERE product.maker='B'

		UNION

		SELECT printer.model, printer.price 
		FROM printer INNER JOIN 
		product ON product.model=printer.model
		WHERE product.maker='B'

		UNION
		SELECT laptop.model, laptop.price 
		FROM Laptop INNER JOIN 
		product ON product.model=laptop.model
		WHERE product.maker='B'
				
				
-- Найдите производителя, выпускающего ПК, но не ПК-блокноты.
		SELECT DISTINCT maker
		FROM PRODUCT
		WHERE product.type='pc'
		EXCEPT
		SELECT DISTINCT maker
		FROM PRODUCT
		WHERE product.type='laptop'

-- Найдите производителей ПК с процессором не менее 450 Мгц. Вывести: Maker

		SELECT DISTINCT product.maker
		FROM product
		inner join pc
		ON  product.model=pc.model
		WHERE speed>=450
		
		
-- Найдите модели принтеров, имеющих самую высокую цену. Вывести: model, price		
		SELECT 	model, price
		FROM printer
		WHERE price = (SELECT MAX(price)FROM printer)
	
-- Найдите среднюю скорость ПК.	
		SELECT  AVG(speed)
		FROM pc
	
-- Найдите среднюю скорость ПК-блокнотов, цена которых превышает 1000 дол.	
		SELECT AVG(speed)
		From laptop
		WHERE price >1000
		
-- Найдите среднюю скорость ПК, выпущенных производителем A.		
		SELECT AVG(pc.speed)
		FROM pc
		INNER JOIN product
		ON pc.model=product.model
		WHERE maker='A'
		
		
-- Найдите класс, имя и страну для кораблей из таблицы Ships, имеющих не менее 10 орудий.		
		SELECT classes.class,ships.name, classes.country
		FROM classes
		INNER JOIN
		ships
		ON classes.class=ships.class
		WHERE numGuns>=10
		
		
-- Найдите размеры жестких дисков, совпадающих у двух и более PC. Вывести: HD		
        SELECT pc.hd 
        FROM pc 
        GROUP BY hd 
        HAVING COUNT (hd)>1