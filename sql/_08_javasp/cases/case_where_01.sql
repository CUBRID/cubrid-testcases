-- This is a test case for 'BETWEEN', 'EXISTS'.

drop table if exists tbl;

CREATE OR REPLACE FUNCTION fn_string(i string) RETURN string as language java name 'SpTest7.typeteststring(java.lang.String) return java.lang.String';
CREATE OR REPLACE FUNCTION fn_int(i int) RETURN int as language java name 'SpTest7.typetestint(int) return int';
create table tbl( a int, b varchar(100), c varchar(100) );
insert into tbl select rownum, to_char(rownum mod 100) col_a, to_char(rownum mod 10) col_b from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b,table({0,1,2,3,4,5,6,7,8,9}) c,table({0,1,2,3,4,5,6,7,8,9}) d,table({0,1,2,3,4,5,6,7,8,9}) e,table({0,1,2,3,4,5,6,7,8,9}) f limit 1000;

create index idx1_tbl on tbl(a);
create index idx2_tbl on tbl(b);
update statistics on tbl;

-- test between
select * from tbl where fn_string(a) between 1 and 10;
--@queryplan
select * from tbl where a between fn_int(1) and 10;
--@queryplan
select * from tbl where a between 1 and fn_int(10);
--@queryplan
select * from tbl where a between fn_int(1) and fn_int(10);
select * from tbl where fn_string(a) between fn_int(1) and fn_int(10);

-- test exists : return true/false
select /*+ recompile */ count(*) from tbl where exists (select * from tbl where fn_string(a)=1);
select /*+ recompile */ count(*) from tbl where exists (select * from tbl where fn_string(a)=0);
select /*+ recompile */ count(*) from tbl where not exists (select * from tbl where fn_string(a)=1);
select /*+ recompile */ count(*) from tbl where not exists (select * from tbl where fn_string(a)=0);

prepare st from 'select * from tbl where fn_string(a) between ? and ?';
execute st using  1, 10;
drop prepare st;
prepare st from 'select * from tbl where a between fn_int(?) and ?';
execute st using 1, 10;
drop prepare st;
prepare st from 'select * from tbl where a between ? and fn_int(?)';
execute st using 1, 10;
drop prepare st;
prepare st from 'select * from tbl where a between fn_int(?) and fn_int(?)';
execute st using 1, 10;
drop prepare st;
-- error : Cannot coerce value of domain "character varying" to domain "double".
prepare st from 'select * from tbl where fn_string(a) between fn_int(?) and fn_int(?)';
execute st using 1, 10;
drop prepare st;

prepare st from 'select /*+ recompile */ count(*) from tbl where exists (select * from tbl where fn_string(a)=?)';
execute st using 1;
drop prepare st;
prepare st from 'select /*+ recompile */ count(*) from tbl where exists (select * from tbl where fn_string(a)=?)';
execute st using 0;
drop prepare st;
prepare st from 'select /*+ recompile */ count(*) from tbl where not exists (select * from tbl where fn_string(a)=?)';
execute st using 1;
drop prepare st;
prepare st from 'select /*+ recompile */ count(*) from tbl where not exists (select * from tbl where fn_string(a)=?)';
execute st using 0;
drop prepare st;


drop function fn_string;
drop function fn_int;
drop table tbl;
