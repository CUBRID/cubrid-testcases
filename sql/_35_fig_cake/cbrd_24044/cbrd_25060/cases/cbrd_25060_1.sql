drop table if exists tbl;

create table tbl (col_a varchar(20), col_b varchar(20), col_c varchar(20), col_d varchar(20), col_e numeric(20,10), col_f varchar(20), col_g varchar(20), col_h varchar(20), col_i varchar(20), col_j varchar(20) );

insert into tbl select rownum, 1, mod(rownum,2), mod(rownum,3), mod(rownum,4), mod(rownum,5), mod(rownum,6), mod(rownum,7), mod(rownum,8), mod(rownum,9) from db_class a, db_class b, db_class c, db_class d, db_class f, db_class g limit 10000;

alter table tbl add constraint primary key (col_a);

set optimization level 513;

update statistics on tbl;
 
 
-- column with poor distribution (create index on every data is same)
create index idx_b on tbl(col_b); 
update statistics on tbl;

-- use pk
select /*+ recompile */ count(*) from tbl where col_a > 9990 and col_b = '1';
select /*+ recompile */ count(*) from tbl where col_b = 1  order by col_a ;
select /*+ recompile */ count(*) from tbl where col_a > 100  order by col_b;
select /*+ recompile */ count(*) from tbl where col_b = 1  order by col_a limit 1000;
select /*+ recompile */ count(*) from tbl where col_a > 100  order by col_b limit 1000;
select /*+ recompile */ count(*) from tbl where col_b = 1  order by col_a limit 10;
select /*+ recompile */ count(*) from tbl where col_a > 100  order by col_b limit 10;
 
 
-- column with poor distribution (create index on only contains 0,1)
create index idx_c on tbl(col_c); 
update statistics on tbl;
 
-- use pk
select /*+ recompile */ count(*) from tbl where col_a > 9990 and col_c = '1';
select /*+ recompile */ count(*) from tbl where col_c = 1  order by col_a ;
select /*+ recompile */ count(*) from tbl where col_a > 100  order by col_c ;
select /*+ recompile */ count(*) from tbl where col_c = 1  order by col_a limit 1000;
select /*+ recompile */ count(*) from tbl where col_a > 100  order by col_c limit 1000;
select /*+ recompile */ count(*) from tbl where col_c = 1  order by col_a limit 10;
select /*+ recompile */ count(*) from tbl where col_a > 100  order by col_c limit 10;
 
 
-- column with poor distribution (create index on only contains 0,1,2)
create index idx_d on tbl(col_d); 
update statistics on tbl;

-- use pk
select /*+ recompile */ count(*) from tbl where col_a > 9990 and col_d = '1';
select /*+ recompile */ count(*) from tbl where col_d = 1  order by col_a ;
select /*+ recompile */ count(*) from tbl where col_a > 100  order by col_d ;
select /*+ recompile */ count(*) from tbl where col_d = 1  order by col_a limit 1000;
select /*+ recompile */ count(*) from tbl where col_a > 100  order by col_d limit 1000;
select /*+ recompile */ count(*) from tbl where col_d = 1  order by col_a limit 10;
select /*+ recompile */ count(*) from tbl where col_a > 100  order by col_d limit 10;
 
 
-- column with poor distribution (create index on only contains 0,1,2,3)
create index idx_e on tbl(col_e); 
update statistics on tbl;
 
-- use pk
select /*+ recompile */ count(*) from tbl where col_a > 9990 and col_e = '1';
select /*+ recompile */ count(*) from tbl where col_e = 1  order by col_a ;
-- use idx
select /*+ recompile */ count(*) from tbl where col_a > 100  order by col_e ;
select /*+ recompile */ count(*) from tbl where col_e = 1  order by col_a limit 1000;
-- use pk
select /*+ recompile */ count(*) from tbl where col_a > 100  order by col_e limit 1000;
-- use idx
select /*+ recompile */ count(*) from tbl where col_e = 1  order by col_a limit 10;
-- use pk
select /*+ recompile */ count(*) from tbl where col_a > 100  order by col_e limit 10;

 
drop table tbl;
