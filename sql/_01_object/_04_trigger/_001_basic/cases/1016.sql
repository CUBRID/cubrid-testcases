--create trigger and rename it
create class cl1(col1 integer, col2 varchar(20));
insert into cl1 values(999, 'nhn');
create trigger tr1
  before update on cl1(col1)
  if new.col1 > 0
  execute update cl1 set col1 = new.col1 - 1
          where col2 = obj.col2;
rename trigger tr1 as new_tr1;

drop trigger new_tr1;
drop class cl1;