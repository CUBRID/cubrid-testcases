select 1 from db_root where not ! 0=0;
select 1 from db_root where ! not 1=0;
select 1 from db_root where not ! NULL=0;
select 1 from db_root where ! not 2=0;
select 1 from db_root where not ! 'a'=0;
select 1 from db_root where ! not 1234567890123456=0;
select 1 from db_root where !! 0=0;
select 1 from db_root where not not 1=1;
select 1 from db_root where ! not NULL=0;
select 1 from db_root where not ! 2=0;
select 1 from db_root where ! not 'a'=0;
select 1 from db_root where not ! 1234567890123456=0;

select 1 ! 1 from db_root;
select 1 from db_root where 1=1 and not 1<>0;
select 1 from db_root where true and  ! true;
select 1 from db_root where ! true and false;
select 1 from db_root where not false OR true;
select 1 from db_root where not false &&  ! false;
select 1 from db_root where ! 1=1 and 2=2 or 3=3;
select 1 from db_root where not 1=1 XOR 2=2 XOR 3=2;
select 1 from db_root where ! 1 = (select 1 from db_root where true XOR false);
select 1 from db_root where not 1 = (select 1 from db_root where true XOR true) XOR 2=2;
select 1 from db_root where ! 1 = (select 1 from db_root where true XOR true) and 2=2;

create table a1 (id int);
insert into a1 values (1);
insert into a1 values (2);
insert into a1 values (3);
insert into a1 values (4);
insert into a1 values (5);
insert into a1 select id from a1;

insert into a1 select id from a1 where ! id=1 and id =2 or id =3;
insert into a1 select id from a1 where not id=1 OR id >0 and id <3;
select id from a1 order by id;
drop table a1;
