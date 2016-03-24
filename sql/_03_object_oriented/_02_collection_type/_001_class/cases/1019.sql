--Create class with collection and drop some attribute
create class t1(c1 set of int, c2 set varchar(10),
                 c3 set char(10), c4 set date
                 );


alter class t1 drop c1, c3;

drop class t1;
