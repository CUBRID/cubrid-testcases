-- retrieve by function of octet_length using parameter of null

create class dummy( a string );
insert into dummy values (null);
 select octet_length(null) from dummy;

 
drop class dummy;