-- [er] create class with two same attributes 

create class DML_0001 
( 	int_col integer,
int_col varchar(20),
set_col set (int, varchar(10)) );

drop class DML_0001;