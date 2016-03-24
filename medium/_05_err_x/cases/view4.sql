autocommit off;
create class  i  (price monetary, code integer);
create vclass ic (f float, d date) as select price, code from i;
select * from ic;
rollback work;
rollback;
