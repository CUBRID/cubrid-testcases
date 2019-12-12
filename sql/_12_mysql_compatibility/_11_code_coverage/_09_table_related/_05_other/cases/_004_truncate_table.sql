-- TRUNCATE [TABLE| CLASS | <empty>]  id

create table tab1 (i1 integer);
create class c1 (i1 integer);

insert into tab1 values (1),(3),(5);
insert into c1 values (1),(3),(5);

select * from tab1 order by 1;
select * from c1; order by 1;

truncate tab1;
select * from tab1; order by 1;

insert into tab1 values (1),(3),(5);
select * from tab1; order by 1;

truncate table tab1;
select * from tab1; order by 1;

truncate class c1;
select * from c1; order by 1;

-- should fail
truncate class c1_123123;

drop class c1;
drop table tab1;




create table tab1 (i1 integer);

create index idx on tab1(i1);
insert into tab1 values (1),(3),(5);

select * from tab1 order by i1; order by 1;


truncate tab1;
select * from tab1; order by 1;

drop table tab1;
