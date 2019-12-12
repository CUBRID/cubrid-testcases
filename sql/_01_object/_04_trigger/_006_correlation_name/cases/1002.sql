--Create trigger using new variable
create class cl1 ( col1 int, col2 varchar(10));
set trigger DEPTH infinite;
create trigger tr1
  before insert on cl1
  if new.col1 > 9
  execute insert into cl1 values (new.col1 - 5, 'nhn');
  
insert into cl1 values(100,'nhnchina');
select * from cl1 order by 1 desc;

drop trigger tr1;
drop class cl1;
