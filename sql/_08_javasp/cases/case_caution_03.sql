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

select col1, col2, intTest(col1) from tbl1 for update;
select col1, col2, intTest(col1) from tbl1 order by intTest(col1) desc for update;

select col1, col2, intTest(99) from tbl1 for update;
select col1, col2, intTest(99) from tbl1 order by intTest(col1) desc for update;

drop function intTest;
drop tbl1;

;au on
