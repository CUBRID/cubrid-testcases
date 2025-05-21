-- Verified for CBRD-25352
-- check to JAVASP

evaluate 'create JAVASP function';
CREATE FUNCTION hello(name varchar) RETURN STRING
AS LANGUAGE JAVA
NAME 'SpTest.Hello(java.lang.String) return java.lang.String';

CREATE FUNCTION public.Sp_int(i int) RETURN int
AS LANGUAGE JAVA
NAME 'SpTest.testInt(int) return int';

evaluate 'create test table & add test data';
CREATE TABLE tbl1 (col1 int, col2 int, col3 varchar);

INSERT INTO tbl1 SELECT 1, public.sp_int(0), 'test1' FROM dual;
INSERT INTO tbl1 VALUES(2, public.sp_int(1), 'test2');
INSERT INTO tbl1 VALUES(3, public.sp_int(2), 'test3');
INSERT INTO tbl1 VALUES(4, public.sp_int(3), hello('cubrid'));
INSERT INTO tbl1 VALUES(5, select public.sp_int(3) * 2 from dual, select dba.hello('cubrid'));

SELECT * FROM tbl1 order by col1;

evaluate 'Scalar Subquery with dba.hello';
SELECT
	col1,
	public.sp_int(col1) as col2,
	(select hello('a') from dual limit 1) as col3,
	col3 as col4
from
	tbl1;

evaluate 'CTE query with public.sp_int';
WITH tt AS 
	(
      SELECT
			col1,
			public.sp_int(col1) as col2
		FROM
			tbl1 a
		where
			a.col1 = public.sp_int(col1)
			or a.col1 != public.sp_int(col1)
	)
select
	*
from	
	(
		select
			*,
			'aaa' col3
		from
			tt
	) t1,
	(
		select
			*,
			'bbb' col3
		from
			tt
	) t2,
	(
		select
			*,
			'ccc' col3
		from
			tt
	) t3
where 
	t1.col2 = t2.col2
	and t1.col2 = t3.col2
order by t1.col1, t1.col2;

evaluate 'Inline View with public.sp_int';
SELECT
	*
FROM
	tbl1 a,
	(select public.sp_int(1) as col1) b
where
	a.col1 = b.col1
order by a.col1;

evaluate 'Subquery with public.sp_int';
SELECT
	*
FROM
	tbl1 a
where
	a.col1 = public.sp_int(1)
order by a.col1;

evaluate 'Test done';
drop function hello;
drop function public.sp_int;
drop table tbl1;
