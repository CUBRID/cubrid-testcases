-- [er]retrieve by function of lower using parameter of blank

  
create class dummy( a string );
insert into dummy values (null);


select lower() from dummy;


drop class dummy;