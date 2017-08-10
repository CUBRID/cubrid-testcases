--Create trigger with correlation name:old, event type:update, event time:after
create class cl1 ( col1 int, col2 varchar(10));
create class cl2 ( col1 int, col2 varchar(10));
create trigger tr1
  after update on cl1
  if old.col1 > 9
  execute insert into cl2 values (old.col1 - 5, 'nhn');
  
insert into cl1 values(10,'nhnchina');
update cl1 set col1=11;
select * from cl1;
select * from cl2;

drop trigger tr1;
drop class cl1;
drop class cl2;