--+ holdcas on;
--1. PK should be selected if both scanning PK and scanning a non-PK index have the same cost.
set  system parameters 'dont_reuse_heap_file=yes';
create table y (a int, b int, c int);
create index i_y on y (a, c);
alter table y add primary key (a, b);
select /*+ recompile */ * from y where a > 0;
drop table y;

create table y (a int, b int, c int);
create unique index i_y on y (a, c);
alter table y add primary key (a, b);
select /*+ recompile */ * from y where a > 0;
drop table y;

--2. A reverse unique index should be selected if there is no PK and both scanning a reverse unique index and a non-unique index have the same cost.
create table y (a int, b int, c int);
create index i_y_non_uk on y (a, b);
create reverse unique index i_y_uk on y (a, c);
select /*+ recompile */ * from y where a > 0;
drop table y;

--3. PK should be selected even if a non-PK index can be traversed with a key filter term, because the query planner does not consider a key filter when making a plan, now.This issue might be resolved by CUBRIDSUS-4125.

create table x (a int, b int, c int, d int);
create index i_x on x (a, b, d);
alter table x add primary key (a, b, c);
---- We select PK even if there is a condition which can be used as a key filter during a non-PK index scan.
select /*+ recompile */ * from x where a > 0 and d > 0;
drop table x;


--4. In the following example, PK should not be selected, because the planning costs are not same due to the size of multi-column index.
create table z (a int, b int, c char(256), d int);
create index i_z on z (a, b, d);
alter table z add primary key (a, b, c);
insert into z values(1,1,'1',1);
insert into z values(2,2,'2',2);
insert into z values(3,3,'3',3);
insert into z values(4,4,'4',4);
insert into z values(5,5,'5',5);
insert into z values(6,6,'6',6);
insert into z values(7,7,'7',7);
insert into z values(8,8,'8',8);
insert into z values(9,9,'9',9);
insert into z values(10,10,'10',10);
insert into z values(11,11,'11',11);
insert into z values(12,12,'12',12);
insert into z values(13,13,'13',13);
insert into z values(14,14,'14',14);
update statistics on z;
select /*+ recompile */ * from z where a = 5 and b = 5;
drop table z;

----However, PK should be selected in the following example.
create table z (a int, b int, c int, d int);
create index i_z on z (a, b, d);
alter table z add primary key (a, b, c);
insert into z values(1,1,1,1);
insert into z values(2,2,2,2);
insert into z values(3,3,3,3);
insert into z values(4,4,4,4);
insert into z values(5,5,5,5);
insert into z values(6,6,6,6);
insert into z values(7,7,7,7);
insert into z values(8,8,8,8);
insert into z values(9,9,9,9);
insert into z values(10,10,10,10);
insert into z values(11,11,11,11);
insert into z values(12,12,12,12);
insert into z values(13,13,13,13);
insert into z values(14,14,14,14);
update statistics on z;
select /*+ recompile */ * from z where a = 5 and b = 5;
drop table z;
set  system parameters 'dont_reuse_heap_file=no';commit;
--+ holdcas off;
