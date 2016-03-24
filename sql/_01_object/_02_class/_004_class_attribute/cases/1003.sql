-- create class,insert data to this class,select data from this class,insert to another record for this class by a query,select data from this class again,drop class

create class xoo ( id int auto_increment , title varchar(100));

insert into xoo(title) values ('aaa');
insert into xoo(title) values ('bbb');
insert into xoo(title) values ('ccc');

select * from xoo order by 1;

insert into xoo(title) select title from xoo where id = 1;

select * from xoo order by 1;

drop class xoo;
