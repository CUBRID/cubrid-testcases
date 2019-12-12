
-- [er]retrieve by function of lower using parameter of null

  
create class dummy( a string );
insert into dummy values (null);

 

select lower(null) from dummy;

drop class dummy;