-- This is a test case for 'IN', 'IS NULL', 'LIKE' on where clause.

drop table if exists tbl;

CREATE OR REPLACE FUNCTION fn_string(i string) RETURN string as language java name 'SpTest.testString(java.lang.String) return java.lang.String';
CREATE OR REPLACE FUNCTION fn_int(i int) RETURN int as language java name 'SpTest7.typetestint(int) return int';
create table tbl( a int, b varchar(100), c varchar(100) );
insert into tbl select rownum, to_char(rownum mod 100) col_a, to_char(rownum mod 10) col_b from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b,table({0,1,2,3,4,5,6,7,8,9}) c,table({0,1,2,3,4,5,6,7,8,9}) d,table({0,1,2,3,4,5,6,7,8,9}) e,table({0,1,2,3,4,5,6,7,8,9}) f limit 1000;
insert into tbl values (NULL, 'end', 'end' );

create index idx1_tbl on tbl(a);
create index idx2_tbl on tbl(b);
update statistics on tbl;

-- test in
--@queryplan
select count(*) from tbl  where fn_string(a) in ( 1 );
--@queryplan
select count(*) from tbl  where fn_string(a) in ( 1, 2 );

-- test is null, is not null
select count(*) from tbl  where fn_string(a) is null;
select count(*) from tbl  where fn_string(b) is null;
select count(*) from tbl  where fn_string(a) is not null;
select count(*) from tbl  where fn_string(b) is not null;

-- test like
--@queryplan
select count(*) from tbl  where fn_string(b) like  fn_int(2)||'%';
select count(*) from tbl  where fn_string(b) like  '%'||fn_int(2)||'%';
select count(*) from tbl  where fn_string(b) like  '%'||fn_int(2);


prepare st from 'select count(*) from tbl  where fn_string(a) in ( ? )';
execute st using 1;
drop prepare st;
prepare st from 'select count(*) from tbl  where fn_string(a) in ( ?, ? )';
execute st using 1, 2;
drop prepare st;

prepare st from 'select count(*) from tbl  where fn_string(a) is null';
execute st;
drop prepare st;
prepare st from 'select count(*) from tbl  where fn_string(b) is null';
execute st;
drop prepare st;
prepare st from 'select count(*) from tbl  where fn_string(a) is not null';
execute st;
drop prepare st;
prepare st from 'select count(*) from tbl  where fn_string(b) is not null';
execute st;
drop prepare st;


drop function fn_string;
drop function fn_int;
drop table tbl;

