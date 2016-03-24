autocommit off;
create class foo(a1 int);
insert into foo(a1) values(1);
create class sub_foo as subclass of foo;
insert into sub_foo(a1) values(2);
create vclass vfoo(b1 int) as
       (select a1 from all foo (except sub_foo));
select * from vfoo;
drop foo;
rollback;
