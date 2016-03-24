autocommit off;
create class classA;
create class classB;
create class classC;
alter class classA add att integer;
alter class classB add refA set(classC);
alter class classC add refB classB;
alter class classA add superclass classC;
select a{x}.classA.att
from classB, classA x, table(refA) as t(a)
where a{x}.att = 19951001;
select a{x}.refA.att
from classB, classA x, table(refA) as t(a)
where a{x}.att = 19951001;
rollback;
