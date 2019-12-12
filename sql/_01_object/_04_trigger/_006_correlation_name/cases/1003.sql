--Create trigger with correlation name:new, event type:insert, event time:before
create class cl1 ( col1 int, col2 varchar(10));

create trigger tr1
  before insert on cl1
  if new.col1 > 9
  execute insert into cl1 values (new.col1 - 5, 'nhn');
  
insert into cl1 values(10,'nhnchina');

drop trigger tr1;
drop class cl1;