-- [er]retrieve by function of char_length using parameter of integer

create class dummy( a string );
insert into dummy values (null);


select lower(123) from dummy;


drop class dummy;