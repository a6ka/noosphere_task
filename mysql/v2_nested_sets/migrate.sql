-- phpMyAdmin SQL Dump
-- version 4.5.5.1
-- http://www.phpmyadmin.net
--
-- Хост: 127.0.0.1
-- Время создания: Авг 17 2017 г., 21:57
-- Версия сервера: 5.7.11
-- Версия PHP: 7.0.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `noosphere_shop`
--

DELIMITER $$
--
-- Функции
--
CREATE DEFINER=`root`@`localhost` FUNCTION `rebuild_nested_set_categories` () RETURNS INT(11) MODIFIES SQL DATA
DETERMINISTIC
  BEGIN
    UPDATE categories t SET lft = NULL, rgt = NULL;

    SET @i := 0;
    UPDATE categories t SET lft = (@i := @i + 1), rgt = (@i := @i + 1)
    WHERE t.parent_id IS NULL;

    forever: LOOP
      SET @parent_id := NULL;
      SELECT t.id, t.rgt FROM categories t, categories tc
      WHERE t.id = tc.parent_id AND tc.lft IS NULL AND t.rgt IS NOT NULL
      ORDER BY t.rgt LIMIT 1 INTO @parent_id, @parent_right;

      IF @parent_id IS NULL THEN LEAVE forever; END IF;

      SET @current_left := @parent_right;

      SELECT @current_left + COUNT(*) * 2 FROM categories
      WHERE parent_id = @parent_id INTO @parent_right;

      SET @current_length := @parent_right - @current_left;

      UPDATE categories t SET rgt = rgt + @current_length
      WHERE rgt >= @current_left ORDER BY rgt;

      UPDATE categories t SET lft = lft + @current_length
      WHERE lft > @current_left ORDER BY lft;

      SET @i := (@current_left - 1);
      UPDATE categories t SET lft = (@i := @i + 1), rgt = (@i := @i + 1)
      WHERE parent_id = @parent_id ORDER BY id;
    END LOOP;

    RETURN (SELECT MAX(rgt) FROM categories t);
  END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `lft` int(10) UNSIGNED DEFAULT NULL,
  `rgt` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `categories`
--

INSERT INTO `categories` (`id`, `name`, `parent_id`, `lft`, `rgt`) VALUES
  (2, 'Ноутбуки', 3, 2, 3),
  (3, 'Ноутбуки и компьютеры', NULL, 1, 20),
  (4, 'Комплектующие', 3, 4, 17),
  (5, 'Жеские диски', 4, 5, 10),
  (6, 'Видеокарты', 4, 11, 16),
  (7, 'SSD', 5, 6, 7),
  (8, 'HDD', 5, 8, 9),
  (9, 'NVidia', 6, 12, 13),
  (10, 'AMD Radeon', 6, 14, 15),
  (11, 'Планшеты', 3, 18, 19);

-- --------------------------------------------------------

--
-- Структура таблицы `cat_goods`
--

CREATE TABLE `cat_goods` (
  `id` int(11) NOT NULL,
  `goods_id` int(11) NOT NULL,
  `cat_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `cat_goods`
--

INSERT INTO `cat_goods` (`id`, `goods_id`, `cat_id`) VALUES
  (1, 1, 2),
  (8, 1, 11),
  (9, 2, 2),
  (2, 2, 11),
  (3, 3, 2),
  (4, 4, 9),
  (5, 5, 10),
  (6, 6, 7),
  (7, 7, 8);

-- --------------------------------------------------------

--
-- Структура таблицы `goods`
--

CREATE TABLE `goods` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `cost` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `goods`
--

INSERT INTO `goods` (`id`, `name`, `cost`) VALUES
  (1, 'Asus ZenBook Flip UX360UA (UX360UA-BB328T) Gold', '28799.00'),
  (2, 'HP Envy x360 15-aq002ur', '25999.00'),
  (3, 'Apple MacBook Air 13"', '25999.00'),
  (4, 'Asus PCI-Ex GeForce GTX 1060 ROG Strix 6GB GDDR5', '9865.00'),
  (5, 'Asus PCI-Ex Radeon RX570 Expedition 4GB GDDR5', '8699.00'),
  (6, 'Kingston SSDNow A400 120GB 2.5" SATAIII TLC', '1549.00'),
  (7, 'Жесткий диск Western Digital Black 500GB 7200rpm 32MB WD5000LPLX 2.5 SATA III', '1337.00');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `parent_id` (`parent_id`);

--
-- Индексы таблицы `cat_goods`
--
ALTER TABLE `cat_goods`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_cat_goods` (`goods_id`,`cat_id`) USING BTREE,
  ADD KEY `goods_id` (`goods_id`),
  ADD KEY `cat_id` (`cat_id`);

--
-- Индексы таблицы `goods`
--
ALTER TABLE `goods`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;
--
-- AUTO_INCREMENT для таблицы `cat_goods`
--
ALTER TABLE `cat_goods`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT для таблицы `goods`
--
ALTER TABLE `goods`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`) ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `cat_goods`
--
ALTER TABLE `cat_goods`
  ADD CONSTRAINT `cat_goods_ibfk_1` FOREIGN KEY (`goods_id`) REFERENCES `goods` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `cat_goods_ibfk_2` FOREIGN KEY (`cat_id`) REFERENCES `categories` (`id`) ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
