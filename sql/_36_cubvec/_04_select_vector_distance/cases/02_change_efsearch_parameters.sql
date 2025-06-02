-- Drop existing table
DROP TABLE items;

-- Step 1: Create the table
CREATE TABLE items (id int, vc1 vector(16)) DONT_REUSE_OID;

-- Step 2: Create the vector index with custom HNSW parameters
CREATE VECTOR INDEX idx_v ON items(vc1 EUCLIDEAN)
WITH (m = 16, efConstruction = 64);

-- Step 3: Insert 100 random vectors

  INSERT INTO items VALUES (1, '[3,1,3,8,0,6,1,0,0,7,3,9,1,9,2,5]');
  INSERT INTO items VALUES (2, '[7,8,8,3,0,6,2,4,6,3,1,6,0,4,2,2]');
  INSERT INTO items VALUES (3, '[2,1,3,4,2,8,9,9,8,7,9,6,6,4,3,1]');
  INSERT INTO items VALUES (4, '[4,5,2,9,7,8,8,5,8,3,2,8,3,5,7,3]');
  INSERT INTO items VALUES (5, '[9,8,3,2,6,5,5,8,2,0,3,6,0,7,3,7]');
  INSERT INTO items VALUES (6, '[2,2,4,2,6,9,5,1,5,4,0,0,1,5,3,1]');
  INSERT INTO items VALUES (7, '[8,7,3,1,4,4,9,4,2,7,5,7,1,2,2,2]');
  INSERT INTO items VALUES (8, '[8,2,4,2,0,5,1,8,7,5,4,8,0,9,1,8]');
  INSERT INTO items VALUES (9, '[1,8,2,3,2,3,8,8,3,7,4,5,3,9,2,1]');
  INSERT INTO items VALUES (10, '[3,2,5,7,9,8,8,7,1,1,2,3,0,0,7,2]');
  INSERT INTO items VALUES (11, '[5,0,5,0,7,4,8,6,7,8,8,5,4,8,6,4]');
  INSERT INTO items VALUES (12, '[3,3,7,2,5,4,7,5,2,1,0,8,2,7,4,9]');
  INSERT INTO items VALUES (13, '[5,1,0,9,5,9,7,4,3,9,7,1,1,3,9,1]');
  INSERT INTO items VALUES (14, '[1,2,2,0,0,5,0,4,5,2,0,2,1,0,3,4]');
  INSERT INTO items VALUES (15, '[2,2,8,1,5,6,4,0,8,2,3,2,0,6,5,9]');
  INSERT INTO items VALUES (16, '[8,4,2,7,0,7,2,4,2,1,0,6,6,1,1,7]');
  INSERT INTO items VALUES (17, '[0,9,1,4,9,5,7,6,0,0,4,9,4,3,0,1]');
  INSERT INTO items VALUES (18, '[3,0,9,5,8,6,4,2,2,3,4,5,1,2,9,7]');
  INSERT INTO items VALUES (19, '[6,5,6,6,5,8,3,4,7,1,5,4,5,3,2,5]');
  INSERT INTO items VALUES (20, '[2,3,3,4,9,4,7,5,2,7,7,7,8,6,2,3]');
  INSERT INTO items VALUES (21, '[5,2,3,0,2,1,2,5,5,0,0,5,9,6,0,6]');
  INSERT INTO items VALUES (22, '[2,0,2,9,6,5,1,5,2,0,1,0,5,1,5,3]');
  INSERT INTO items VALUES (23, '[7,4,3,7,3,8,1,2,4,4,5,8,9,9,5,7]');
  INSERT INTO items VALUES (24, '[4,7,3,7,1,4,1,1,5,7,0,6,9,4,8,2]');
  INSERT INTO items VALUES (25, '[9,6,1,7,9,1,3,9,2,6,6,0,9,0,1,2]');
  INSERT INTO items VALUES (26, '[4,9,2,6,4,6,4,6,4,1,8,7,4,9,0,6]');
  INSERT INTO items VALUES (27, '[2,9,5,6,7,9,6,2,2,5,3,6,5,0,2,7]');
  INSERT INTO items VALUES (28, '[7,0,9,4,3,1,1,8,2,6,3,5,4,5,0,3]');
  INSERT INTO items VALUES (29, '[8,0,9,2,8,4,1,0,0,8,6,2,3,5,3,1]');
  INSERT INTO items VALUES (30, '[8,3,8,0,9,2,5,5,1,9,6,2,0,0,5,7]');
  INSERT INTO items VALUES (31, '[4,6,9,4,1,3,9,6,4,0,4,4,8,3,2,1]');
  INSERT INTO items VALUES (32, '[5,4,3,4,9,0,9,0,3,1,9,7,4,6,6,6]');
  INSERT INTO items VALUES (33, '[9,8,7,5,0,6,5,3,7,4,7,7,8,4,4,9]');
  INSERT INTO items VALUES (34, '[5,2,3,4,6,1,7,8,2,7,0,0,8,9,1,6]');
  INSERT INTO items VALUES (35, '[3,9,6,3,9,2,2,9,0,9,9,7,3,4,2,0]');
  INSERT INTO items VALUES (36, '[3,7,4,7,8,8,8,3,8,9,5,7,0,9,3,4]');
  INSERT INTO items VALUES (37, '[7,3,2,0,9,1,3,6,1,4,6,6,2,5,0,2]');
  INSERT INTO items VALUES (38, '[3,9,8,4,1,7,8,7,0,4,4,5,7,2,3,3]');
  INSERT INTO items VALUES (39, '[1,4,1,3,2,9,4,5,7,7,2,7,1,3,3,6]');
  INSERT INTO items VALUES (40, '[2,4,2,8,0,4,3,0,0,1,9,1,9,0,7,5]');
  INSERT INTO items VALUES (41, '[9,8,8,0,0,5,0,7,4,6,8,8,6,3,2,8]');
  INSERT INTO items VALUES (42, '[6,1,6,6,3,1,8,6,3,4,1,1,3,6,9,2]');
  INSERT INTO items VALUES (43, '[9,7,3,2,3,7,6,1,3,8,3,0,7,6,5,9]');
  INSERT INTO items VALUES (44, '[9,6,9,0,6,6,9,2,7,6,5,9,2,7,2,7]');
  INSERT INTO items VALUES (45, '[7,3,4,9,9,5,0,0,2,9,7,1,0,2,2,0]');
  INSERT INTO items VALUES (46, '[0,7,9,8,2,6,7,5,8,1,6,0,5,8,9,5]');
  INSERT INTO items VALUES (47, '[7,9,0,1,3,1,0,0,7,1,6,7,2,9,3,4]');
  INSERT INTO items VALUES (48, '[7,4,4,8,3,1,9,2,7,5,6,6,3,3,3,8]');
  INSERT INTO items VALUES (49, '[7,8,1,2,3,1,9,8,8,2,9,7,7,7,5,5]');
  INSERT INTO items VALUES (50, '[2,4,0,2,3,7,2,6,4,1,1,9,3,2,1,9]');
  INSERT INTO items VALUES (51, '[3,8,0,4,7,9,0,9,6,0,2,3,5,9,1,9]');
  INSERT INTO items VALUES (52, '[0,5,9,8,5,3,8,0,3,6,5,7,5,0,2,0]');
  INSERT INTO items VALUES (53, '[4,9,1,1,9,1,0,2,3,4,0,8,4,7,4,5]');
  INSERT INTO items VALUES (54, '[5,7,2,2,3,4,6,9,0,0,6,3,0,6,4,4]');
  INSERT INTO items VALUES (55, '[6,5,2,2,5,4,0,2,9,0,3,0,8,2,6,4]');
  INSERT INTO items VALUES (56, '[1,1,7,2,5,2,7,7,7,3,9,5,5,0,1,0]');
  INSERT INTO items VALUES (57, '[7,5,7,0,8,7,6,8,5,8,7,6,0,7,8,7]');
  INSERT INTO items VALUES (58, '[4,4,8,6,9,8,7,5,0,0,5,6,7,3,4,5]');
  INSERT INTO items VALUES (59, '[3,4,4,1,6,1,2,1,4,7,7,2,4,2,1,2]');
  INSERT INTO items VALUES (60, '[4,0,0,7,7,9,3,1,7,7,6,5,7,9,0,6]');
  INSERT INTO items VALUES (61, '[8,8,8,2,6,8,3,0,4,0,9,5,1,3,9,0]');
  INSERT INTO items VALUES (62, '[9,1,5,7,6,5,6,4,9,2,0,2,1,8,4,4]');
  INSERT INTO items VALUES (63, '[3,3,3,5,7,0,9,4,0,3,9,0,8,3,1,9]');
  INSERT INTO items VALUES (64, '[4,7,8,5,6,0,3,8,6,6,7,3,0,0,1,0]');
  INSERT INTO items VALUES (65, '[2,4,4,3,0,1,6,0,4,2,7,7,0,7,6,1]');
  INSERT INTO items VALUES (66, '[9,1,5,8,0,9,4,4,8,6,7,8,2,0,1,9]');
  INSERT INTO items VALUES (67, '[5,2,3,8,6,8,4,7,0,5,6,8,2,3,3,7]');
  INSERT INTO items VALUES (68, '[2,0,0,6,3,1,4,5,2,0,3,3,1,9,4,0]');
  INSERT INTO items VALUES (69, '[8,1,0,3,1,0,2,0,3,7,2,9,8,4,6,1]');
  INSERT INTO items VALUES (70, '[5,4,1,6,4,6,0,8,5,6,9,2,5,2,9,1]');
  INSERT INTO items VALUES (71, '[3,3,4,0,2,4,9,0,9,3,3,8,9,3,1,3]');
  INSERT INTO items VALUES (72, '[6,7,2,9,8,7,6,2,9,7,4,7,8,8,4,9]');
  INSERT INTO items VALUES (73, '[7,6,7,9,8,9,0,1,3,5,0,7,8,2,8,4]');
  INSERT INTO items VALUES (74, '[8,4,6,7,6,1,4,2,5,7,0,8,9,5,3,0]');
  INSERT INTO items VALUES (75, '[2,5,3,6,8,7,3,0,2,5,3,2,6,0,8,1]');
  INSERT INTO items VALUES (76, '[9,0,0,8,4,0,5,5,7,0,3,1,0,4,2,5]');
  INSERT INTO items VALUES (77, '[7,3,7,0,8,6,8,9,9,7,7,9,4,9,0,7]');
  INSERT INTO items VALUES (78, '[7,6,8,4,2,2,5,3,3,6,4,8,7,8,5,3]');
  INSERT INTO items VALUES (79, '[2,0,6,1,9,3,2,7,3,4,1,2,4,8,1,3]');
  INSERT INTO items VALUES (80, '[5,5,2,8,3,7,2,6,3,1,6,1,3,8,6,8]');
  INSERT INTO items VALUES (81, '[2,8,8,7,9,9,8,5,2,6,9,6,8,0,8,9]');
  INSERT INTO items VALUES (82, '[2,9,3,1,4,3,4,5,0,0,3,1,8,0,3,7]');
  INSERT INTO items VALUES (83, '[1,2,2,3,9,8,2,1,1,5,4,6,8,7,1,6]');
  INSERT INTO items VALUES (84, '[6,3,2,7,0,7,1,6,2,3,4,8,9,6,3,8]');
  INSERT INTO items VALUES (85, '[1,0,7,9,9,7,8,0,0,2,1,2,7,4,0,6]');
  INSERT INTO items VALUES (86, '[1,0,8,1,8,8,1,5,1,1,5,2,1,1,9,6]');
  INSERT INTO items VALUES (87, '[8,4,4,3,2,3,2,7,3,3,4,4,5,6,9,5]');
  INSERT INTO items VALUES (88, '[7,8,8,4,5,6,7,5,5,6,0,2,0,6,2,4]');
  INSERT INTO items VALUES (89, '[0,6,4,9,3,5,8,8,6,7,8,1,2,4,8,6]');
  INSERT INTO items VALUES (90, '[7,2,9,1,7,8,5,2,0,4,1,2,1,8,9,2]');
  INSERT INTO items VALUES (91, '[6,9,7,5,5,6,7,7,4,2,0,0,9,2,8,3]');
  INSERT INTO items VALUES (92, '[5,8,8,8,8,8,7,4,1,3,9,7,5,2,6,2]');
  INSERT INTO items VALUES (93, '[8,9,4,9,2,5,5,3,3,4,9,9,8,3,7,2]');
  INSERT INTO items VALUES (94, '[3,5,5,1,8,2,1,6,0,9,2,4,2,7,6,1]');
  INSERT INTO items VALUES (95, '[2,3,4,2,2,1,4,4,5,5,6,9,5,4,8,2]');
  INSERT INTO items VALUES (96, '[8,9,7,2,0,7,9,3,6,8,2,7,1,4,1,0]');
  INSERT INTO items VALUES (97, '[7,6,9,8,9,2,9,6,5,9,3,0,6,2,8,2]');
  INSERT INTO items VALUES (98, '[0,7,5,7,0,9,7,9,5,0,6,0,7,1,1,7]');
  INSERT INTO items VALUES (99, '[0,0,2,4,2,5,1,6,3,8,3,1,6,5,8,0]');
  INSERT INTO items VALUES (100, '[2,1,0,4,0,6,3,2,3,5,9,8,1,5,2,6]');

-- Step 4: Test query with low efSearch (approximate)
SET SYSTEM PARAMETERS 'hnsw_ef_search=1';
SELECT /*+ RECOMPILE */ id
FROM items
ORDER BY l2_distance(vc1, '[5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5]')
LIMIT 10;

-- Step 6: Test query with high efSearch (accurate)
SET SYSTEM PARAMETERS 'hnsw_ef_search=1000';
SELECT /*+ RECOMPILE */ id
FROM items
ORDER BY l2_distance(vc1, '[5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5]')
LIMIT 10;

SELECT /*+ RECOMPILE */ id, l2_distance(vc1, '[5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5]') AS dist
FROM items
ORDER BY dist
LIMIT 10;