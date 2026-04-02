-- create vclass for created class with decimal or numeric data type auto_increment field,insert data to this class,select data from this class,drop class


create class xoo_decimal ( id decimal(10,0) auto_increment,
                   title varchar(100));

insert into xoo_decimal(title) values ('aaa');
insert into xoo_decimal(title) values ('bbb');
insert into xoo_decimal(title) values ('ccc');

select * from xoo_decimal order by 1;
create vclass vxoo (
	id decimal(10,0),
	title varchar(100)
) as select * from xoo_decimal;

select * from vxoo order by 1;

drop vclass vxoo;
drop class xoo_decimal;


create class xoo_numeric ( id numeric(10,0) auto_increment,
                   title varchar(100));

insert into xoo_numeric(title) values ('aaa');
insert into xoo_numeric(title) values ('bbb');
insert into xoo_numeric(title) values ('ccc');

select * from xoo_numeric order by 1;
create vclass vxoo (
	id numeric(10,0),
	title varchar(100)
) as select * from xoo_numeric;

select * from vxoo order by 1;

drop vclass vxoo;
drop class xoo_numeric;