-- create vclass for created table with an auto_increment field,create trigger based on after update event,insert data ,update data , ,select data,drop class

create table xoo (id int ); 

create table tbl(id int auto_increment, a char(10), b char(10), c char(10)); 

create trigger inst_tr2
after update on xoo 
execute insert into tbl (a,b,c) values ('1','2','3'); 


insert into xoo values (1);
insert into xoo values (2);
insert into xoo values (3);
insert into xoo values (4);
insert into xoo values (5);


update xoo set id =6 where id =1;
update xoo set id =7 where id =2;
update xoo set id =8 where id =3;
update xoo set id =9 where id =4;
update xoo set id =10 where id =5;

select * from xoo order by 1;
select * from tbl order by 1;
create vclass vxoo (
	id int, 
	 a char(10), b char(10), c char(10)
) as select * from tbl;

select * from vxoo order by 1,2,3;

drop vclass vxoo;
drop trigger inst_tr2;
drop table tbl,xoo;
