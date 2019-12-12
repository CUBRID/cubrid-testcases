create table a (x int);

create table b as select x from a;
insert into b ( x ) values (1);

create table c as select a.x from a;
insert into c ( x ) values (1);

create table d as select x as y from a;
insert into d ( y ) values (1);

create table e as select t.x from a t;
insert into e ( x ) values (1);

drop table a;
drop table b;
drop table c;
drop table d;
drop table e;
