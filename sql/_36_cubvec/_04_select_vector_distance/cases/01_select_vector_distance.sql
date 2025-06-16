-- Drop existing table
DROP IF EXISTS items;

-- Step 1: Create the table
CREATE TABLE items (id int, vc1 vector(3));

-- Step 2: Create the vector index
CREATE VECTOR INDEX idx_v ON items(vc1 EUCLIDEAN) WITH (m = 16, efConstruction = 64);

-- Step 3: Insert data
INSERT INTO items VALUES (1, '[1,2,3]');
INSERT INTO items VALUES (2, '[1,0,2]');
INSERT INTO items VALUES (3, '[3,4,5]');
INSERT INTO items VALUES (4, '[0,0,1]');
INSERT INTO items VALUES (5, '[5,6,7]');
INSERT INTO items VALUES (6, '[9,8,7]');
INSERT INTO items VALUES (7, '[1,1,0]');
INSERT INTO items VALUES (8, '[0,1,0]');
INSERT INTO items VALUES (9, '[1,1,1]');
INSERT INTO items VALUES (10, '[1,0,1]');
INSERT INTO items VALUES (11, '[2,3,4]');
INSERT INTO items VALUES (12, '[1,1,1]');

-- Step 4: Select data by Vector ANN query
SELECT id FROM items ORDER by l2_distance(vc1, '[0,0,0]') LIMIT 3;
SELECT id FROM items WHERE id < 11 ORDER by l2_distance(vc1, '[1,2,3]') LIMIT 5;

