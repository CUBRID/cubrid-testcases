-- creat class with int datat ype auto_increment(m,n) field,insert data,select data,drop class

create class xoo ( id int auto_increment(100,2) , title varchar(100));

insert into xoo(title) values ('aaa');
insert into xoo(title) values ('bbb');
insert into xoo(title) values ('ccc');

select * from xoo order by 1;

drop class xoo;
