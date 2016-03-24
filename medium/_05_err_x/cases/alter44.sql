autocommit off;
create vclass foo_2
(
  a integer,
  b string
)
as select x,y from foo_2;
select * from foo_2;
rollback work;
rollback;
