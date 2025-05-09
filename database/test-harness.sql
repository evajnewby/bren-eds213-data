-- week 5 - Create a test harness
-- on bash, I ran "%bash query_timer.sh with_index_a 1000 'SELECT COUNT(*) FROM Bird_nests'  database.db timings.csv"

SELECT * FROM read_csv('timings.csv') LIMIT 3;

/*
Output
┌──────────────┬─────────┐
│   column0    │ column1 │
│   varchar    │ double  │
├──────────────┼─────────┤
│ with_index_a │   0.014 │
│ with_index_a │   0.015 │
│ with_index_a │   0.014 │

*/

-- Part 2

-- Test with 500 repetitions
-- subquery (NOT IN):
bash query_timer.sh subquery 500 'SELECT Code FROM Species WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests);' database.db timings.csv

-- outer_join (RIGHT JOIN):
bash query_timer.sh outer_join 500 'SELECT Code FROM Bird_nests RIGHT JOIN Species ON Species = Code WHERE Nest_ID IS NULL;' database.db timings.csv

--except (Set operation):
bash query_timer.sh except 500 'SELECT Code FROM Species EXCEPT SELECT DISTINCT Species FROM Bird_nests;' database.db timings.csv


SELECT * FROM read_csv('timings.csv');

/*
Output
┌────────────┬─────────┐
│  column0   │ column1 │
│  varchar   │ double  │
├────────────┼─────────┤
│ subquery   │   0.014 │
│ except     │   0.016 │
│ outer_join │   0.016 │
└────────────┴─────────┘
*/

-- Test with 100 repetitions

bash query_timer.sh subquery 100 'SELECT Code FROM Species WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests);' database.db timings.csv
bash query_timer.sh outer_join 100 'SELECT Code FROM Bird_nests RIGHT JOIN Species ON Species = Code WHERE Nest_ID IS NULL;' database.db timings.csv
bash query_timer.sh except 100 'SELECT Code FROM Species EXCEPT SELECT DISTINCT Species FROM Bird_nests;' database.db timings.csv

SELECT * FROM read_csv('timings.csv');

/*
Output
┌────────────┬─────────┐
│  column0   │ column1 │
│  varchar   │ double  │
├────────────┼─────────┤
│ subquery   │   0.02  │
│ except     │   0.02  │
│ outer_join │   0.01  │
└────────────┴─────────┘
*/

-- Report back how many repetitions you had to use to get good timings, and which method is fastest.

/*
Tested two repetitions: 100 and 500

Based on the tests, 500 repetitions provide a more stable and reliable measurement of performance. 
The difference between 100 and 500 repetitions shows that results can fluctuate with fewer repetitions, especially for more complex queries.

Fastest Method - The outer_join was the fastest across both 100 and 500 repetitions. Therefore, outer_join is the most efficient method for this scenario.
*/
