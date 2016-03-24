--Create class with collection type and rename class name
create class t1(c1 set of int, c2 set varchar(10));

alter class t1 add c3 set date, c4 set char(10);

drop class t1;