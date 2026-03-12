
drop table if exists tbl;
drop table if exists tbl_son;
drop view if exists tbl_all_v;
drop view if exists tbl_v;



-- at least one visible column

create table tbl;

evaluate 'err';
/* err */ alter table tbl add column c1 int invisible;
alter table tbl add column c1 int;
evaluate 'err';
/* err */ alter table tbl modify column c1 int invisible;
evaluate 'err';
/* err */ alter table tbl change column c1 c1 int invisible;
alter table tbl add column c2 int invisible;
desc tbl;
evaluate 'err';
/* err */ alter table tbl drop column c1;

drop tbl;


evaluate 'error';
/*error */create table tbl (c1 int invisible);
evaluate 'err';
/* err*/create table tbl (c1 int invisible, c2 int invisible);


-- partitioning

create table tbl (c1 int invisible , c2 int) partition by hash(c1) partitions 2;
evaluate 'err';
/* err*/alter table tbl drop column c1;


-- inheritance

drop tbl;
create table tbl (c1 int, c2 int);
evaluate 'err';
/* err*/create table tbl_son under tbl(c3 int invisible);
create table tbl_son under tbl;
evaluate 'err';
/* err */alter table tbl_son add column c3 int invisible;
alter table tbl modify column c1 int invisible;
evaluate 'err';
/* err */alter table tbl modify column c2 int invisible;
alter table tbl_son add column c3 int visible;
evaluate 'err';
/* err */alter table tbl_son modify column c3 int invisible;
alter table tbl_son drop superclass tbl;
drop tbl_son;
drop tbl;


-- dml, ddl
evaluate 'err ( at least one visible col )';
/* err ( at least one visible col ) */ create table tbl(c1 int invisible, c2 int invisible); 
 
create table tbl(c1 int auto_increment invisible primary key, c2 int visible not null, c3 int invisible default 3, c4 int , c5 varchar(32))
        partition by hash (c1) partitions 2;


show create table tbl;

desc tbl;

select * from db_attribute where class_name = 'tbl' order by attr_name;

select * from _db_attribute where class_of.class_name = 'tbl' order by attr_name;

create index tbl_c1_c2_idx on tbl (c1,c2);

evaluate 'err (c1,c2,c3 invisible. need c4,c5 value)';
/* err (c1,c2,c3 invisible. need c4,c5 value) */ insert into tbl values (1,2,3,4,'5'); 
        
insert into tbl values (2, 4,'5');

alter table tbl change c2 c2 int invisible;
evaluate 'err (c2 not null constraint)';
/* err (c2 not null constraint) */ insert into tbl() values (4,'5'); 
        
insert into tbl(c2,c4,c5) values (2,4,'5');
insert into tbl(c2,c5) values (12,'15');
insert into tbl(c2,c5) values (22,'25'),(32,'35');

update statistics on tbl;

set trace on;

evaluate 'only c4 c5';
/* only c4 c5 */ select * from tbl order by c5;
show trace;
select /*+recompile*/ c1,c2,c3,c4,c5 from tbl order by c1;
show trace;
select /*+recompile*/ * from tbl order by c1;
show trace;
select /*+recompile*/ c1, c2 from tbl order by 1;
show trace;
select /*+recompile*/ c1 from tbl order by 1;
show trace;
select /*+recompile*/ * from tbl where c1 = 1 order by 1;
show trace;
select /*+ recompile */ c1,c2 from tbl where c1 is not null order by 1;
show trace;

set trace off;

alter table tbl modify column c5 varchar(32) invisible;
evaluate 'err (at least one visible)';
/*  err (at least one visible)*/ alter table tbl change column c4 int invisible; 

alter table tbl add column updated_date datetime invisible on update current_timestamp;

desc tbl;
select * from tbl order by c4;

update tbl set c2 = 0 where c1 = 1;

select c1, c2, c3, c4, c5, if(current_datetime -updated_date >=0 and current_datetime -updated_date <10000,'ok','nok') from tbl order by c1;

delete from tbl where c2 = 0;

select c1, c2, c3, c4, c5, if(current_datetime -updated_date >=0 and current_datetime -updated_date <10000,'ok','nok') from tbl order by c1;



-- partition
evaluate 'partition';
select * from tbl__p__p0 order by c1;
select * from tbl__p__p1 order by c1;
select c1,c2,c3,c4,c5,updated_date from tbl__p__p0 order by c1;
select c1,c2,c3,c4,c5,updated_date from tbl__p__p1 order by c1;
desc tbl__p__p0;
desc tbl__p__p1;
show create table tbl__p__p0;




evaluate 'still invisible';
/* still invisible */ alter table tbl modify column c5 varchar(32); 
desc tbl;
alter table tbl change column c5 c5 varchar(32) visible;
alter table tbl drop column updated_date;


desc tbl;
show create table tbl;
desc tbl__p__p0;
show create table tbl__p__p0;
desc tbl__p__p1;
show create table tbl__p__p1;


-- view
create view tbl_v as select * from tbl;

evaluate 'err (no c1)';
/* err (no c1) */ select * from tbl_v order by c1;
select * from tbl_v order by c4;

show create view tbl_v;

create view tbl_all_v as select c1,c2,c3,c4,c5 from tbl;

select * from tbl_all_v order by c1;

alter table tbl remove partitioning;
alter table tbl modify column c1 int visible;
alter table tbl modify column c4 int invisible;
evaluate 'err (no c1)';
/* err (no c1) */ select * from tbl_v order by c1;
select * from tbl_all_v order by c1;


alter view tbl_v add query select * from tbl;
show create view tbl_v;
evaluate 'tbl_v column number was 2, and new query still get 2 columns. so it work';
/* tbl_v column number was 2, and new query still get 2 columns. so it work */ select * from tbl_v order by 1;    


alter view tbl_v as select * from tbl;
show create view tbl_v;
select * from tbl_v order by c1;

drop view if exists tbl_v;

desc tbl;

-- trigger
create trigger tbl_c4_trigger before insert on tbl if new.c4 is null execute reject;
select trigger_name, target_attr_name, target_attr_type from db_trigger order by 1;

insert into tbl(c1,c2,c5) values (default,99,'c4 is null. reject');
insert into tbl(c2,c4,c5) values (22, 24, '25');

update statistics on tbl;

set trace on;

select /*+recompile*/ * from tbl where c1 = 2 order by 1;
show trace;
select /*+ recompile */ c1,c2 from tbl where c1 is not null order by 1;
show trace;

set trace off;

select * from tbl_all_v order by 1;

desc tbl;
alter table tbl modify column c4 int visible;
desc tbl;


-- inheritance
create table tbl_son under tbl;
desc tbl;

alter table tbl_son drop superclass tbl;
desc tbl_son;
drop table tbl_son;

 evaluate 'same name column. parent''s c2 was invisible not null';
 /* same name column. parent's c2 was invisible not null */ create table tbl_son under tbl(c2 int, c6 int); 
desc tbl_son;

alter table tbl_son drop column c2;


-- inheritance - parent visibility changing / should we block?
evaluate 'inheritance - parent visibility changing / should we block?';
alter table tbl modify column c1 int auto_increment invisible;

desc tbl;
desc tbl_son;

drop table if exists tbl;
drop table if exists tbl_son;
drop view if exists tbl_v;
drop view if exists tbl_all_v;
