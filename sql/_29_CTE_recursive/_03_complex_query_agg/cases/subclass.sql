autocommit off;
create class foo(a1 int);
insert into foo(a1) values(1);
create class sub_foo as subclass of foo;
insert into sub_foo(a1) values(2);
with recursive vfoo(b1 int) as (select a1 from all foo (except sub_foo)) select * from vfoo order by 1;
with recursive vfoo(b1) as (select a1 from all foo ) select * from vfoo order by 1;
drop foo;
rollback;
