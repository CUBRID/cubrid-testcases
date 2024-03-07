-- Verified the CBRD-25098
-- Problem where inst_num() is inappropriately changed to order_by_num() when a subquery containing an ORDER BY is view merged

-- orderby_num()
-- create table & insert data
drop table if exists tbl;
create table tbl(col_one int, col_two int, col_three int);
insert into tbl values(1,1,1),(2,2,2),(3,3,3);

-- const order by
select
	/*+ RECOMPILE */
	col_two,col_three,orderby_num()
	,(select 1 from tbl order by col_one limit 1) as "scala col_one"
from tbl 
where col_two = 1 
order by col_two for orderby_num() <= 1;

-- const order by with group by
select
	/*+ RECOMPILE */
	col_two,col_three,orderby_num()
	,(select col_two from tbl order by col_one limit 1) as "scala col_one"
from tbl 
where col_one = 1 
group by col_one,col_two 
order by col_one;


-- view merge
-- create table & insert data
drop table if exists tbl_one;
drop table if exists tbl_two;

create table tbl_one (col_one int, col_two int);
create table tbl_two (col_three int, col_four int);

insert into tbl_one values (1,1),(2,2),(3,3);
insert into tbl_two values (1,1),(2,2),(3,3);


-- view merge 1
SELECT
	/*+ RECOMPILE */
	rownum,
	(
		SELECT
			col_three
		FROM tbl_two
		WHERE
			col_three = X.col_one
			AND ROWNUM =1
	) AS test
FROM
(
	SELECT
		t_one.col_one
	FROM tbl_one t_one
	ORDER BY t_one.col_one
) X;

-- view merge 2
SELECT
	/*+ RECOMPILE */
	rownum,
	(
		SELECT
			col_three
		FROM tbl_two
		WHERE
			col_three = X.col_one
			AND ROWNUM =1
	 ) AS test
FROM
(
	SELECT
	t_one.col_one
	,(
		select
			1
		from tbl_one
		where col_one = t_one.col_one
	) as col_one_another
	FROM tbl_one t_one
	GROUP BY t_one.col_one
	ORDER BY t_one.col_one
) X;

drop table tbl, tbl_one, tbl_two;
