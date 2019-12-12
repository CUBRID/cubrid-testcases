-- [er]retrieve by function of replace using a integer parameter

create class dummy( a int );
insert into dummy values (1);

select replace('hello','l', 111) from dummy;

drop class dummy;