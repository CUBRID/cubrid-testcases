-- create class,insert three record for this class,select data from this class,update this class by a query,select data from this class for looking, drop class
create class xoo ( id int auto_increment , title varchar(100));

insert into xoo(title) values ('aaa');
insert into xoo(title) values ('bbb');
insert into xoo(title) values ('ccc');

select * from xoo order by 1;

update xoo set title = 'ddd' where title = (select title from xoo where id = 3);

select * from xoo order by 1;

drop class xoo;
