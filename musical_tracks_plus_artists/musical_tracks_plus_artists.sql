-- Drop existing tables if they exist
DROP TABLE IF EXISTS album CASCADE;
DROP TABLE IF EXISTS track CASCADE;
DROP TABLE IF EXISTS artist CASCADE;
DROP TABLE IF EXISTS tracktoartist CASCADE;

-- Create the album table
CREATE TABLE album (
    id SERIAL,
    title VARCHAR(128) UNIQUE,
    PRIMARY KEY(id)
);

-- Create the track table
CREATE TABLE track (
    id SERIAL,
    title TEXT, 
    artist TEXT, 
    album TEXT, 
    album_id INTEGER REFERENCES album(id) ON DELETE CASCADE,
    count INTEGER, 
    rating INTEGER, 
    len INTEGER,
    PRIMARY KEY(id)
);

-- Create the artist table
CREATE TABLE artist (
    id SERIAL,
    name VARCHAR(128) UNIQUE,
    PRIMARY KEY(id)
);

-- Create the tracktoartist table
CREATE TABLE tracktoartist (
    id SERIAL,
    track VARCHAR(128),
    track_id INTEGER REFERENCES track(id) ON DELETE CASCADE,
    artist VARCHAR(128),
    artist_id INTEGER REFERENCES artist(id) ON DELETE CASCADE,
    PRIMARY KEY(id)
);

-- Load the CSV data into the track table
\copy track(title,artist,album,count,rating,len) FROM '~/Downloads/library.csv' WITH DELIMITER ',' CSV HEADER;

-- Insert distinct album titles into the album table
INSERT INTO album (title) 
SELECT DISTINCT album 
FROM track;

-- Update track table to set album_id
UPDATE track 
SET album_id = (SELECT album.id FROM album WHERE album.title = track.album);

-- Insert distinct artists into the artist table
INSERT INTO artist (name) 
SELECT DISTINCT artist 
FROM track;

-- Insert into tracktoartist table
INSERT INTO tracktoartist (track, artist) 
SELECT DISTINCT title, artist 
FROM track;

-- Update tracktoartist table with track_id
UPDATE tracktoartist 
SET track_id = (SELECT track.id FROM track WHERE track.title = tracktoartist.track);

-- Update tracktoartist table with artist_id
UPDATE tracktoartist 
SET artist_id = (SELECT artist.id FROM artist WHERE artist.name = tracktoartist.artist);

-- Clean up unnecessary columns
ALTER TABLE track DROP COLUMN album;
ALTER TABLE track DROP COLUMN artist;
ALTER TABLE tracktoartist DROP COLUMN track;
ALTER TABLE tracktoartist DROP COLUMN artist;

-- Verification query
SELECT track.title, album.title, artist.name
FROM track
JOIN album ON track.album_id = album.id
JOIN tracktoartist ON track.id = tracktoartist.track_id
JOIN artist ON tracktoartist.artist_id = artist.id
ORDER BY track.title
LIMIT 3;
