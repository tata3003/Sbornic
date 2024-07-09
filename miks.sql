
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

-- 5. Название треков, которые содержат слово «мой» или «my».
SELECT title
FROM tracks
WHERE title ILIKE '%мой%' OR title ILIKE '%my%';
