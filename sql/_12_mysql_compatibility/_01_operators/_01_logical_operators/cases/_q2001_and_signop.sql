select 1 && 1 from db_root;
select 1 from db_root where 1<>0 && 1<>0;
select 1 from db_root where true && true;
select 1 from db_root where true && false;
select 1 from db_root where false && true;
select 1 from db_root where false && false;
select 1 from db_root where 1<>0 && true;
select 1 from db_root where 1=1 && 2=2 && 3=3;
select 1 from db_root where 1=1 && 2=2 && 3=2;
select 1 from db_root where 1 = (select 1 from db_root where true && false);
select 1 from db_root where 1 = (select 1 from db_root where true && true) && 2=2;
select 1 from db_root where 1 = (select 1 from db_root where true && true) and 2=2;

create table a1 (id int);
insert into a1 values (1);
insert into a1 values (2);
insert into a1 values (3);
insert into a1 values (4);
insert into a1 values (5);
insert into a1 select id from a1;

insert into a1 select id from a1 where id=1 && id =2 && id =3;
insert into a1 select id from a1 where id=1 && id >0 && id <3;
select id from a1 order by id asc;
drop table a1;
