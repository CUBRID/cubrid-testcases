-- [er]retrieve by function of ltrim using parameter of blank

create class dummy( a int );
insert into dummy values (1);

select ltrim() from dummy;


drop class dummy;