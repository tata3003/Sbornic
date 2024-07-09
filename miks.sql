
-- Создание таблицы исполнителей
CREATE TABLE artists (
  artist_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

-- Создание таблицы жанров
CREATE TABLE genres (
  genre_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

-- Промежуточная таблица для связи исполнителей и жанров (многие ко многим)
CREATE TABLE artist_genre (
  artist_genre_id SERIAL PRIMARY KEY,
  artist_id INT NOT NULL,
  genre_id INT NOT NULL,
  FOREIGN KEY (artist_id) REFERENCES artists(artist_id) ON DELETE CASCADE,
  FOREIGN KEY (genre_id) REFERENCES genres(genre_id) ON DELETE CASCADE
);

-- Создание таблицы альбомов
CREATE TABLE albums (
  album_id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  release_year INT NOT NULL
);

-- Промежуточная таблица для связи исполнителей и альбомов (многие ко многим)
CREATE TABLE artist_album (
  artist_album_id SERIAL PRIMARY KEY,
  artist_id INT NOT NULL,
  album_id INT NOT NULL,
  FOREIGN KEY (artist_id) REFERENCES artists(artist_id) ON DELETE CASCADE,
  FOREIGN KEY (album_id) REFERENCES albums(album_id) ON DELETE CASCADE
);

-- Создание таблицы треков
CREATE TABLE tracks (
  track_id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  duration TIME NOT NULL,
  album_id INT NOT NULL,
  FOREIGN KEY (album_id) REFERENCES albums(album_id) ON DELETE CASCADE
);

-- Создание таблицы сборников
CREATE TABLE collections (
  collection_id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  release_year INT NOT NULL
);

-- Промежуточная таблица для связи треков и сборников (многие ко многим)
CREATE TABLE collection_track (
  collection_track_id SERIAL PRIMARY KEY,
  collection_id INT NOT NULL,
  track_id INT NOT NULL,
  FOREIGN KEY (collection_id) REFERENCES collections(collection_id) ON DELETE CASCADE,
  FOREIGN KEY (track_id) REFERENCES tracks(track_id) ON DELETE CASCADE
);

-- Запросы для заданий

-- 1. Название и продолжительность самого длительного трека.
SELECT title, duration
FROM tracks
WHERE duration = (SELECT MAX(duration) FROM tracks);

-- 2. Название треков, продолжительность которых не менее 3,5 минут.
SELECT title
FROM tracks
WHERE duration >= '00:03:30';

-- 3. Названия сборников, вышедших в период с 2018 по 2020 год включительно.
SELECT title
FROM collections
WHERE release_year BETWEEN 2018 AND 2020;

-- 4. Исполнители, чьё имя состоит из одного слова.
SELECT name
FROM artists
WHERE name NOT LIKE '% %';

-- 1. Количество исполнителей в каждом жанре
SELECT g.name AS genre, COUNT(ag.artist_id) AS artist_count
FROM genres g
JOIN artist_genre ag ON g.genre_id = ag.genre_id
GROUP BY g.name;

-- 2. Количество треков, вошедших в альбомы 2019–2020 годов
SELECT COUNT(t.track_id) AS track_count
FROM tracks t
JOIN albums a ON t.album_id = a.album_id
WHERE a.release_year BETWEEN 2019 AND 2020;

-- 3. Средняя продолжительность треков по каждому альбому
SELECT a.title AS album, AVG(t.duration) AS avg_duration
FROM albums a
JOIN tracks t ON a.album_id = t.album_id
GROUP BY a.title;

-- 4. Все исполнители, которые не выпустили альбомы в 2020 году
SELECT ar.name AS artist
FROM artists ar
WHERE ar.artist_id NOT IN (
    SELECT aa.artist_id
    FROM artist_album aa
    JOIN albums a ON aa.album_id = a.album_id
    WHERE a.release_year = 2020
);

-- 5. Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами)
-- Для примера, выберем исполнителя с artist_id = 1
SELECT DISTINCT c.title AS collection
FROM collections c
JOIN collection_track ct ON c.collection_id = ct.collection_id
JOIN tracks t ON ct.track_id = t.track_id
JOIN albums a ON t.album_id = a.album_id
JOIN artist_album aa ON a.album_id = aa.album_id
WHERE aa.artist_id = 1;

-- 5. Название треков, которые содержат слово «мой» или «my».
SELECT title
FROM tracks
WHERE title ILIKE '%мой%' OR title ILIKE '%my%';
