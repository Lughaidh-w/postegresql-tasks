-- Create the bigtext table
CREATE TABLE bigtext (
    content TEXT
);

-- Insert 100,000 records using a WITH RECURSIVE CTE
WITH RECURSIVE generate_series AS (
    SELECT 100000 AS num
    UNION ALL
    SELECT num + 1 FROM generate_series WHERE num < 199999
)
INSERT INTO bigtext (content)
SELECT 'This is record number ' || num || ' of quite a few text records.'
FROM generate_series;
