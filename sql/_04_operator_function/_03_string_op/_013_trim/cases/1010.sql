-- [er]retrieve by function of ltrim using a integer parameter

create class dummy( a int );
insert into dummy values (1);

select ltrim('hi', 1) from dummy;


drop class dummy;