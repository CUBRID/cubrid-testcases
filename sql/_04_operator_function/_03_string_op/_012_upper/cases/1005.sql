-- [er]retrieve by function of upper using parameter of an undefined  variable

create class dummy( a int );
insert into dummy values (1);


select upper(abc) from dummy;

drop class dummy;