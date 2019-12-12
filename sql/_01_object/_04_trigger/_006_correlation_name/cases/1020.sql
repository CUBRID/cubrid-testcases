--[er]Create trigger with correlation name:obj, event type:delete, event time:deferred
create class cl1 ( col1 int, col2 varchar(10));
create class cl2 ( col1 int, col2 varchar(10));
create trigger tr1
  deferred delete on cl1
  if obj.col1 > 9
  execute insert into cl2 values (obj.col1 - 5, 'nhn');
  
insert into cl1 values(10,'nhnchina');

delete from cl1;
select * from cl1;
select * from cl2;

drop class cl1;
drop class cl2;
drop trigger tr1;