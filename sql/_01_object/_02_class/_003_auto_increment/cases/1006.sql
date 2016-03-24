-- create a class with condition 'int auto_increment not null'

create class xoo ( id int auto_increment not null  ,
                   title varchar(100));

insert into xoo(title) values ('aaa');
insert into xoo(title) values ('bbb');
insert into xoo(title) values ('ccc');

select * from xoo order by 1;

drop class xoo;