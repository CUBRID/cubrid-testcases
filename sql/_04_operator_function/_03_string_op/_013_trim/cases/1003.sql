-- [er]retrieve by function of trim using parameter of blank

create class dummy( a int );
insert into dummy values (1);


select trim() from dummy;

 
drop class dummy;