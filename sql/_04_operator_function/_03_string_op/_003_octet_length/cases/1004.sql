-- [er]retrieve by function of octet_length using parameter of an undefined variable

create class dummy( a string );
insert into dummy values (null);

select octet_length(abc) from dummy;


drop class dummy;