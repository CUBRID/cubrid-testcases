--[er] Create trigger with correlation name:new, event type:delete, event time:before
create class cl1 ( col1 int, col2 varchar(10));
create class cl2 ( col1 int, col2 varchar(10));
create trigger tr1
  before delete on cl1
  if new.col1 > 9
  execute insert into cl2 values (new.col1 - 5, 'nhn');
  
insert into cl1 values(10,'nhnchina');
select * from cl1;
update cl1 set col1=11;
select * from cl2;

drop class cl1;
drop class cl2;
drop trigger tr1;