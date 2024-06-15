-- Drop the tables if they already exist
DROP TABLE IF EXISTS invert01;
DROP TABLE IF EXISTS docs01;

-- Create the docs01 table
CREATE TABLE docs01 (
  id SERIAL PRIMARY KEY,
  doc TEXT
);

-- Insert the provided documents into docs01
INSERT INTO docs01 (doc) VALUES
('your source code from a file it knows to stop when it reaches the end'),
('What is a program'),
('The definition of a program at its most basic is a'),
('sequence of Python statements that have been crafted to do something'),
('Even our simple hellopy script is a program It is a'),
('oneline program and is not particularly useful but in the strictest'),
('definition it is a Python program'),
('It might be easiest to understand what a program is by thinking about a'),
('problem that a program might be built to solve and then looking at a'),
('program that would solve that problem');

-- Create the invert01 table
CREATE TABLE invert01 (
  keyword TEXT,
  doc_id INTEGER REFERENCES docs01(id) ON DELETE CASCADE
);

-- Populate the invert01 table with the reverse index
WITH doc_words AS (
  SELECT id AS doc_id, 
         unnest(string_to_array(lower(regexp_replace(doc, '[^\w\s]', '', 'g')), ' ')) AS keyword
  FROM docs01
)
INSERT INTO invert01 (keyword, doc_id)
SELECT DISTINCT keyword, doc_id
FROM doc_words
WHERE keyword <> '';

-- Query to verify the results
SELECT keyword, doc_id 
FROM invert01 
ORDER BY keyword, doc_id 
LIMIT 10;
