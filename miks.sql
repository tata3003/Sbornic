- Название и продолжительность самого длительного трека
SELECT title AS "Название трека", duration AS "Продолжительность"
FROM tracks
ORDER BY duration DESC
LIMIT 1;

-- Название треков, продолжительность которых не менее 3,5 минут
SELECT title AS "Название трека"
FROM tracks
WHERE duration >= '00:03:30';

-- Названия сборников, вышедших в период с 2018 по 2020 год включительно
SELECT title AS "Название сборника"
FROM collections
WHERE release_year BETWEEN 2018 AND 2020;

-- Исполнители, чьё имя состоит из одного слова
SELECT name AS "Имя исполнителя"
FROM artists
WHERE name NOT LIKE '% %';

-- Название треков, которые содержат слово «мой» или «my»
SELECT title AS "Название трека"
FROM tracks
WHERE title ILIKE '%мой%' OR title ILIKE '%my%';
