# Так как рекурсивных функций в MySQL не предусмотрено, переделал структуру БД, сделав дерево категорий через Nested Sets

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
# -------------------
SELECT DISTINCT goods.*
  FROM categories AS child
  JOIN categories AS parent ON child.lft >= parent.lft
                           AND child.lft <= parent.rgt
  JOIN cat_goods  AS cg     ON cg.cat_id = child.id
  JOIN goods                ON goods.id = cg.goods_id
WHERE parent.id = 3
;

#  -------------------
# c. Для заданного списка категорий получить количество предложений товаров в каждой категории;
# Если не нужно выводить категории, которые не содержат ни одного товара - заменить LEFT JOIN на JOIN
# -------------------

# Без учета всех дочерних категорий (без изменений)
   SELECT t1.name,
          count(t2.goods_id)
     FROM categories as t1
LEFT JOIN cat_goods  as t2 ON t2.cat_id = t1.id
    WHERE t1.id in (5,3,4,11)
 GROUP BY t1.name
;

# С учетом всех дочерних категорий
   SELECT parent.id,
          parent.name,
          COUNT(goods.goods_id)
     FROM categories AS child
     JOIN categories AS parent ON child.lft >= parent.lft
                              AND child.lft <= parent.rgt
LEFT JOIN cat_goods  AS goods  ON goods.cat_id = child.id

    WHERE parent.id IN (5,3,4,11)

 GROUP BY parent.id
 ORDER BY parent.id
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
SELECT child.id,
       child.name,
       GROUP_CONCAT(
          parent.name
          ORDER BY parent.lft ASC
          SEPARATOR ' > '
       ) as breadcrumbs
  FROM categories AS child
  JOIN categories AS parent ON child.lft >= parent.lft
                           AND child.lft <= parent.rgt
 WHERE child.id = 9

 GROUP BY child.lft
 ORDER BY child.lft