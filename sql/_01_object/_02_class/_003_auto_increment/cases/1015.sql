-- create table,create table with an auto_increment field,create trigger based on after delete event,insert data , delete data,select data , drop class

create table xoo (id int ); 

create table tbl(id int auto_increment, a char(10), b char(10), c char(10)); 

create trigger inst_tr2 
after delete on xoo 
execute insert into tbl (a,b,c) values ('1','2','3'); 


insert into xoo values (1);
insert into xoo values (2);
insert into xoo values (3);
insert into xoo values (4);
insert into xoo values (5);


delete from xoo where id =1;
delete from xoo where id =2;
delete from xoo where id =3;
delete from xoo where id =4;


select * from xoo order by 1;
select * from tbl order by 1;

drop trigger inst_tr2;
drop table tbl,xoo;
