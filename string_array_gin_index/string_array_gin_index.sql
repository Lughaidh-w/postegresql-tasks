-- Drop the table if it already exists
DROP TABLE IF EXISTS docs03;

-- Create the docs03 table
CREATE TABLE docs03 (id SERIAL, doc TEXT, PRIMARY KEY(id));

-- Insert values
INSERT INTO docs03 (doc) VALUES
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

-- Insert filler rows
INSERT INTO docs03 (doc) 
SELECT 'Neon ' || generate_series(10000, 20000);

-- Create GIN index
CREATE INDEX array03 ON docs03 USING gin(string_to_array(lower(doc), ' ') array_ops);


-- Run Query
SELECT id, doc FROM docs03 WHERE '{particularly}' <@ words;

EXPLAIN SELECT id, doc FROM docs03 WHERE '{particularly}' <@ words;
