-- [er]retrieve by function of rtrim using a integer parameter

create class dummy( a int );
insert into dummy values (1);


select rtrim('hi', 1) from dummy;


drop class dummy;