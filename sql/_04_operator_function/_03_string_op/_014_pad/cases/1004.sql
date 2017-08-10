-- [er]retrieve by function of lpad using a integer parameter

create class dummy( a int );
insert into dummy values (1);

select lpad( 10, 'x' ) from dummy;

drop class dummy;