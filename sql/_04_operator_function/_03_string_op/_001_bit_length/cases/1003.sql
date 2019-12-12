--retrieve by function of bit_length using parameter of null

create class dummy( a string );
insert into dummy values (null);
 
select bit_length(null) from dummy;

 
drop class dummy;

