-- TEST CASE For:
-- [CBRD-20523] Foreign Key Referential Constraints check on UPDATE
-- Notice:
-- We changed the rule to check 'Foreign Key Referential Constraints' on INSERT/UPDATE
-- So, apply of this test case to former CUBRID will lead to verdict 'fail'
--
-- 1. CREATE Parent TABLE
CREATE TABLE a_tbl (
ID INT,
name_id INT,
phone VARCHAR(10),
CONSTRAINT pk_id PRIMARY KEY (id,name_id)
);
-- 2. CREATE Child TABLE WITH FOREIGN KEY
CREATE TABLE b_tbl (
ID_b INT NOT NULL,
ID INT,
name_id INT,
name VARCHAR (10) NOT NULL,
CONSTRAINT pk_id PRIMARY KEY (id_B),
CONSTRAINT fk_id FOREIGN KEY (id,name_id) REFERENCES a_tbl (id,name_id)
ON DELETE CASCADE
);

-- 3. INSERT INTO PARENT TABLE
INSERT INTO a_tbl VALUES (1,1,'111-1111'), (2,2,'222-2222'), (3,3, '333-3333');
-- 4. INSERT INTO CHILD TABLE(normal case)
INSERT INTO b_tbl VALUES (101,1,1,'George');
INSERT INTO b_tbl VALUES (102,2,2,'John');
INSERT INTO b_tbl VALUES (103,NULL,NULL,'Mary');
-- 5. Check the result of INSERT
select * from b_tbl;
--
-- 6. DO Update
UPDATE b_tbl
set id=NULL
where id_b = 101;

UPDATE b_tbl
set id=8
where id_b= 103;
--
-- 7. Check RESULT for verdict
--
SELECT * FROM B_TBL;
--
-- 8. This should be failed
UPDATE b_tbl
set name_id = 1
where id_b = 103;

drop class b_tbl;
drop class a_tbl;
