-- This test case verifies CBRD-24796 issue.
-- Change the location of the comment clause in the index creation statement.
-- Change the comment clause to be placed at the end.


drop table if exists tbl;


create table tbl(c1 int, c2 int, c3 int, index idx1 (c1) invisible comment 'invisible index');
create index idx2 on tbl(c2) with online  comment 'visible index';
create index idx3 on tbl(c3)  invisible  comment 'visible index';
show index from tbl;

drop index idx2 on tbl;
drop index idx3 on tbl;

-- error case
create index idx2 on tbl(c2) comment 'visible index' with online;
create index idx3 on tbl(c3) comment 'visible index' invisible;
show index from tbl;

drop tbl;

