autocommit off;
create class foo2
method upfoo2() int
file 'oldfoo.o';
alter class foo2
change FILE 'oldfoo.o' AS 'newfoo.o';
rollback;
