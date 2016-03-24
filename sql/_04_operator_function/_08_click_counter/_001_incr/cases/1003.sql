-- [er]create this class,insert data to this class,select clause with an 'Semantic: Attribute of derived class is not permitted in INCR()' error

create class xoo ( a int, b int);
insert into xoo values(1, 1);
insert into xoo values(2, 2);

select x.a, incr(x.b) from ( select a,b from xoo ) x where x.a = '1';

drop xoo;
