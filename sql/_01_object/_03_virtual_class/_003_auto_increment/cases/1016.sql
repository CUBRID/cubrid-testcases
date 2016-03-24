--[er] create vclass for created  table with an int auto_increment field,insert data to this table by no specifying the field.

create table xoo (id int auto_increment,
                        title varchar(100));

insert into xoo values('aaa');
create vclass vxoo (
	id int, 
	title varchar(100)
) as select * from xoo;

select * from vxoo;

drop vclass vxoo;
drop class xoo;
