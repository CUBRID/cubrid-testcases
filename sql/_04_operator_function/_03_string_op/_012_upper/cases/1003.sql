--retrieve by function of replace using parameter of null

create class dummy( a int );
insert into dummy values (1);


select upper(null) from dummy;


drop class dummy;