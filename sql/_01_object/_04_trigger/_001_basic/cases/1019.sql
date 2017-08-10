--create a trigger and alter it's priority
create class cl1(col1 integer, col2 varchar(20));
create trigger tr1
  before insert on cl1
  execute print 'Insert a new row to cl1';

alter trigger tr1 
  priority 2.0;
  
drop trigger tr1;
drop class cl1;

