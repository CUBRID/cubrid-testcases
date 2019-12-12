-- [er]retrieve by function of rpad using a integer parameter


create class dummy( a int );
insert into dummy values (1);


select rpad( 10, 'x' ) from dummy;

drop class dummy;
