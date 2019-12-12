--Create trigger with some condition
create class cl1 (col1 integer, col2 varchar(20));
create trigger tr1
  before update on cl1
  if obj.col1 > 100
  execute insert into cl1 values(1,'t');
  
insert into cl1 values(999, 'nhn');
insert into cl1 values(99, 'nhn');

update cl1 set col1=102;
select * from cl1 order by 1 desc;

drop trigger tr1;
drop class cl1;

