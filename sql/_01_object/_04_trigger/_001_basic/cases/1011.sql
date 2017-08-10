--[er]Create trigger with a negative floating point priority
create class cl1(x int);

create trigger tr1
  priority -1
  before insert on cl1
  execute print 'Insert a new row to cl1)'; 
  
drop class cl1;
drop trigger tr1;