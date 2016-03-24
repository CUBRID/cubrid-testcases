--[er] create a class with a char type auto_increment field,insert data to this class,select information from this class,drop this class



create class xoo ( id char(1) auto_increment , title varchar(100));

insert into xoo(title) values ('aaa');
insert into xoo(title) values ('bbb');
insert into xoo(title) values ('ccc');

select * from xoo order by 1;

drop class xoo;