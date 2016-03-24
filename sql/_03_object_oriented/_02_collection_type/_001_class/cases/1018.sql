--Test create a class with collection type and change it
create class t1(c1 set of int, c2 set varchar(10));

alter class t1 modify c1 multiset of int;

drop class t1;