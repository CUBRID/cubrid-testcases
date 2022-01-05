--create trigger and set trigger trace on to debug trigger
create class cl1(x int);

create trigger tr1
  before insert on cl1
  execute print 'Insert a new row to cl1)'; 
set trigger trace on;
insert into cl1 values(1);  
insert into cl1 values(2);
set trigger trace off;
drop trigger tr1;
drop class cl1;
