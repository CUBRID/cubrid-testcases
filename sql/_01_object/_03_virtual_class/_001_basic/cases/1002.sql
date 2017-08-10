-- create class,create view using select,insert data into vclass,retrieve vclass,drop class and vclass

create class min1 (a int,b char(10));
create vclass vdml_0001 (a,b,c) as select a,b,'aaaa' from min1;
create vclass vdml_0002 (a,b,c varchar(4)) as select a,b,'aaaa' from min1;
create vclass vdml_0003 (a,b,c char(15)) as select a,b,'aaaa' from min1;

insert into min1 values(1,'11111');
insert into min1 values(2,'22222');
insert into min1 values(3,'33333');

select * from vdml_0001;
select * from vdml_0002;
select * from vdml_0003;



drop class min1;
drop view  vdml_0001;
drop view  vdml_0002;
drop view  vdml_0003;