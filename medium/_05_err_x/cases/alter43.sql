autocommit off;

create vclass foo_2
(
  a integer,
  b string
);
alter vclass foo_2 add query
      select a,b from foo_2;
select * from foo_2;
rollback work;
rollback;
