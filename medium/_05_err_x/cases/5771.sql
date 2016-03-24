autocommit off;
create class a (b char(10) default null);
insert into a(b) values ('foo');
insert into a(b) values ('');
rollback;
