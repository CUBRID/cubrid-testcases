-- create class,insert data to this class,select data,insert data to this class by specifying the auto_increment field value,select data

create class xoo ( id decimal(10,0) auto_increment,
                   title varchar(100));

insert into xoo(title) values ('aaa');
insert into xoo(title) values ('bbb');
insert into xoo(title) values ('ccc');

select * from xoo order by 1;

insert into xoo(id, title) values (10,'qqq');
insert into xoo(id, title) values (11,'www');
insert into xoo(id, title) values (12,'eee');

select * from xoo order by 1;

insert into xoo(title) values ('ddd');

select * from xoo order by 1;

drop class xoo;


create class xoo ( id numeric(10,0) auto_increment,
                   title varchar(100));

insert into xoo(title) values ('aaa');
insert into xoo(title) values ('bbb');
insert into xoo(title) values ('ccc');

select * from xoo order by 1;

insert into xoo(id, title) values (10,'qqq');
insert into xoo(id, title) values (11,'www');
insert into xoo(id, title) values (12,'eee');

select * from xoo order by 1;

insert into xoo(title) values ('ddd');

select * from xoo order by 1;

drop class xoo;