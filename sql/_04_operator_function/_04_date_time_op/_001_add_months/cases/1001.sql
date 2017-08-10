-- [er]retrieve by function of add_months and using a time date type as data date type to cast 


create class dummy( a int );
insert into dummy values (1);

select add_months(cast(date'1/1/2000 01:01:01' as date), 1) from dummy;
drop class dummy;
