-- Drop the tables if they already exist
DROP TABLE IF EXISTS invert02;
DROP TABLE IF EXISTS docs02;
DROP TABLE IF EXISTS stop_words;

-- Create the docs02 table
CREATE TABLE docs02 (
  id SERIAL PRIMARY KEY,
  doc TEXT
);

-- Insert the provided documents into docs02
INSERT INTO docs02 (doc) VALUES
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

-- Create the invert02 table
CREATE TABLE invert02 (
  keyword TEXT,
  doc_id INTEGER REFERENCES docs02(id) ON DELETE CASCADE
);

-- Create the stop_words table
CREATE TABLE stop_words (
  word TEXT UNIQUE
);

-- Insert the stop words into stop_words
INSERT INTO stop_words (word) VALUES 
('i'), ('a'), ('about'), ('an'), ('are'), ('as'), ('at'), ('be'), 
('by'), ('com'), ('for'), ('from'), ('how'), ('in'), ('is'), ('it'), ('of'), 
('on'), ('or'), ('that'), ('the'), ('this'), ('to'), ('was'), ('what'), 
('when'), ('where'), ('who'), ('will'), ('with');

-- Populate the invert02 table with the reverse index excluding stop words
WITH doc_words AS (
  SELECT id AS doc_id, 
         unnest(string_to_array(lower(regexp_replace(doc, '[^\w\s]', '', 'g')), ' ')) AS keyword
  FROM docs02
)
INSERT INTO invert02 (keyword, doc_id)
SELECT DISTINCT keyword, doc_id
FROM doc_words
WHERE keyword <> ''
AND keyword NOT IN (SELECT word FROM stop_words);

-- Query to verify the results
SELECT keyword, doc_id 
FROM invert02 
ORDER BY keyword, doc_id 
LIMIT 10;
