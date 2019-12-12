drop table if exists b;

create table b (a int);
insert into b values (0), (1), (2);
select * from b where a > 1 or a between 1 and 0;

drop table if exists b;
