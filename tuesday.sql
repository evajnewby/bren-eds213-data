-- Start with SQL
SELECT * FROM Site;
-- SQL is case-insensitive, but uppercase is the tradition
select * from site;

-- SELECT *: all rows, all columns

-- LIMIT clause
SELECT *
    FROM Site
    LIMIT 3;


--- can be combined with OFFSET clause
SELECT * FROM Site
    LIMIT 3
    OFFSET 3;


-- Selecting distinct items
SELECT * FROM Bird_nests LIMIT 1;
SELECT Species FROM Bird_nests;
SELECT DISTINCT Species FROM Bird_nests;
SELECT DISTINCT Species, Observer FROM Bird_nests;

-- add ordering
SELECT DISTINCT Species, Observer
    FROM Bird_nests
    ORDER BY Species, Observer DESC;

-- Select distinct locations from the Site table
-- Are they returned in order? If not, order them. 
