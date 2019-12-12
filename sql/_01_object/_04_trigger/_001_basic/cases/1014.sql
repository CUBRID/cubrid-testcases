--create trigger with recursive loop 
create class cl1(col1 integer, col2 varchar(20));
insert into cl1 values(999, 'nhn');
create trigger tr1
  before update on cl1(col1)
  if new.col1 > 0
  execute update cl1 set col1 = new.col1 - 1
          where col2 = obj.col2;
set trigger trace on;
update cl1 set col1 = 10
  where col2 = 'nhn';
select * from cl1; 
set trigger trace off; 
drop trigger tr1;
drop class cl1;