

drop table if exists tbl;
drop table if exists tbl_son;

create table tbl;

/* err */ alter table tbl add column c1 int invisible;
alter table tbl add column c1 int;
/* err */ alter table tbl modify column c1 int invisible;
/* err */ alter table tbl change column c1 c1 int invisible;
alter table tbl add column c2 int invisible;
desc tbl;
/* err */ alter table tbl drop column c1;

drop tbl;


/* err */ create table tbl (c1 int invisible);
/* err */ create table tbl (c1 int invisible, c2 int invisible);


-- partitioning

create table tbl (c1 int invisible , c2 int) partition by hash(c1) partitions 2;
/* err */ alter table tbl drop column c1;

desc tbl;

-- inheritance

drop tbl;
create table tbl (c1 int, c2 int);
/* err */ create table tbl_son under tbl(c3 int invisible);
create table tbl_son under tbl;

desc tbl;
desc tbl_son;

/* err */ alter table tbl_son add column c3 int invisible;
alter table tbl modify column c1 int invisible;
/* err */ alter table tbl modify column c2 int invisible;
alter table tbl_son add column c3 int visible;
/* err */ alter table tbl_son modify column c3 int invisible;
alter table tbl_son drop superclass tbl;

desc tbl;
desc tbl_son;

drop tbl_son;
drop tbl;
