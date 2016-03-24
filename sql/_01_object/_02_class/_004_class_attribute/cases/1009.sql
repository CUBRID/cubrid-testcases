--insert value to auto-increment attribute explicilty

create class xoo ( id int auto_increment , title varchar(100));


insert into xoo(title) values ('aaa');
insert into xoo(title) values ('bbb');
insert into xoo(title) values ('ccc');

select * from xoo order by 1;

insert into xoo(id, title) values (4, 'ddd');
insert into xoo(title) values ('eee');
insert into xoo(title) values ('fff');

select * from xoo order by 1;

drop class xoo;