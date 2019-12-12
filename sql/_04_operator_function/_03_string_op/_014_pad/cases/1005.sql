-- [er]retrieve by function of rpad using parameter of blank


create class dummy( a int );
insert into dummy values (1);


select rpad() from dummy;


drop class dummy;
