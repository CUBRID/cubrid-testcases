-- [er]retrieve by function of octet_length using parameter of integer    

create class dummy( a string );
insert into dummy values (null);


select octet_length(123) from dummy;

 
drop class dummy;