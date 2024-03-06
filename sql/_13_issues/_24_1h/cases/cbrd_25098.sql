-- Verified the CBRD-25098
-- Problem where inst_num() is inappropriately changed to order_by_num() when a subquery containing an ORDER BY is view merged

-- orderby_num()
-- create table & insert data
drop table if exists tbl;
create table tbl(col1 int, col2 int, col3 int);
insert into tbl values(1,1,1),(2,2,2),(3,3,3);

-- const order by
select
	/*+ RECOMPILE */
	col2,col3,orderby_num()
	,(select 1 from tbl order by col1 limit 1) as "scala col1"
from tbl 
where col2 = 1 
order by col2 for orderby_num() <= 1;

-- const order by with group by
select
	/*+ RECOMPILE */
	col2,col3,orderby_num()
	,(select col2 from tbl order by col1 limit 1) as "scala col1"
from tbl 
where col1 = 1 
group by col1,col2 
order by col1;


-- view merge
-- create table & insert data
drop table if exists tbl1;
drop table if exists tbl2;

create table tbl1 (col1 int, col2 int);
create table tbl2 (col3 int, col4 int);

insert into tbl1 values (1,1),(2,2),(3,3);
insert into tbl2 values (1,1),(2,2),(3,3);


-- view merge 1
SELECT
	/*+ RECOMPILE */
	rownum,
	(
		SELECT
			col3
		FROM tbl2
		WHERE
			col3 = X.col1
			AND ROWNUM =1
	) AS test
FROM
(
	SELECT
		t1.col1
	FROM tbl1 t1
	ORDER BY t1.col1
) X;

-- view merge 2
SELECT
	/*+ RECOMPILE */
	rownum,
	(
		SELECT
			col3
		FROM tbl2
		WHERE
			col3 = X.col1
			AND ROWNUM =1
	 ) AS test
FROM
(
	SELECT
	t1.col1
	,(
		select
			1
		from tbl1
		where col1 = t1.col1
	) as col10
	FROM tbl1 t1
	GROUP BY t1.col1
	ORDER BY t1.col1
) X;

drop table tbl, tbl1, tbl2;
