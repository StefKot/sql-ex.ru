-- 1. Найдите номер модели, скорость и размер жесткого диска для всех ПК стоимостью менее 500 дол. Вывести: model, speed и hd
        SELECT model, speed, hd
        FROM pc
        WHERE price < 500

-- 2. Найдите производителей принтеров. Вывести: maker
		SELECT DISTINCT maker
		FROM product
		WHERE type = 'printer'
		
-- 3. Найдите номер модели, объем памяти и размеры экранов ПК-блокнотов, цена которых превышает 1000 дол.
		SELECT model, ram, screen
		From laptop
		WHERE price > 1000


-- 4. Найдите все записи таблицы Printer для цветных принтеров.
		SELECT *
		From printer
		WHERE color = 'y'
		
		
-- 5. Найдите номер модели, скорость и размер жесткого диска ПК, имеющих 12x или 24x CD и цену менее 600 дол.	
        SELECT model,speed,hd
        FROM pc
        WHERE cd IN ('12x','24x')
        AND price < 600
			
			
-- 6. Для каждого производителя, выпускающего ПК-блокноты c объёмом жесткого диска не менее 10 Гбайт, найти скорости таких ПК-блокнотов. 
-- Вывод: производитель, скорость.
		SELECT DISTINCT maker, speed
		FROM product
		INNER JOIN laptop ON Product.model = laptop.model
		WHERE hd> = 10

-- 7. Найдите номера моделей и цены всех имеющихся в продаже продуктов (любого типа) производителя B (латинская буква).
-- Оператор UNION

-- - UNION: объединяет результаты всех трех частей запроса в один общий набор данных. 
-- При этом дубликаты удаляются (если есть одинаковые записи в разных частях запроса).
-- - Важно заметить, что все три выборки должны возвращать одинаковое количество столбцов с совместимыми типами данных.
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
				
				
-- 8. Найдите производителя, выпускающего ПК, но не ПК-блокноты.
-- Оператор EXCEPT:
--    - Оператор EXCEPT используется для получения разности между двумя наборами данных.
--    - Он возвращает все строки из первого запроса, которые не присутствуют во втором запросе.

-- Итог

-- Таким образом, весь запрос:

-- - Сначала находит всех производителей, которые делают ПК.
-- - Затем исключает из этого списка тех производителей, которые также делают ноутбуки.
		SELECT DISTINCT maker
		FROM PRODUCT
		WHERE product.type = 'pc'
		EXCEPT
		SELECT DISTINCT maker
		FROM PRODUCT
		WHERE product.type = 'laptop'

-- 9. Найдите производителей ПК с процессором не менее 450 Мгц. Вывести: Maker

		SELECT DISTINCT product.maker
		FROM product
		inner join pc
		ON  product.model = pc.model
		WHERE speed >= 450
		
		
-- 10. Найдите модели принтеров, имеющих самую высокую цену. Вывести: model, price		
		SELECT 	model, price
		FROM printer
		WHERE price  =  (SELECT MAX(price) FROM printer)
	
-- 11. Найдите среднюю скорость ПК.	
		SELECT  AVG(speed)
		FROM pc
	
-- 12. Найдите среднюю скорость ПК-блокнотов, цена которых превышает 1000 дол.	
		SELECT AVG(speed)
		From laptop
		WHERE price > 1000
		
-- 13. Найдите среднюю скорость ПК, выпущенных производителем A.		
		SELECT AVG(pc.speed)
		FROM pc
		INNER JOIN product
		ON pc.model = product.model
		WHERE maker = 'A'
		
		
-- 14. Найдите класс, имя и страну для кораблей из таблицы Ships, имеющих не менее 10 орудий.		
		SELECT classes.class, ships.name, classes.country
		FROM classes
		INNER JOIN
		    ships
		ON classes.class = ships.class
		WHERE numGuns> = 10
		
		
-- 15. Найдите размеры жестких дисков, совпадающих у двух и более PC. Вывести: HD		
        SELECT pc.hd 
        FROM pc 
        GROUP BY hd 
        HAVING COUNT(hd) > 1

-- 16. Найдите пары моделей PC, имеющих одинаковые скорость и RAM. 
-- В результате каждая пара указывается только один раз, т.е. (i,j), но не (j,i), 
-- Порядок вывода: модель с большим номером, модель с меньшим номером, скорость и RAM.
        SELECT distinct
            p2.model AS model1,
            p1.model AS model2,
            pc1.speed,
            pc1.ram
        FROM 
            PC pc1
        JOIN 
            PC pc2 ON pc1.speed = pc2.speed AND pc1.ram = pc2.ram AND pc1.model < pc2.model
        JOIN 
            Product p1 ON pc1.model = p1.model
        JOIN 
            Product p2 ON pc2.model = p2.model
        WHERE 
            p1.type = 'PC' AND p2.type = 'PC'
        ORDER BY 
            model1 DESC, model2 DESC

-- 17. Найдите модели ПК-блокнотов, скорость которых меньше скорости каждого из ПК.
-- Вывести: type, model, speed
        SELECT distinct
            p.type,
            p.model,
            l.speed
        FROM 
            Product p
        JOIN 
            Laptop l ON p.model = l.model
        WHERE 
            p.type = 'Laptop' 
            AND l.speed < ALL (SELECT speed FROM PC)

-- 18. Найдите производителей самых дешевых цветных принтеров. Вывести: maker, price
-- Подзапрос (SELECT MIN(price) FROM Printer WHERE color = 'y') находит минимальную цену для цветных принтеров с указанным цветом.
        SELECT distinct
            maker, 
            price
        FROM 
            product

        join printer on product.model = printer.model
        WHERE 
            color = 'y' 
            AND price = (SELECT MIN(price) FROM Printer WHERE color = 'y')

-- 19. Для каждого производителя, имеющего модели в таблице Laptop, найдите средний размер экрана выпускаемых им ПК-блокнотов.
-- Вывести: maker, средний размер экрана.
        SELECT 
            p.maker, 
            AVG(l.screen) AS average_screen_size
        FROM 
            Product p
        JOIN 
            Laptop l ON p.model = l.model
        GROUP BY 
            p.maker

