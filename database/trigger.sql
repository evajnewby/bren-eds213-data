-- Week 5 - Create a trigger
-- Author: Eva Newby

-- setup
sqlite3 database/database.sqlite

-- Part 1
-- Check that there are 3 eggs in nest 14eabaage01:
SELECT * FROM Bird_eggs WHERE Nest_ID = '14eabaage01';

-- create a copy of the Bird_eggs table
CREATE TABLE Bird_eggs_copy AS SELECT * FROM Bird_eggs;

-- create a trigger that will fire an UPDATE statement to fill in value for Egg_num.
-- Create the AFTER INSERT trigger for the Bird_eggs table
CREATE TRIGGER egg_filler
AFTER INSERT ON Bird_eggs_copy   -- Trigger is fired after an insert operation on the Bird_eggs table
FOR EACH ROW 
BEGIN
    UPDATE Bird_eggs_copy
    SET Egg_num = (  -- Set the Egg_num field to the next number
        SELECT IFNULL (MAX(Egg_num),0) + 1  
        FROM Bird_eggs_copy
        WHERE Nest_ID = NEW.Nest_ID AND Egg_num is NOT NULL 
    )
    WHERE Nest_ID = NEW.Nest_ID and Egg_num is NULL; 
END;

-- Add null into Nest_ID
INSERT INTO Bird_eggs_copy (Book_page, Year, Site, Nest_ID, Length, Width, Egg_num)
VALUES ('b14.6', 2014, 'eaba', '14eabaage01', 12.34, 56.78, NULL);

-- Check    
SELECT * FROM Bird_eggs_copy WHERE Nest_ID = '14eabaage01';

-- Part 2
-- Nest_ID, new.Length, and new.Width, what SELECT statements could you use to find the correct values for Book_page, Year, and Nest_ID?

CREATE TRIGGER egg_filler2
AFTER INSERT ON Bird_eggs_copy
FOR EACH ROW
WHEN NEW.Egg_num IS NULL
BEGIN
    UPDATE Bird_eggs_copy
    SET 
        Egg_num = (
            SELECT COALESCE(MAX(Egg_num), 0) + 1
            FROM Bird_eggs_copy
            WHERE Nest_ID = NEW.Nest_ID
        ),
        Book_page = (
            SELECT Book_page FROM Bird_nests WHERE Nest_ID = NEW.Nest_ID
        ),
        Year = (
            SELECT Year FROM Bird_nests WHERE Nest_ID = NEW.Nest_ID
        ),
        Site = (
            SELECT Site FROM Bird_nests WHERE Nest_ID = NEW.Nest_ID
        )
    WHERE rowid = NEW.rowid;
END;


--Test
INSERT INTO Bird_eggs
    (Nest_ID, Length, Width)
    VALUES ('14eabaage01', 12.34, 56.78);

-- view results
SELECT * FROM Bird_eggs_copy WHERE Nest_ID = '14eabaage01';
