-- [er]retrieve by function of position using parameter of null and but use IN keyword
create class dummy( a int );
insert into dummy values (1);

select position(null) from dummy;



drop class dummy;