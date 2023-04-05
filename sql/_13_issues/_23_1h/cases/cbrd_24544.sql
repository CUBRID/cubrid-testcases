-- This test case verifies CBRD-24544 issue.
-- not allow to alter the column type to a type that does not support auto-increment.
-- If the auto-increment column type is overflown as altering the type, the ALTER command results error.

DROP TABLE IF EXISTS a_tbl;
CREATE TABLE a_tbl (a int auto_increment);

show create table a_tbl;
-- error cases
ALTER TABLE a_tbl MODIFY COLUMN a NUMERIC(10,2); 
ALTER TABLE a_tbl MODIFY COLUMN a VARCHAR(10);
ALTER TABLE a_tbl MODIFY COLUMN a DOUBLE;
ALTER TABLE a_tbl MODIFY COLUMN a FLOAT;
ALTER TABLE a_tbl MODIFY COLUMN a DATE;

-- success case
ALTER TABLE a_tbl MODIFY COLUMN a SHORT;
show full columns from a_tbl;
ALTER TABLE a_tbl MODIFY COLUMN a BIGINT;
show full columns from a_tbl;
ALTER TABLE a_tbl MODIFY COLUMN a INT;
show full columns from a_tbl;

DROP TABLE a_tbl;


-- constrain violation error case
CREATE TABLE a_tbl (a INT AUTO_INCREMENT (1, 70000), b INT);
INSERT INTO a_tbl (b) VALUES (1);
INSERT INTO a_tbl (b) VALUES (2);
show create table a_tbl;

-- error
ALTER TABLE a_tbl MODIFY COLUMN a SHORT;

DROP TABLE a_tbl;
