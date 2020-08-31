create table foo(a int auto_increment, b char(20), c smallint default 22)auto_increment=100;

insert into foo(b) values('aaa');
insert into foo(b) values('bbb');
select * from foo order by 1;

alter table foo change a aa int auto_increment;
alter table foo auto_increment = 200;
alter table foo modify b char(20) default 'kkk';
insert into foo(c) values(12);
select * from foo order by 1;

alter table foo change b bb char(20) not null;
alter table foo modify c monetary;
alter table foo change c cc bigint auto_increment;
insert into foo(bb) values('ddd');
select * from foo order by 1;

--[er]
alter table foo auto_increment = 50;
alter table foo modify cc bigint;
alter table foo auto_increment = 50;
insert into foo(bb, cc) values('hhh', 999);
insert into foo(bb, cc) values('iii', 888);
select * from foo order by 1;

drop table foo;
