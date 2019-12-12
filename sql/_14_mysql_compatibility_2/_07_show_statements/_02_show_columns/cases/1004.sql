-- SHOW COLUMNS -- collection types + inner collection
create table tt4 (s1 sequence (integer, char varying, integer));

create table tt5 (s1 set (char varying, integer, double));

show columns from tt4;

show columns from tt5;

		  
drop table tt4;
drop table tt5;

