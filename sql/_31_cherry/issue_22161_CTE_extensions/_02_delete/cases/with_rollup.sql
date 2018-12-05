drop table if exists sale_tbl;
CREATE TABLE sales_tbl
(dept_no INT, name VARCHAR(20), sales_month INT, sales_amount INT DEFAULT 100, PRIMARY KEY (dept_no, name, sales_month));

INSERT INTO sales_tbl VALUES
(201, 'George' , 1, 450), (201, 'George' , 2, 250), (201, 'Laura'  , 1, 100), (201, 'Laura'  , 2, 500),
(301, 'Max'    , 1, 300), (301, 'Max'    , 2, 300),
(501, 'Stephan', 1, 300), (501, 'Stephan', 2, DEFAULT), (501, 'Chang'  , 1, 150),(501, 'Chang'  , 2, 150),
(501, 'Sue'    , 1, 150), (501, 'Sue'    , 2, 200);


drop table if exists sales_tbl2;
CREATE TABLE sales_tbl2
(dept_no INT, name VARCHAR(20), sales_month INT, sales_amount INT DEFAULT 100);

INSERT INTO sales_tbl2 VALUES
(null, 'George' , 1, 450), (201, 'George' , 2, 250), (201, 'Laura'  , 1, 100), (201, 'Laura'  , 2, 500),
(null, 'George' , 1, 450), (201, 'George' , 2, 250), (201, 'Laura'  , 1, 100), (201, 'Laura'  , 2, 500);

-- selecting rows grouped by dept_no
create table foo as
with cte(a,b) as
(
SELECT dept_no, avg(sales_amount)
FROM sales_tbl
GROUP BY dept_no
) select * from cte;

insert into foo 
with cte as
(
SELECT dept_no, avg(sales_amount)
FROM sales_tbl
GROUP BY dept_no with rollup
)select * from cte;
select * from foo order by 1,2;

with mycte as
(
 SELECT dept_no, avg(sales_amount)
FROM sales_tbl
GROUP BY dept_no with rollup
having dept_no <400 order by 1,2
) delete foo where exists (select * from mycte);

select * from foo order by 1,2;
insert into foo(b) 
with mycte as
(
 SELECT avg(sales_amount)
FROM sales_tbl
GROUP BY dept_no with rollup
having dept_no <400 order by 1
) select * from mycte;

select * from foo order by 1,2;
insert into foo(b)
with mycte as
(
 SELECT count(distinct name) as X
FROM sales_tbl as OUTR
where outr.sales_amount in (select INNR.sales_amount AS Y FROM sales_tbl2 AS INNR WHERE INNR.dept_no IS NULL )
GROUP BY dept_no with rollup
having dept_no <400 order by 1
) select * from mycte;

select * from foo order by 1,2;

with mycte as
(
 SELECT count(distinct name) as X
FROM sales_tbl as OUTR
where outr.sales_amount in (select INNR.sales_amount AS Y FROM sales_tbl2 AS INNR WHERE INNR.dept_no IS NULL )
and outr.dept_no <400 and outr.name <> 'a'
GROUP BY dept_no with rollup
having dept_no <400 order by 1
) update foo set a=-1 where exists( select * from mycte);

select * from foo order by 1,2;

drop if exists foo,sales_tbl,sales_tbl2;
