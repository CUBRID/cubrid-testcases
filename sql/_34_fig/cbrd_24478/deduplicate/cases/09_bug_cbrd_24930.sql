-- reproduce bug chk for CBRD-24930
drop table if exists tbl;
create table tbl(id int, uid int);
create unique index ix_uid on tbl(uid) with deduplicate=3; -- Should be error
drop table if exists tbl;
