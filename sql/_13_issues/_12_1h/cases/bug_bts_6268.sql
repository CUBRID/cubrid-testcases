create table tbl (a int,b varchar(30));

select '' as group_key from tbl group by group_key;
select 1 ,2 as b from tbl group by b;
select a , 2 as a from tbl group by 1,2;

select a,b,'' as c from tbl group by 1,2,3;

select 'a' as x,a,b, '' as c from tbl group by 1,2,3;

select 'a' as x, '' as c ,a,'cc' as y  from tbl group by 2;
select 'a' as x, '' as c ,a,'cc' as y  from tbl group by 3;
select 'a' as x, '' as c ,a,'cc' as y  from tbl group by 5;
drop table tbl;