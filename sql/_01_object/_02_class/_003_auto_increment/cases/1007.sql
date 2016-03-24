-- create a class with condition 'int  auto_increment unique',insert data to this class,select data,drop class
create class xoo ( id int  auto_increment unique  ,
                   title varchar(100));

insert into xoo(title) values ('aaa');
insert into xoo(title) values ('bbb');
insert into xoo(title) values ('ccc');

select * from xoo order by 1;

drop class xoo;