--[er]create a class with conditions like 'int auto_increment(2147483646,1)',but Next value exceeds MAX(MIN) value

create class xoo ( id int auto_increment(2147483646,1) , title varchar(100));

insert into xoo(title) values ('aaa');
insert into xoo(title) values ('bbb');
insert into xoo(title) values ('ccc');

select * from xoo order by 1;

drop class xoo;