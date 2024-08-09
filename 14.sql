-- Найдите класс, имя и страну для кораблей из таблицы Ships, имеющих не менее 10 орудий.		
SELECT classes.class,ships.name, classes.country
FROM classes
INNER JOIN
ships
ON classes.class = ships.class
WHERE numGuns >= 10