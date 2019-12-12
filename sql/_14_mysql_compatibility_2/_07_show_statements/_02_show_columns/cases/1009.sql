-- SHOW COLUMNS -- class with inherited attributes

create class c1 (i1 integer);

create class c2 under c1 (i2 integer);


create class c3 under c2 (i3 integer);

show columns from c1;
show columns from c2;
show columns from c3;

drop class c3;
drop class c2;
drop class c1;


-------------- same name 
create class c1 (i1 integer);

create class c2 under c1 (i1 integer);


show columns from c1;
show columns from c2;


drop class c2;
drop class c1;


-- multiple inheritance

create class b1 (i1 integer);

create class b2 (i1 integer);


create class d under b1,b2 (i1 integer) inherit i1 of b1 as i_1;

show columns from b1;
show columns from b2;
show columns from d;

drop class d;
drop class b1;
drop class b2;


	  

