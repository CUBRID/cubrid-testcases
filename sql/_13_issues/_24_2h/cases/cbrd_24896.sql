-- This testcase verifies CBRD-24896 issue.

-- create table
drop table if exists tbl;
create table tbl (col_a int, col_b int, col_c int, col_d int);
insert into tbl values(1,1,1,1),(2,2,2,2),(3,3,3,3);
create index idx on tbl(col_a,col_b,col_c);
update statistics on tbl;

EVALUATE 'index scan case';
select /*+ recompile */ * from tbl where (col_a,col_b) in ((1,1),(2,2));
select /*+ recompile */ * from tbl where (col_a,col_c) in ((1,1),(2,2));
select /*+ recompile */ * from tbl where (col_a,col_d) in ((1,1),(2,2));

EVALUATE 'sscan case';
select /*+ recompile */ * from tbl where {col_a,col_b} in ((1,1),(2,2));
select /*+ recompile */ * from tbl where {col_a} = {2};
select /*+ recompile */ * from tbl where {col_a} = {};

drop table tbl;
