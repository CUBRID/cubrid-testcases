-- retrieve by function of months_between using parameter of  null on the first position or null both two parameter



create class dummy( a int );
insert into dummy values (1);

select months_between(null, date'11/10/2000') from dummy;	
select months_between(null, null) from dummy;

drop class dummy;