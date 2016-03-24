-- create vclass for created  table with an auto_increment field,create trigger based on after insert event,insert data ,select data , drop class

create table xoo (id int ); 

create table tbl(id int auto_increment, a char(10), b char(10), c char(10)); 

create trigger inst_tr 
after insert on xoo 
execute insert into tbl (a,b,c) values ('1','2','3'); 

insert into xoo values (1);
insert into xoo values (2);
insert into xoo values (3);
insert into xoo values (4);
insert into xoo values (5);

select * from xoo order by 1;
select * from tbl order by 1; 
create vclass vxoo (
	id int, 
	a char(10), b char(10), c char(10)
) as select * from tbl;

select * from vxoo;

drop vclass vxoo;
drop trigger inst_tr;
drop table tbl,xoo;
