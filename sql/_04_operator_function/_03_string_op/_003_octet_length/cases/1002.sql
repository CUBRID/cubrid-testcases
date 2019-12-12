-- [er]retrieve by function of octet_length using parameter of blank

create class dummy( a string );
insert into dummy values (null);

 
select octet_length() from dummy;
 
drop class dummy;