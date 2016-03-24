autocommit off;
create class foo (
  int_attr integer shared NULL,
  int_attr2 integer unique
);
insert into foo (int_attr) values (0);
select * from foo;
insert into foo (int_attr) values (10);
select * from foo;
insert into foo (int_attr) values (20);
select * from foo;
alter class foo add attribute int_attr3 integer;
select * from foo;
rollback;
