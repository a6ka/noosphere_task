-- phpMyAdmin SQL Dump
-- version 4.5.5.1
-- http://www.phpmyadmin.net
--
-- Хост: 127.0.0.1
-- Время создания: Авг 14 2017 г., 23:25
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

-- --------------------------------------------------------

--
-- Структура таблицы `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `categories`
--

INSERT INTO `categories` (`id`, `name`) VALUES
  (10, 'AMD Radeon'),
  (8, 'HDD'),
  (9, 'NVidia'),
  (7, 'SSD'),
  (6, 'Видеокарты'),
  (5, 'Жеские диски'),
  (4, 'Комплектующие'),
  (2, 'Ноутбуки'),
  (3, 'Ноутбуки и компьютеры'),
  (11, 'Планшеты');

-- --------------------------------------------------------

--
-- Структура таблицы `cat_breadcrumb`
--

CREATE TABLE `cat_breadcrumb` (
  `id` int(11) NOT NULL,
  `cat_id` int(11) NOT NULL,
  `parrent_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `cat_breadcrumb`
--

INSERT INTO `cat_breadcrumb` (`id`, `cat_id`, `parrent_id`) VALUES
  (1, 2, 3),
  (2, 4, 3),
  (3, 5, 4),
  (4, 6, 4),
  (5, 7, 5),
  (6, 8, 5),
  (7, 9, 6),
  (8, 10, 6),
  (9, 11, 3);

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
  ADD UNIQUE KEY `name` (`name`);

--
-- Индексы таблицы `cat_breadcrumb`
--
ALTER TABLE `cat_breadcrumb`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_breadcrumb` (`cat_id`,`parrent_id`),
  ADD KEY `cat_id` (`cat_id`),
  ADD KEY `parrent_id` (`parrent_id`);

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
-- AUTO_INCREMENT для таблицы `cat_breadcrumb`
--
ALTER TABLE `cat_breadcrumb`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
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
-- Ограничения внешнего ключа таблицы `cat_breadcrumb`
--
ALTER TABLE `cat_breadcrumb`
  ADD CONSTRAINT `cat_breadcrumb_ibfk_1` FOREIGN KEY (`cat_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `cat_breadcrumb_ibfk_2` FOREIGN KEY (`parrent_id`) REFERENCES `categories` (`id`) ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `cat_goods`
--
ALTER TABLE `cat_goods`
  ADD CONSTRAINT `cat_goods_ibfk_1` FOREIGN KEY (`goods_id`) REFERENCES `goods` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `cat_goods_ibfk_2` FOREIGN KEY (`cat_id`) REFERENCES `categories` (`id`) ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
