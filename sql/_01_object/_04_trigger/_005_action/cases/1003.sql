--Create trigger with reject action
create class cl1(col1 integer, col2 varchar(20));
create trigger tr1
  before insert on cl1
  if new.col1 is null
  execute reject;


drop trigger tr1;
drop class cl1;