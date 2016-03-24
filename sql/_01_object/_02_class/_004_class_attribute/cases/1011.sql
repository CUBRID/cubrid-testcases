-- create class and update data using where keyword

create class xoo ( id int auto_increment , title varchar(100));

insert into xoo(title) values ('aaa');
insert into xoo(title) values ('bbb');
insert into xoo(title) values ('ccc');

select * from xoo order by 1;

update xoo set id = 100 where id = 3;
insert into xoo (title) values ('eee');

select * from xoo order by 1;

drop class xoo;
