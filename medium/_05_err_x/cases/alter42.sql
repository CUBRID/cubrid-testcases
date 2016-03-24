autocommit off;

create vclass foo_1
(
  x integer,
  y string
);
create vclass foo_2
(
  a integer,
  b string
)
as select x,y from foo_1;
alter vclass foo_1 add query select a,b from foo_2;
select * from foo_2;
rollback work;
rollback;
