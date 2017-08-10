-- [er]retrieve by function of lower using parameter of a not defined variable

  
create class dummy( a string );
insert into dummy values (null);


select lower(abc) from dummy;

drop class dummy;