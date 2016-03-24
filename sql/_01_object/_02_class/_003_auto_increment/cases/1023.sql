-- create class with threee int auto_increment field,insert data to this clause,select data ,insert data,select data ,update the auto_increment field,select data,drop class

create class xoo ( id int auto_increment ,
		   id2 int auto_increment,
		   id3 int auto_increment,
                   title varchar(100));

insert into xoo(title) values ('aaa');
insert into xoo(title) values ('bbb');
insert into xoo(title) values ('ccc');

select * from xoo order by 1;

insert into xoo(id, id2, id3, title) values (10,10,10,'qqq');
insert into xoo(id, id2, id3, title) values (11,11,11,'www');
insert into xoo(id, id2, id3, title) values (12,12,12,'eee');

select * from xoo order by 1;

update xoo set id = 100, id2 = 100, id3 = 100 where title = 'qqq';

select * from xoo order by 1;

drop class xoo;
