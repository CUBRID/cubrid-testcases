--[er]create trigger using both deffered and reject keyword
create class cl1(col1 integer, col2 varchar(20));
insert into cl1 values(999, 'nhn');
create trigger tr1
  deferred update on cl1(col1)
  if obj.col1 > 1000
  execute reject;

drop class cl1;
drop trigger tr1;