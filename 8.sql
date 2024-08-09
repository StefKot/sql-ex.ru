-- Найдите производителя, выпускающего ПК, но не ПК-блокноты.
SELECT DISTINCT maker
FROM PRODUCT
WHERE product.type = 'pc'
EXCEPT
SELECT DISTINCT maker
FROM PRODUCT
WHERE product.type = 'laptop'