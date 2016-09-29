-- TEST CASE For:
-- [CBRD-20523] Foreign Key Referential Constraints check on INSERT
-- We changed the rule to check 'Foreign Key Referential Constraints' on INSERT
-- So, apply of this test case to former CUBRID will lead to verdict 'fail'
--
-- 
-- CREATE two TABLEs, Parent/Child Respectively
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
-- 6. INSERT INTO CHILD TABLE(Check Foreign Key Referential Constraints check condition)
INSERT INTO b_tbl VALUES (201,NULL,1,'Bill');
INSERT INTO b_tbl VALUES (202,9,NULL,'Harry');
-- 7. Check Result
select * from b_tbl;
-- Case3: not permitted
-- 8. This is the error case: CUBRID should respond it is ERROR.
INSERT INTO b_tbl VALUES (301,9,1,'Jane');
-- 9. drop Tables
drop class b_tbl;
drop class a_tbl;
