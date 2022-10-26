--test cases (Except for correlated subquery cases, all other query plans are correct)
-- create table

drop table if exists tbl;
create table tbl(cola int, colb int);
insert into tbl values(1,1),(2,2);
create index idx on tbl(cola);

-- create function
create or replace FUNCTION Hello(p_code varchar) RETURN VARCHAR
 as language java name 'SpTest.Hello(java.lang.String)  return java.lang.String';

get optimization level into :opt_level ;
set optimization level 514;

--general case
SELECT 1
FROM tbl
WHERE cola = Hello(1984);

--sscan 
SELECT 1
FROM tbl
WHERE cola = Hello(colb);

--correlated subquery case (fixme : must be index scan)
select (SELECT /*+ oredered */ 1 FROM tbl a WHERE a.cola = Hello(b.cola)) cola
 from tbl b;

--order by skip
SELECT /*+ recompile ordered */ Hello(b.colb)
FROM tbl a, tbl b
where a.cola > 0
   and a.colb = b.colb
order by a.cola
limit 1 ;

-- restore optimization level
set optimization level :opt_level ;

drop function Hello;
drop table if exists tbl;
