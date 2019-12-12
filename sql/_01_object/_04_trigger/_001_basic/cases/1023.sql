--[er]Create trigger with some condition and fire the action
create class cl1 (col1 integer, col2 varchar(20));
create trigger tr1
  before insert on cl1
  if 5 < (select count(*) from cl1)
  execute reject;
  
insert into cl1 values(999, 'nhn');
insert into cl1 values(99, 'nhn');
insert into cl1 values(999, 'nhn');
insert into cl1 values(99, 'nhn');
insert into cl1 values(999, 'nhn');
insert into cl1 values(99, 'nhn');
insert into cl1 values(999, 'nhn');


select * from cl1 order by 1 desc;
drop trigger tr1;
drop class cl1;

