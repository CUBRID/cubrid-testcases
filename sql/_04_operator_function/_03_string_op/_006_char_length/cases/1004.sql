-- [er]retrieve by function of char_length using parameter of an undefined variable

create class dummy( a string );
insert into dummy values (null);

select char_length(abc) from dummy;


drop class dummy;