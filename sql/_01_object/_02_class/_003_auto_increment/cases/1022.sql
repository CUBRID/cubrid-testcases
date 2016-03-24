-- create class,insert data to this class,select data,insert data to this class by specifying the auto_increment field value,select data

create class xoo ( id int auto_increment ,
		   id2 decimal(10,0) auto_increment,
		   id3 numeric(10,0) auto_increment,
                   title varchar(100));

insert into xoo(title) values ('aaa');
insert into xoo(title) values ('bbb');
insert into xoo(title) values ('ccc');

select * from xoo order by 1;

insert into xoo(id, id2, id3, title) values (10,10,10,'qqq');
insert into xoo(id, id2, id3, title) values (11,11,11,'www');
insert into xoo(id, id2, id3, title) values (12,12,12,'eee');

select * from xoo order by 1;

insert into xoo(title) values ('ddd');

select * from xoo order by 1;

drop class xoo;