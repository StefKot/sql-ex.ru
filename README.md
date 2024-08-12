# sql-ex.ru
Solutions from https://sql-ex.ru/


# 1. sql-ex.ru - порешать задачи (минимум 30 штук, но чем больше, тем лучше!), внимание на работу join'ов и работу оператора select
* Даны 2 исходные таблицы нужно было написать результат выполнения джоинов
![image (9)](https://github.com/user-attachments/assets/69bb383c-4b92-4965-b285-f296e741b7bb)  

* Есть таблица и написать запросы к ней  
![image (7)](https://github.com/user-attachments/assets/8e616d08-ffcc-4b97-a10d-aaa34f31ec5f)  
![image (8)](https://github.com/user-attachments/assets/17748150-fad3-4aaf-b246-7de255300408)

### Объяснение каждого элемента

1. **SELECT name**:
   - Выбирает имена учеников из таблицы school.

2. **COUNT(CASE WHEN mark = 2 THEN 1 ELSE NULL END) AS count_twos**:
   - Использует конструкцию CASE для подсчета количества двоек (mark = 2).
   - Если оценка равна 2, то возвращается 1 (это будет считаться), в противном случае возвращается NULL (это не будет учитываться в подсчете).
   - Результат этого выражения называется count_twos, и он будет содержать количество двоек для каждого ученика.

3. **FROM school**:
   - Указывает, что данные берутся из таблицы school.

4. **GROUP BY name**:
   - Группирует результаты по имени ученика. Это означает, что все записи с одинаковым именем будут собраны вместе, и агрегатные функции (такие как COUNT и SUM) будут применяться к каждой группе.

5. **HAVING SUM(CASE WHEN mark = 5 THEN 1 ELSE 0 END) > 9**:
   - Использует конструкцию HAVING, чтобы фильтровать группы, которые соответствуют определенному условию.
   - Здесь также используется конструкция CASE, чтобы подсчитать количество пятёрок (mark = 5). Если оценка равна 5, то возвращается 1, иначе — 0.
   - SUM(...) суммирует количество пятёрок для каждого ученика.
   - Условие > 9 означает, что мы оставляем только тех учеников, у которых количество пятёрок больше 9.

### Результат запроса

В результате выполнения этого запроса вы получите список учеников, которые:
- Имеют более 10 пятёрок,
- И количество двоек, которые они получили.

Каждая строка результата будет содержать имя ученика и количество его двоек (count_twos). 

Таким образом, данный запрос позволяет эффективно выявить учеников с высоким уровнем успеваемости (много пятёрок), а также их недостатки (количество двоек).

* Среди 8 монет есть одна фальшивая, которая легче настоящей. За какое наименьшее количество взвешиваний на чашечных весах без гирь можно наверняка выяснить, какая монета фальшивая?  
Хватит двух взвешиваний. Положить на каждую чашу по три монеты. Если вес равный, то фальшивая среди оставшихся двух. Если вес неравный, то взвесить любые две монеты из той чаши. которая легче.


![image](https://github.com/user-attachments/assets/6220742b-1294-485e-9870-1ce68edb5f2e)

# 2. Побольше подготовится в целом по БД (индексы в базах данных, их типы и физическая реализация, представление, партицирование, case)

### 1. Индексы в базах данных

Индексы в базах данных — это структуры данных, которые улучшают скорость операций выборки (SELECT) за счет уменьшения объема данных, которые нужно просмотреть. Индексы работают аналогично указателям в книгах: они позволяют быстро находить нужные записи без необходимости перебора всех строк в таблице.

### Основные типы индексов:

1. **Уникальные индексы**: Гарантируют уникальность значений в определенном столбце или группе столбцов.
``` sql   
CREATE UNIQUE INDEX idx_unique_email ON users(email);
```   

2. **Обычные индексы**: Используются для ускорения поиска по столбцам, не обязательно уникальных.
``` sql
CREATE INDEX idx_last_name ON employees(last_name);
```

3. **Составные индексы**: Индексы, которые включают несколько столбцов.
``` sql
CREATE INDEX idx_full_name ON employees(first_name, last_name);
```

4. **Полнотекстовые индексы**: Используются для ускорения поиска по текстовым полям.
``` sql
CREATE FULLTEXT INDEX idx_content ON articles(content);
```

5. **Индексы на выражениях**: Создаются на основе выражений, а не только на столбцах.
``` sql
CREATE INDEX idx_lower_name ON users(LOWER(name));
```

### Примеры использования индексов

#### Пример 1: Ускорение поиска
Допустим, у вас есть таблица products, и вы часто выполняете запросы по столбцу product_name. Создание индекса на этом столбце ускорит выборку.
``` sql
CREATE INDEX idx_product_name ON products(product_name);
```

Запросы к таблице products по product_name будут выполняться быстрее:
``` sql
SELECT * FROM products WHERE product_name = 'Laptop';
```

#### Пример 2: Уникальный индекс
Если вы хотите гарантировать, что значения в столбце username таблицы users уникальны, вы можете создать уникальный индекс:
``` sql
CREATE UNIQUE INDEX idx_unique_username ON users(username);
```

Это предотвратит вставку дубликатов:
``` sql
INSERT INTO users(username) VALUES ('john_doe'); -- Успешно
INSERT INTO users(username) VALUES ('john_doe'); -- Ошибка: дубликат
```

#### Пример 3: Составной индекс
Если вы часто выполняете запросы с фильтрацией по нескольким столбцам, например, first_name и last_name, имеет смысл создать составной индекс:
``` sql
CREATE INDEX idx_name ON employees(first_name, last_name);
```

Запросы с фильтрацией по обоим столбцам будут выполняться быстрее:
``` sql
SELECT * FROM employees WHERE first_name = 'John' AND last_name = 'Doe';
```

### Учет производительности

- **Преимущества**:
  - Ускорение операций выборки.
  - Улучшение производительности при выполнении JOIN-ов и сортировок.

- **Недостатки**:
  - Замедление операций вставки (INSERT), обновления (UPDATE) и удаления (DELETE), так как индексы нужно поддерживать.
  - Занимают дополнительное пространство на диске.

### Заключение

Индексы — важный инструмент для оптимизации производительности баз данных. Правильное использование индексов может значительно улучшить скорость выполнения запросов, но важно следить за балансом между скоростью выборки и затратами на обновление данных.

### 2. Представления (Views)

**Представления** — это виртуальные таблицы, созданные на основе SQL-запросов. Они не хранят данные, а лишь представляют результат выполнения запроса.

#### Преимущества:

- Упрощение сложных запросов.
- Повышение безопасности (можно ограничить доступ к определённым столбцам).
- Удобство работы с агрегированными данными.

#### Недостатки:

- Могут замедлять выполнение запросов, если основаны на сложных запросах или объединениях.
- Не всегда поддерживают все операции (например, вставка/обновление).

### 3. Партиционирование

**Партиционирование** — это метод разделения больших таблиц на более мелкие, управляемые части (партиции), чтобы улучшить производительность и управляемость.

#### Типы партиционирования:

- **По диапазону (Range Partitioning)**: Разделение по диапазону значений (например, даты).
  
- **По списку (List Partitioning)**: Разделение по списку значений.

- **По хешу (Hash Partitioning)**: Разделение на основе хеш-функции для равномерного распределения данных.

#### Преимущества:

- Ускорение операций выборки и управления данными.
- Упрощение архивирования старых данных.

### 4. Конструкция CASE

CASE — это оператор в SQL, который позволяет выполнять условные выражения внутри запросов.

#### Синтаксис:
``` sql
SELECT 
    column_name,
    CASE 
        WHEN condition1 THEN result1
        WHEN condition2 THEN result2
        ELSE default_result
    END AS alias_name
FROM 
    table_name;
```

#### Пример использования:
``` sql
SELECT 
    employee_id,
    salary,
    CASE 
        WHEN salary < 30000 THEN 'Low'
        WHEN salary BETWEEN 30000 AND 60000 THEN 'Medium'
        ELSE 'High'
    END AS salary_category
FROM 
    employees;
```

### Заключение

Эти аспекты баз данных играют важную роль в проектировании и оптимизации систем управления базами данных. Понимание индексов, представлений, партиционирования и условных операторов позволяет создавать более эффективные и масштабируемые приложения. 
# 3. ER-диаграммы
ER-диаграммы (диаграммы «сущность-связь») — это инструмент для визуального представления структуры базы данных. Они помогают разработчикам и аналитикам понять, как сущности (например, таблицы) связаны друг с другом и какие атрибуты они имеют.

### Основные компоненты ER-диаграмм:

1. **Сущности (Entities)**:
   - Представляют объекты или концепции, которые имеют независимое существование. Например: Пользователь, Продукт, Заказ.
   - Обычно изображаются в виде прямоугольников.

2. **Атрибуты (Attributes)**:
   - Характеристики сущностей. Например, у сущности Пользователь могут быть атрибуты Имя, Email, Дата рождения.
   - Изображаются в виде овальных фигур, соединенных с соответствующими сущностями.

3. **Связи (Relationships)**:
   - Определяют, как сущности взаимодействуют друг с другом. Например, связь между Пользователь и Заказ может означать, что пользователь может делать заказы.
   - Изображаются в виде ромбов, соединяющих соответствующие сущности.
   - Определяет количество экземпляров одной сущности, связанных с экземплярами другой сущности. Например:
     - Один к одному (1:1)
     - Один ко многим (1:N)
     - Многие ко многим (M:N)

### Пример ER-диаграммы:

Предположим, у нас есть система управления библиотекой. Вот основные сущности и их связи:

- **Сущности**:
  - Читатель
    - Атрибуты: ID, Имя, Email
  - Книга
    - Атрибуты: ISBN, Название, Автор
  - Заказ
    - Атрибуты: ID заказа, Дата заказа

- **Связи**:
  - Читатель делает Заказ (1:N)
  - Заказ включает Книгу (M:N)

### Визуализация:
```
[Читатель]---(делает)---[Заказ]---(включает)---[Книга]
```

### Заключение

ER-диаграммы являются важным инструментом для проектирования баз данных, позволяя визуализировать структуру и связи между сущностями. Они помогают упростить процесс разработки и улучшить понимание системы. 

# 4. Нормальные формы, преимущества и недостатки нормализации
Нормализация — это процесс организации данных в реляционной базе данных для уменьшения избыточности и улучшения целостности данных. Нормальные формы (НФ) — это набор правил, которые помогают достичь этой цели. Основные нормальные формы включают:

### 1. Первая нормальная форма (1НФ)
- **Определение**: Таблица находится в 1НФ, если все атрибуты имеют атомарные (неделимые) значения, и каждый атрибут содержит только одно значение.
- **Пример**: Вместо хранения нескольких номеров телефонов в одном поле, нужно создать отдельные строки для каждого номера.

### 2. Вторая нормальная форма (2НФ)
- **Определение**: Таблица находится во 2НФ, если она находится в 1НФ и все неключевые атрибуты полностью функционально зависят от первичного ключа.
- **Пример**: Если у вас есть таблица Заказы, где ID заказа является первичным ключом, то все атрибуты должны зависеть от ID заказа, а не от части составного ключа.

### 3. Третья нормальная форма (3НФ)
- **Определение**: Таблица находится в 3НФ, если она находится во 2НФ и все неключевые атрибуты не зависят транзитивно от первичного ключа.
- **Пример**: Если у вас есть атрибут Город, который зависит от Страны, а Страна зависит от ID заказа, то нужно разделить таблицы.

### 4. Бойс-Кодд нормальная форма (BCNF)
- **Определение**: Таблица находится в BCNF, если она находится в 3НФ и для каждой функциональной зависимости X → Y, X является суперключом.
- **Пример**: Если у вас есть зависимость, где неключевой атрибут определяет другой неключевой атрибут, это требует дополнительного разбиения таблицы.

### Преимущества нормализации:
1. **Снижение избыточности данных**: Устранение дублирующихся данных позволяет экономить место и упрощает управление данными.
2. **Улучшение целостности данных**: Нормализация помогает избежать аномалий вставки, обновления и удаления.
3. **Легкость в управлении изменениями**: Изменения в структуре базы данных легче реализовать без влияния на другие части системы.

### Недостатки нормализации:
1. **Сложность запросов**: Нормализованные базы данных могут требовать более сложных SQL-запросов, что может снизить производительность.
2. **Увеличение количества таблиц**: Разделение данных на множество таблиц может усложнить структуру базы данных и привести к необходимости выполнения множества соединений (JOIN).
3. **Производительность**: В некоторых случаях, особенно при больших объемах данных и частых запросах, денормализация может быть более эффективной.

### Заключение
Нормализация — важный аспект проектирования баз данных, который помогает поддерживать целостность и уменьшать избыточность данных. Однако необходимо учитывать баланс между нормализацией и производительностью системы, особенно в условиях высоких нагрузок или специфических требований к быстродействию.

# 5. Схемы "Снежинка" и "Звезда"
Схемы "Снежинка" (Snowflake) и "Звезда" (Star) — это модели организации данных в хранилищах данных (data warehouses), которые помогают структурировать данные для аналитики и отчетности.

### Схема "Звезда"
![image](https://github.com/user-attachments/assets/178496de-cfe2-45a3-938a-6cb30e212b6a)

Описание:
- В схеме "Звезда" центральная таблица фактов окружена несколькими таблицами измерений.
- Таблица фактов содержит числовые данные и ключи, связывающие её с таблицами измерений.
- Таблицы измерений содержат атрибуты, которые описывают данные фактов.

Преимущества:
- Простота: структура легко понимается и визуализируется.
- Высокая производительность: запросы обычно быстрее, так как используются простые JOIN-операции между таблицами фактов и измерений.

Недостатки:
- Избыточность: может быть много дублирующихся данных в таблицах измерений, что увеличивает объем хранимых данных.

Пример:
- Таблица фактов: sales (содержит поля sales_id, date_id, product_id, customer_id, amount)
- Таблицы измерений: 
  - date (содержит поля date_id, day, month, year)
  - product (содержит поля product_id, name, category)
  - customer (содержит поля customer_id, name, region)

### Схема "Снежинка"
![image](https://github.com/user-attachments/assets/8596263e-9abd-4b64-a265-9d1cc79f23af)

Описание:
- В схеме "Снежинка" таблицы измерений нормализованы, то есть разбиты на дополнительные подтаблицы.
- Это приводит к более сложной структуре, где таблицы измерений могут иметь свои собственные подтаблицы.

Преимущества:
- Снижение избыточности: нормализация уменьшает дублирование данных.
- Более гибкая структура: можно легко добавлять новые уровни детализации.

Недостатки:
- Сложность: структура более сложная, что может затруднить понимание и написание запросов.
- Производительность: запросы могут быть медленнее из-за необходимости выполнения большего количества JOIN-операций.

Пример:
- Таблица фактов: sales (аналогично схеме "Звезда")
- Таблицы измерений:
  - date (аналогично)
  - product (содержит поля product_id, name, category_id)
  - category (содержит поля category_id, category_name)
  - customer (аналогично, может быть разбита на подтаблицы, например, по регионам)

### Выбор между схемами

Выбор между схемами "Звезда" и "Снежинка" зависит от требований проекта:
- Если приоритетом является простота и скорость выполнения запросов, лучше использовать схему "Звезда".
- Если важна экономия пространства и минимизация избыточности данных, стоит рассмотреть схему "Снежинка". 

Каждая схема имеет свои плюсы и минусы, и выбор зависит от конкретных задач и условий.

# 6. Почитать про аналитические функции (например, Том Кайт, "Oracle для профессионалов" глава 12)
Аналитические функции в SQL — это мощные инструменты для выполнения сложных вычислений на наборе строк, не требуя их агрегации в одну строку. Они позволяют производить расчеты на основе значений в других строках, сохраняя при этом доступ к каждой строке в результате.

### Основные характеристики аналитических функций:

1. **Окно (Window)**: Аналитические функции работают в рамках определённого окна (группы строк), которое определяется с помощью операторов PARTITION BY и ORDER BY.
2. **Сохранение строк**: В отличие от агрегатных функций, которые сводят строки к одной, аналитические функции возвращают одно значение для каждой строки в наборе.

### Основные аналитические функции:

1. **ROW_NUMBER()**: Присваивает уникальный номер каждой строке в пределах заданного окна.
``` sql
SELECT 
   employee_id, 
   ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS row_num
FROM employees;
```   

3. **RANK()**: Присваивает ранг каждой строке в пределах окна, при этом одинаковые значения получают одинаковый ранг, а следующий ранг пропускается.
``` sql
SELECT 
   employee_id, 
   RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rank
FROM employees;
```  

4. **DENSE_RANK()**: Похож на RANK(), но не пропускает ранги при наличии одинаковых значений.
``` sql
SELECT 
   employee_id, 
   DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS dense_rank
FROM employees;
 ```  

5. **SUM()**: Возвращает сумму значений в пределах окна.
``` sql
SELECT 
   employee_id, 
   salary, 
   SUM(salary) OVER (PARTITION BY department_id) AS total_salary
FROM employees;
```   

6. **AVG()**: Вычисляет среднее значение для заданного окна.
``` sql
SELECT 
   employee_id, 
   salary, 
   AVG(salary) OVER (PARTITION BY department_id) AS avg_salary
FROM employees;
``` 

7. **LEAD() и LAG()**: Позволяют получить доступ к значениям из следующей или предыдущей строки в пределах окна.
``` sql
SELECT 
   employee_id, 
   salary, 
   LAG(salary) OVER (ORDER BY employee_id) AS previous_salary,
   LEAD(salary) OVER (ORDER BY employee_id) AS next_salary
FROM employees;
```

### Применение аналитических функций:

- **Отчеты и аналитика**: Удобны для создания отчетов с детализацией по категориям или группам.
- **Финансовые расчеты**: Позволяют вычислять кумулятивные суммы или средние значения по временным периодам.
- **Ранжирование данных**: Используются для ранжирования элементов по определённым критериям.

### Заключение

Аналитические функции значительно расширяют возможности SQL для анализа данных, позволяя выполнять сложные вычисления и получать полезную информацию без необходимости изменения структуры данных. Это делает их важным инструментом для аналитиков и разработчиков баз данных.
