autocommit off;
create class foo(foo1 int);
insert into foo() values(1);
create class boo(boo1 string);

insert into boo() values('cat');
create vclass vfoo (vfoo_set set(int)) 
 as select set(select foo1 from foo) from boo;
insert into vfoo(vfoo_set)  select {foo1} from foo;

rollback;
