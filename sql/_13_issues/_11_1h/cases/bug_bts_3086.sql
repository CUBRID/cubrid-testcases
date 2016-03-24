create view v2 as select 'a' as x;
select * from v2;
drop view v2;

create or replace view va (a) as select 'a';
select * from va; 
drop view va;

create or replace view va (a) as select 'a' from db_root;
select * from va;
drop view va;


