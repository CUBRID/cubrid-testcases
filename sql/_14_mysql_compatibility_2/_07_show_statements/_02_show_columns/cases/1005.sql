-- SHOW COLUMNS -- check syntax
create table tt1 (s1 sequence ( integer,   char varying, integer ),
		  i1 integer,
		  i2 integer auto_increment,
		  i3 integer unique,
		  i4 integer default 33,
		  n1 numeric(10) not NULL,
		  n2 numeric (10,2),
		  n3 numeric);


show columns from tt1;

show columns from tt1 like '%1';

show columns from tt1 where Field='i1';

show columns from tt1 where `Type` like 'NUMERIC%';

show columns from tt1 where `Null`='NO';

show columns from tt1 where `Key`='UNI';

show columns from tt1 where `Default` is not NULL;

show columns from tt1 where `Extra` <> '';
	  
drop table tt1;

