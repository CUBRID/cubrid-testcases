-- create vclass for created  class with three different data type auto_increment field,the types are int ,decimal,numeric.insert data,select data,update these three different data type auto_increment fields,drop class

create class xoo ( id int auto_increment ,
		   id2 decimal(10,0) auto_increment,
		   id3 numeric(10,0) auto_increment,
                   title varchar(100));

insert into xoo(title) values ('aaa');
insert into xoo(title) values ('bbb');
insert into xoo(title) values ('ccc');

select * from xoo order by 1;

insert into xoo(id, id2, id3, title) values (10,10,10,'qqq');
insert into xoo(id, id2, id3, title) values (11,11,11,'www');
insert into xoo(id, id2, id3, title) values (12,12,12,'eee');

select * from xoo order by 1;

update xoo set id = 100, id2 = 100, id3 = 100 where title = 'qqq';

select * from xoo order by 1;
create vclass vxoo (
	id int, 
	id2 decimal(10,0),
	id3 numeric(10,0),
	title varchar(100)
) as select * from xoo;

select * from vxoo order by 1;

drop vclass vxoo;
drop class xoo;
