-- CREATE .. REPLACE
create table tab1 (i1 integer primary key, i2 integer, i3 integer);
create  index idx  on tab1(i2);

create table tab1b replace as select * from tab1;

drop tab1;
drop tab1b;
