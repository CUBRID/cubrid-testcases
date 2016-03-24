--Test optimizing on class with oid object
create class t1(c1 int);

create class t2(c1 int,c2 char(10), c3 t1);

update statistics on t2;
update statistics on t1;

drop class t1;
drop class t2;