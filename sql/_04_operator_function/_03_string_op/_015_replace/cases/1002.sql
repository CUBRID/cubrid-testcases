-- [er]retrieve by function of replace using parameter of blank

create class dummy( a int );
insert into dummy values (1);

select replace() from dummy;


drop class dummy;