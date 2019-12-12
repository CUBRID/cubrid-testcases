--[er]Create trigger with correlation name:new, event type:update, event time:after
create class cl1 ( col1 int, col2 varchar(10));

create trigger tr1
  after update on cl1
  if new.col1 > 9
  execute insert into cl1 values (new.col1 - 5, 'nhn');
  
insert into cl1 values(10,'nhnchina');
update cl1 set col1=11 where col2='nhnchina';
drop class cl1;
drop trigger tr1;