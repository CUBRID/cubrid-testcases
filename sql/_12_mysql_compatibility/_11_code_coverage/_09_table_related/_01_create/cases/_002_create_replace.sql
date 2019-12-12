-- CREATE .. REPLACE
create table tab1 (i integer);

create table tab1b replace as select * from tab1;

drop tab1;
drop tab1b;