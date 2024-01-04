-- This scenario varifies CBRD-25060 issue.
-- The problem of not selecting a better index which is superset of primary key.

drop table if exists tbl;
create table tbl (col_a varchar(20), col_b varchar(20), col_c varchar(20), col_d varchar(20), col_e numeric(20,10), col_f varchar(20), col_g varchar(20), col_h varchar(20));
insert into tbl select rownum, 1, mod(rownum,10), lpad(to_char(mod(rownum,100)),20,'0'), mod(rownum,1000), lpad(to_char(mod(rownum,10000)),20,'0'), lpad(to_char(mod(rownum,100000)),20,'0'), lpad(to_char(mod(rownum,100000)),20,'0') from db_class a, db_class b, db_class c, db_class d, db_class f, db_class g limit 10000;

alter table tbl add constraint primary key (col_a);
create index idx_a_e on tbl(col_a,col_e); 
create index idx_e on tbl(col_e); 

update statistics on tbl;

--single table with pk
select /*+ recompile */ count(*) from tbl where col_a = 1 and col_e = 1;

--join with pk
select /*+ recompile ordered */ count(*) from tbl a, tbl b where a.col_a = b.col_a and a.col_e = b.col_e; 

--drop pk
alter table tbl drop primary key;
create index idx3 on tbl(col_a);
update statistics on tbl;

--single
select /*+ recompile */ count(*) from tbl where col_a = 1 and col_e = 1;

--join
select /*+ recompile ordered */ count(*) from tbl a, tbl b where a.col_a = b.col_a and a.col_e = b.col_e;

 
drop table tbl;
