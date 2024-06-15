-- Create Table
DROP TABLE IF EXISTS docs03;
CREATE TABLE docs03 (id SERIAL, doc TEXT, PRIMARY KEY(id));

-- Insert data
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
INSERT INTO docs03 (doc) SELECT 'Neon ' || generate_series(10000,20000);

-- Create index
CREATE INDEX fulltext03 ON docs03 USING gin(to_tsvector('english', doc));

-- Perform query
SELECT id, doc FROM docs03 WHERE to_tsquery('english', 'particularly') @@ to_tsvector('english', doc);
EXPLAIN SELECT id, doc FROM docs03 WHERE to_tsquery('english', 'particularly') @@ to_tsvector('english', doc);
