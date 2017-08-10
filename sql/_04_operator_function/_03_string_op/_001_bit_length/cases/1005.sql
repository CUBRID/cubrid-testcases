-- [er]retrieve by function of bit_length using parameter of integer

create class dummy( a string );
insert into dummy values (null);
 select bit_length(123) from dummy;

  
drop class dummy;

