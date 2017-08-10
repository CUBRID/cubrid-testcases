-- [er]retrieve by function of bit_length using parameter of blank
create class dummy( a string );
insert into dummy values (null);
 
select bit_length() from dummy;
 
drop class dummy;

