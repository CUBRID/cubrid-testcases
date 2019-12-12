create table ddd (d int);
insert into ddd values (0), (0), (1), (1), (2), (2);
select distinct d from ddd limit 2;
drop ddd;
