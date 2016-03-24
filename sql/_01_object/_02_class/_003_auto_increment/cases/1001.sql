-- [er]create class,create unique on the int field of this class,insert data to this class,select data from this class,insert data to this class again, select data from this class again,drop class
 
create class xoo ( id int auto_increment , title varchar(100));
create unique index uni_id on xoo (id);

insert into xoo(title) values ('aaa');
insert into xoo(title) values ('bbb');
insert into xoo(title) values ('ccc');

select * from xoo order by 1;

insert into xoo(id, title) values (4, 'ddd');
insert into xoo(title) values ('eee');
insert into xoo(title) values ('fff');

select * from xoo order by 1;

drop class xoo;