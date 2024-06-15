# String Array GIN Index

Task:
In this assignment, you will create a table of documents and then produce a GIN-based text[] reverse index for those documents that identifies each document which contains a particular word using SQL. 
FYI: In contrast with the provided sample SQL, you will map all the words in the GIN index to lower case (i.e. Python, PYTHON, and python should all end up as "python" in the GIN index). 

Here are the one-line documents that you are to insert into docs03: 
```
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
```
