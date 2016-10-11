-- TEST CASE For:
-- [CBRD-20523] Foreign Key Referential
--   Constraints on check on INSERT/UPDATE
-- Notice:
--   We changed the rule to check 'Foreign Key
--   Referential Constraints' on INSERT/UPDATE
--   So, apply this test case to former CUBRID
--   will lead to verdict 'fail'
-- 

DROP TABLE IF EXISTS b_tbl;
DROP TABLE IF EXISTS a_tbl;

-- 1. CREATE Parent TABLE
CREATE TABLE a_tbl (
ID INT,
name_id INT,
card varchar(20),
phone VARCHAR(10),
CONSTRAINT pk_id PRIMARY KEY (id,card,name_id)
);

-- 2. CREATE Child TABLE WITH FOREIGN KEYs
CREATE TABLE b_tbl (
ID_b INT NOT NULL,
ID INT,
name_id INT,
card varchar(20),
name VARCHAR (10) NOT NULL,
CONSTRAINT pk_id PRIMARY KEY (id_B),
CONSTRAINT fk_id FOREIGN KEY (id,card,name_id) REFERENCES a_tbl (id,card,name_id)
ON DELETE CASCADE
);

-- 3. INSERT INTO PARENT TABLE
INSERT INTO a_tbl VALUES (1,1,'1111111111x','111-1111'), (2,2,'2222222222x','222-2222'), (3,3,'3333333333x', '333-3333');

-- 4. INSERT INTO CHILD TABLE(normal case)
INSERT INTO b_tbl VALUES (101,1,1,'1111111111x','George');
INSERT INTO b_tbl VALUES (102,2,2,'2222222222x','John');
INSERT INTO b_tbl VALUES (103,NULL,NULL,NULL,'Mary');

-- 5. Check the result of INSERT
select * from b_tbl order by 1;

-- 6. INSERT INTO CHILD TABLE
--    (Check Foreign Key Referential Constraints
--    check condition)
INSERT INTO b_tbl VALUES (201,NULL,1,'1111111111x','Bill');
INSERT INTO b_tbl VALUES (202,9,NULL,'2222222222x','Harry');
INSERT INTO b_tbl VALUES (203,8,8,NULL,'George');
INSERT INTO b_tbl VALUES (204,7,NULL,NULL,'John');

-- 7. Check Result
select * from b_tbl order by 1;

-- 8. Do UPDATE
UPDATE b_tbl set id=NULL where id_b = 101;
UPDATE b_tbl set id=8 where id_b= 103;

-- 9. Check Result
select * from b_tbl order by 1;

-- 10. NOT PERMITTED CASE: (Invalid Foreign Key)
INSERT INTO b_tbl VALUES (301,9,1,'5555555555x','Jane');
UPDATE b_tbl set id=5 where id_b = 102;

-- 9. drop Tables
drop class b_tbl;
drop class a_tbl;
