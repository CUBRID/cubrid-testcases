--create class with class attribute which is collection type and drop it

create class t1 class attribute(author set varchar(10))
(c1 int, c2 set date);

alter class t1 drop class author;

drop class t1;