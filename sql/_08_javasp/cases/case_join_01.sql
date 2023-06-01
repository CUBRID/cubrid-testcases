-- This is a test case for 'left/right outer join', 'cross join', 'natural join'.

drop table if exists tbl_a;
drop table if exists tbl_b;

CREATE OR REPLACE FUNCTION fn_string(i string) RETURN string as language java name 'SpTest7.typeteststring(java.lang.String) return java.lang.String';
create table tbl_a( x int, y varchar(100), z varchar(100) );
insert into tbl_a select rownum, to_char(rownum mod 100) col_a, to_char(rownum mod 10) col_b from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b,table({0,1,2,3,4,5,6,7,8,9}) c,table({0,1,2,3,4,5,6,7,8,9}) d,table({0,1,2,3,4,5,6,7,8,9}) e,table({0,1,2,3,4,5,6,7,8,9}) f limit 1000;
create table tbl_b( x int, y varchar(100), z varchar(100) );
insert into tbl_b select rownum, to_char(rownum mod 10) col_a, to_char(rownum mod 100) col_b from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b,table({0,1,2,3,4,5,6,7,8,9}) c,table({0,1,2,3,4,5,6,7,8,9}) d limit 100;


-- test outer join
select count(*) from tbl_a right outer join tbl_b
on tbl_a.x = tbl_b.x
and fn_string(tbl_b.y) = '1';

select count(*) from tbl_a left outer join tbl_b
on tbl_a.x = tbl_b.x
and fn_string(tbl_a.y) = '1';


select count(*) from tbl_a right outer join tbl_b
on tbl_a.x = tbl_b.x
where fn_string(tbl_b.y) = '1';

select count(*) from tbl_a left outer join tbl_b
on tbl_a.x = tbl_b.x
where fn_string(tbl_a.y) = '1';

select count(*) from tbl_a, tbl_b
where tbl_a.x(+) = tbl_b.x
and fn_string(tbl_b.y) = '1';

select count(*) from tbl_a, tbl_b
where tbl_a.x = tbl_b.x(+)
and fn_string(tbl_a.y) = '1';

-- test cross join
select count(*) from tbl_a cross join tbl_b
where fn_string(tbl_a.y) = '1';	

select count(*) from tbl_a cross join tbl_b
where fn_string(tbl_a.y) = '1';

-- test natural join
select count(*) from tbl_a natural join tbl_b
where fn_string(tbl_a.y)='10';

select count(*) from tbl_a inner join tbl_b
on tbl_a.x = fn_string(tbl_b.x);


drop function fn_string;
drop table tbl_a, tbl_b;

