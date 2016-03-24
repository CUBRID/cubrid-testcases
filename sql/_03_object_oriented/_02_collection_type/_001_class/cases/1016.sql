--Create class with class attribute which domain is collection type

create class t1 class attribute(author set of varchar(10))
(c1 int, c2 varchar(20));

drop class t1;