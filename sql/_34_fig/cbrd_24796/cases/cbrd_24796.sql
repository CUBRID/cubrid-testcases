-- This test case verifies CBRD-24796 issue.
-- Change the location of the comment clause in the index creation statement.
-- Change the comment clause to be placed at the end.


drop table if exists tbl;

-- success case
create table tbl(c1 int, c2 int, c3 int, index idx1 (c1) invisible comment 'invisible index');
create index idx2 on tbl(c2) with online  comment 'with online index';
create index idx3 on tbl(c3) invisible comment 'invisible index';
create index idx4 on tbl(c2, c3) with online parallel 4 comment 'with online parallel 4 index';
show index from tbl;

drop index idx1 on tbl;
drop index idx2 on tbl;
drop index idx3 on tbl;
drop index idx4 on tbl;

alter table tbl add index idx1(c1) invisible comment 'alter add invisible index';

-- error case
alter table tbl add index idx2(c2) with online comment 'alter add with online index';
alter table tbl add index idx3(c2,c3) with online parallel 4 comment 'alter add with online parallel 4 index';

show index from tbl;
drop tbl;

-- error case
create table tbl(c1 int, c2 int, c3 int, index idx1 (c1) comment 'invisible index' invisible);

-- success case
create table tbl(c1 int, c2 int, c3 int);

-- error case
create index idx2 on tbl(c2) comment 'visible index' with online;
create index idx3 on tbl(c3) comment 'invisible index' invisible;
create index idx4 on tbl(c2, c3) comment 'with online and invisible index' with online PARALLEL 4 invisible;

alter table tbl add index idx1(c1) comment 'alter add invisible index' invisible;
alter table tbl add index idx2(c2) comment 'alter add with online index' with online;
alter table tbl add index idx3(c2,c3) comment 'alter add with online parallel 4 index' with online parallel 4;

show index from tbl;
drop tbl;


