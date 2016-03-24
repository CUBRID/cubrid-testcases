--create class with collection type and rname this list
create class t1(c1 set of int, c2 set varchar(10));
alter t1 rename c1 as col1;
alter t1 rename c2 as col2;


drop class t1;