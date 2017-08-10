--Test group by and having
create class t(name varchar(20), price MONETARY);
insert into t values('a', 101);
insert into t values('b', 101);
insert into t values('c', 103);
insert into t values('d', 102);
insert into t values('e', 104);
insert into t values('e', 105);

select name, avg(price)
from  t 
group by name
having name <> 'c';

drop class t;