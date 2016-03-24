-- primary key on index   
-- 
create table t1 (i1 integer,i2 integer);

alter table t1 add constraint primary key pk_i1 (i1 desc);
alter table t1 drop primary key;

alter table t1 add constraint primary key pk_i1 (i1 asc);
alter table t1 drop primary key;


alter table t1 modify i1 int default 1, modify i2 int default 2;

alter table t1 add column i3 integer after i1;

drop table t1;


create table tbl_1;

alter table tbl_1 rename tbl_2, add column i int, rename tbl_3;

insert into tbl_3 values (1);

select * from tbl_3;

drop table tbl_1;
drop table tbl_2;
drop table tbl_3;

create table tbl_1 (id int);

insert into tbl_1 values (1);

alter table tbl_1 add column id_2 int, drop column ii;

select * from tbl_1;

drop table tbl_1;
