drop table if exists c;
drop table if exists d;

create table c (a char(5), b int);
create table d (a char(5), b int);

insert into d values ('one', 1);
insert into d values ('four', 4);
insert into d values ('two', 2);
insert into d values ('three', 3);

select t.a from (select a from c where 0=1 union (select a from d order by b)) t order by t.a;
select t.a from (select a from c where 0=1 union (select a from d order by b desc)) t order by t.a;
select t.a from (select a from c union (select a from d order by b)) t order by t.a;

drop table if exists c;
drop table if exists d;

