-- This is a test case for 'left/right outer join', 'cross join', 'natural join'.

drop table if exists tbl;

CREATE OR REPLACE FUNCTION fn_string(i string) RETURN string as language java name 'SpTest7.typeteststring(java.lang.String) return java.lang.String';
create table tbl1( col1 int, col2 varchar(100), col3 varchar(100) );
insert into tbl1 select rownum, to_char(rownum mod 100) col_a, to_char(rownum mod 10) col_b from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b,table({0,1,2,3,4,5,6,7,8,9}) c,table({0,1,2,3,4,5,6,7,8,9}) d,table({0,1,2,3,4,5,6,7,8,9}) e,table({0,1,2,3,4,5,6,7,8,9}) f limit 1000;
create table tbl2( col1 int, col2 varchar(100), col3 varchar(100) );
insert into tbl2 select rownum, to_char(rownum mod 10) col_a, to_char(rownum mod 100) col_b from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b,table({0,1,2,3,4,5,6,7,8,9}) c,table({0,1,2,3,4,5,6,7,8,9}) d limit 100;


-- test outer join
select count(*) from tbl1 right outer join tbl2
on tbl1.col1 = tbl2.col1
and tbl2.col2 = fn_string(1);

select count(*) from tbl1 left outer join tbl2
on tbl1.col1 = tbl2.col1
and tbl1.col2 = fn_string(1);


select count(*) from tbl1 right outer join tbl2
on tbl1.col1 = tbl2.col1
where tbl2.col2 = fn_string(1);

select count(*) from tbl1 left outer join tbl2
on tbl1.col1 = tbl2.col1
where tbl1.col2 = fn_string(1);

-- test cross join
select count(*) from tbl1 cross join tbl2
where tbl1.col2 = fn_string(1);	

select count(*) from tbl1 cross join tbl2
where fn_string(tbl1.col2) = fn_string(1);

-- test natural join
select count(*) from tbl1 natural join tbl2;

select count(*) from tbl1 inner join tbl2
on tbl1.col1 = fn_string(tbl2.col1);


drop function fn_string;
drop table tbl1, tbl2;

