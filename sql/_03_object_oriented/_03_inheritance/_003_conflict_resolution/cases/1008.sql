-- create superclass and drop attribute of class 
create class t1
(id integer,
 name string);

create class t2 under t1
(id1 integer,
name1 string
 );

ALTER class t2 drop ATTRIBUTE name1 ;

drop t1;
drop t2;
