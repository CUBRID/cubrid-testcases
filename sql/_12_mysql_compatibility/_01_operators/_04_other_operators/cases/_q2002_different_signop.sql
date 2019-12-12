select 1 from db_root where 9223372036854775807 != 9223372036854775807;
select 1 from db_root where -9223372036854775807 <!= -9223372036854775807;

select 1 from db_root where not 0!=0;
select 1 from db_root where not 1!=0;
select 1 from db_root where not NULL!=0;
select 1 from db_root where not 2!=0;
select 1 from db_root where not 'a'!=0;
select 1 from db_root where not 1234567890123456!=0;
select 1 from db_root where ! 0!=0;
select 1 from db_root where ! 1!=0;
select 1 from db_root where ! NULL!=0;
select 1 from db_root where ! 2!=0;
select 1 from db_root where ! 'a'!=0;
select 1 from db_root where ! 1234567890123456!=0;

create table a1 (id int,name varchar(10));
insert into a1 values (1,'null');
insert into a1 values (2,'NULL');
insert into a1 values (3,'');
insert into a1 values (4,' ');
insert into a1 values (5,NULL);
insert into a1 values (6,null);
select * from a1 order by id;
select * from a1 where name = null order by id;
select * from a1 where name != null order by id;
select * from a1 where name  != 'null' order by id;
drop a1;