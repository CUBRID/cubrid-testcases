--create a trigger and alter it's status
create class cl1(col1 integer, col2 varchar(20));
create trigger tr1
  before insert on cl1
  execute print 'Insert a new row to cl1';

alter trigger tr1 
status inactive;

insert into cl1 values (999, 'nhn');
  
drop trigger tr1;
drop class cl1;

