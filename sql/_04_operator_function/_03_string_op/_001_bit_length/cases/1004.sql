-- [er]retrieve by function of bit_length using parameter of an undefined variable

create class dummy( a string );
insert into dummy values (null);
 select bit_length(abc) from dummy;
 
drop class dummy;

