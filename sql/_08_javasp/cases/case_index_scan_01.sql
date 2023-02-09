;au off

CREATE FUNCTION intTest(x int) RETURN int AS LANGUAGE JAVA NAME 'SpTest7.typetestint(int) return int';

CREATE TABLE tbl1 (col1 INT, col2 INT);
CREATE INDEX i_tbl1 ON tbl1 (col1);

INSERT INTO tbl1 VALUES (1,10);
INSERT INTO tbl1 VALUES (2,10);
INSERT INTO tbl1 VALUES (3,10);
INSERT INTO tbl1 VALUES (4,10);
INSERT INTO tbl1 VALUES (5,10);
INSERT INTO tbl1 VALUES (6,10);
INSERT INTO tbl1 VALUES (7,10);
INSERT INTO tbl1 VALUES (8,10);
INSERT INTO tbl1 VALUES (9,10);
INSERT INTO tbl1 VALUES (10,10);

-- equal
select count(*) as "equal" from tbl1 where col1 = (select inttest(5) from dual);

-- in
select count(*) as "in" from tbl1 where col1 in (select inttest(5) from dual);
select count(*) as "in" from tbl1 where col1 in (select inttest(col1) from tbl1);

-- like
select count(*) as "like" from tbl1 where col1 like (select inttest(5) from dual);
select count(*) as "like" from tbl1 where col1 like (select inttest(col1) from tbl1);


drop function inttest, inttest2;

drop tbl1;

;au on
