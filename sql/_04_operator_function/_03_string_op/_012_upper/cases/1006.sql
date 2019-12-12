-- [er]retrieve by function of upper using a integer parameter

create class dummy( a int );
insert into dummy values (1);

select upper(123) from dummy;

drop class dummy;