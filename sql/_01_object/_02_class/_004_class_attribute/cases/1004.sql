-- create class,insert data to this class,select data from this class,update a the auto_increment field using a subquery,insert data to this class,select data from this class,drop class

create class xoo ( id int auto_increment , title varchar(100));

insert into xoo(title) values ('aaa');
insert into xoo(title) values ('bbb');
insert into xoo(title) values ('ccc');

select * from xoo order by 1;

update xoo set id = 100 where id = (select id from xoo where title = 'ccc');
insert into xoo(title) values ('ddd');
select * from xoo order by 1;

drop class xoo;
