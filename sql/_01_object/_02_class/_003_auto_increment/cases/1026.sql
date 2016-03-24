-- [er]create class with condition of 'auto_increment(-100,2 , title varchar(100))',that is an error
create class xoo ( id int auto_increment(-100,2 , title varchar(100));

insert into xoo(title) values ('aaa');
insert into xoo(title) values ('bbb');
insert into xoo(title) values ('ccc');

select * from xoo order by 1;

drop class xoo;