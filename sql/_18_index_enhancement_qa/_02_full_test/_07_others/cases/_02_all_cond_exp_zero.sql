create table tb (a int );
insert into tb values (1);
insert into tb values (2);
insert into tb values (3);
--we expect blank result is returned.
select * from tb where a=all{} order by 1; 

drop table tb;

