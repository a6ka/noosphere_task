#  -------------------
# a. Для заданного списка товаров получить названия всех категорий, в которых представлены товары;
# -------------------
SELECT DISTINCT t3.name
  FROM goods AS t1
  JOIN cat_goods AS t2 ON t2.goods_id = t1.id
  JOIN categories AS t3 ON t3.id = t2.cat_id
 WHERE t1.id IN (1, 2, 7)
;

#  -------------------
# b. Для заданной категории получить список предложений всех товаров из этой категории и ее дочерних категорий;
# (будут выбраны только прямые дочерние категории, без рекурсии)
# -------------------
SET @cat_id = 10;

SELECT t1.*
  FROM `goods` 	 AS t1
  JOIN cat_goods AS t2 ON t2.goods_id = t1.id
                      AND t2.cat_id = @cat_id

 UNION

SELECT t1.*
  FROM `goods` 	 	    AS t1
  JOIN cat_goods 	    AS t2 ON t2.goods_id = t1.id
  JOIN cat_breadcrumb AS t3 ON t3.cat_id = t2.cat_id
                           AND t3.parrent_id = @cat_id;

#  -------------------
# b. Для заданной категории получить список предложений всех товаров из этой категории и ее дочерних категорий;
# (с рекурсией - ВСЕ дочерние категории вплоть до 4 глубины)
# -------------------

SET @cat_id = 3;

# временная таблица, хранящая уникальные ID категорий
CREATE TEMPORARY TABLE temp_cat_id (id int not null PRIMARY KEY)
;

# временная таблица, хранящая дочерние ID категории, которые затем переносятся в temp_cat_id
CREATE TEMPORARY TABLE temp_cat_id2 (id int not null)
;

# Вставляем ID запрошенной категории
INSERT INTO temp_cat_id
  SELECT id
  FROM categories
  WHERE id = @cat_id
;
# Поиск дочерних категорий (2 ур)
INSERT INTO temp_cat_id2
  SELECT cat_id
  FROM cat_breadcrumb
    JOIN temp_cat_id on temp_cat_id.id = cat_breadcrumb.parrent_id
;

# Вставляем найденные категории (2 ур). IGNORE - что б пропускать запись ID, которые уже есть в таблице temp_cat_id
INSERT IGNORE INTO temp_cat_id
  SELECT id
  FROM temp_cat_id2
;

# Очищаем вторую таблицу
DELETE FROM temp_cat_id2;

# Поиск дочерних категорий (3 ур)
INSERT INTO temp_cat_id2
  SELECT cat_id
  FROM cat_breadcrumb
    JOIN temp_cat_id on temp_cat_id.id = cat_breadcrumb.parrent_id
;

# Вставляем найденные категории (3 ур)
INSERT IGNORE INTO temp_cat_id
  SELECT id
  FROM temp_cat_id2
;

# Очищаем вторую таблицу
DELETE FROM temp_cat_id2;

# Поиск дочерних категорий (4 ур)
INSERT INTO temp_cat_id2
  SELECT cat_id
  FROM cat_breadcrumb
    JOIN temp_cat_id on temp_cat_id.id = cat_breadcrumb.parrent_id
;

# Вставляем найденные категории (4 ур)
INSERT IGNORE INTO temp_cat_id
  SELECT id
  FROM temp_cat_id2
;

# Выбор товаров нужных категорий
SELECT t1.*
  FROM goods       as t1
  JOIN cat_goods   as t2 on t2.goods_id = t1.id
  JOIN temp_cat_id as t3 on t3.id = t2.cat_id
;

#  -------------------
# c. Для заданного списка категорий получить количество предложений товаров в каждой категории;
# Если не нужно выводить категории, которые не содержат ни одного товара - заменить LEFT JOIN на JOIN
# -------------------
   SELECT t1.name,
          count(t2.goods_id)
     FROM categories as t1
LEFT JOIN cat_goods  as t2 ON t2.cat_id = t1.id
    WHERE t1.id in (2,3,4,11)
 GROUP BY t1.name
;

#  -------------------
# d. Для заданного списка категорий получить общее количество уникальных предложений товара;
# -------------------
SELECT count(DISTINCT t1.goods_id)
  FROM cat_goods as t1
 WHERE t1.cat_id in (2,3,4,11)
;

#  -------------------
# e. Для заданной категории получить ее полный путь в дереве (breadcrumb, «хлебные крошки»).
# -------------------
     SELECT t1.id,
            t1.name,
            t2.parrent_id as 'first_parent_id',
            t3.parrent_id as 'second_parent_id',
            t4.parrent_id as 'third_parent_id'
       FROM categories as t1
  LEFT JOIN cat_breadcrumb as t2 on t2.cat_id = t1.id
  LEFT JOIN cat_breadcrumb as t3 on t3.cat_id = t2.parrent_id
  LEFT JOIN cat_breadcrumb as t4 on t4.cat_id = t3.parrent_id
      WHERE t1.id = 10
;