-- [er]retrieve by function of position using parameter of string but not use IN keyword
create class dummy( a int );
insert into dummy values (1);

select position(' hihi ') from dummy;



drop class dummy;