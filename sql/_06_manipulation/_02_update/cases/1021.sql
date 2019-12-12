--Test update on class with object domain

create class t1(name varchar(20), age integer);
create class emp (empno integer, attr t1);

insert into t1 values('xxx', 26) into :f1;
insert into emp values(1001, :f1);
insert into t1 values('yyy', 27) into :f1;
insert into emp values(1002, :f1);
insert into t1 values('zzz', 28) into :f1;
insert into emp values(1001, :f1);

update emp set empno = 1003 where attr.name='zzz';

drop class emp;
drop class t1;

