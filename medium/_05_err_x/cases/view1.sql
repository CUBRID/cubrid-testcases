-- type mismatch between first select item in select lilst and the attribute component in vclass foo_u
autocommit off;

create class foo
(
  component string,
  quantity integer
);
create vclass foo_u
(
  component string,
  quantity integer
)
as select set (select component from foo), quantity from foo;
rollback work;
rollback;
