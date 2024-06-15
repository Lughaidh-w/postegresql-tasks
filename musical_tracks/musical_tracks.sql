-- Drop the unesco_raw table if it exists
DROP TABLE IF EXISTS unesco_raw;

-- Create the unesco_raw table
CREATE TABLE unesco_raw
 (name TEXT, description TEXT, justification TEXT, year INTEGER,
    longitude FLOAT, latitude FLOAT, area_hectares FLOAT,
    category TEXT, category_id INTEGER, state TEXT, state_id INTEGER,
    region TEXT, region_id INTEGER, iso TEXT, iso_id INTEGER);

-- Create lookup tables
CREATE TABLE category (
  id SERIAL,
  name VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);

CREATE TABLE state (
  id SERIAL,
  name VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);

CREATE TABLE region (
  id SERIAL,
  name VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);

CREATE TABLE iso (
  id SERIAL,
  name VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);

-- Create the unesco table to store normalized data
CREATE TABLE unesco (
  id SERIAL,
  name TEXT,
  description TEXT,
  justification TEXT,
  year INTEGER,
  longitude FLOAT,
  latitude FLOAT,
  area_hectares FLOAT,
  category_id INTEGER REFERENCES category(id),
  state_id INTEGER REFERENCES state(id),
  region_id INTEGER REFERENCES region(id),
  iso_id INTEGER REFERENCES iso(id),
  PRIMARY KEY(id)
);

-- Load the CSV data into the unesco_raw table
\copy unesco_raw(name,description,justification,year,longitude,latitude,area_hectares,category,state,region,iso) FROM '~/Downloads/csv/whc-sites-2018-small.csv' WITH DELIMITER ',' CSV HEADER;

-- Insert distinct categories
INSERT INTO category (name)
SELECT DISTINCT category
FROM unesco_raw
WHERE category IS NOT NULL;

-- Insert distinct states
INSERT INTO state (name)
SELECT DISTINCT state
FROM unesco_raw
WHERE state IS NOT NULL;

-- Insert distinct regions
INSERT INTO region (name)
SELECT DISTINCT region
FROM unesco_raw
WHERE region IS NOT NULL;

-- Insert distinct isos
INSERT INTO iso (name)
SELECT DISTINCT iso
FROM unesco_raw
WHERE iso IS NOT NULL;

-- Update unesco_raw with foreign keys
UPDATE unesco_raw
SET category_id = (SELECT id FROM category WHERE name = unesco_raw.category),
    state_id = (SELECT id FROM state WHERE name = unesco_raw.state),
    region_id = (SELECT id FROM region WHERE name = unesco_raw.region),
    iso_id = (SELECT id FROM iso WHERE name = unesco_raw.iso);

-- Insert data from unesco_raw into the unesco table
INSERT INTO unesco (name, description, justification, year, longitude, latitude, area_hectares, category_id, state_id, region_id, iso_id)
SELECT name, description, justification, year, longitude, latitude, area_hectares, category_id, state_id, region_id, iso_id
FROM unesco_raw;

-- Verification query
SELECT unesco.name, year, category.name, state.name, region.name, iso.name
FROM unesco
JOIN category ON unesco.category_id = category.id
JOIN iso ON unesco.iso_id = iso.id
JOIN state ON unesco.state_id = state.id
JOIN region ON unesco.region_id = region.id
ORDER BY year, unesco.name
LIMIT 3;
