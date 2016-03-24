-- [er]create superclass and rename attribute of class to same name but different type with superclass
create class t1
(id integer,
 name string);

create class t2 under t1
(id1 integer,
name1 int
 );

ALTER class t2
rename ATTRIBUTE name1 as name;

drop t1;
drop t2;
