 
-- [er]retrieve by function of lpad using parameter of blank

create class dummy( a int );
insert into dummy values (1);


select lpad() from dummy;


drop class dummy;