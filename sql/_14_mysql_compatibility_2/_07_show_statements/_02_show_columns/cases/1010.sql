-- DESCRIBE, DESC , EXPLAIN -- check syntax
create table tt1 (s1 sequence ( integer,   char varying, integer ),
		  i1 integer,
		  i2 integer auto_increment,
		  i3 integer unique,
		  i4 integer default 33,
		  n1 numeric(10) not NULL,
		  n2 numeric (10,2),
		  n3 numeric);


DESCRIBE tt1;

DESCRIBE tt1 '%1';

DESCRIBE tt1 i1;
	  
DESC tt1;

DESC tt1 '%1';

DESC tt1 i1;


EXPLAIN tt1;

EXPLAIN tt1 '%1';

EXPLAIN tt1 i1;


drop table tt1;

