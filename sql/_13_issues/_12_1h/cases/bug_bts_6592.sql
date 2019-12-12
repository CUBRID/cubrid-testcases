(select 1 a) union (select 1 a);
create view v1 as (select 1 a) union (select 1 a);
select * from v1;
drop view v1;


