-- SHOW COLUMNS -- collection types + default
create table tt1 (sq1 sequence (integer, char varying) default {1,'123'} ,
		  st1 set (integer, char varying) default {1,'123'} ,
		  mst1 multiset (integer, char varying) default {1,'123'},
		  lst1 list (integer, char varying) default {1,'123'},
		  s1 sequence ( integer, char varying, integer) default {1, '123',1},
		  i1 integer
);	

show columns from tt1;

		  
drop table tt1;

