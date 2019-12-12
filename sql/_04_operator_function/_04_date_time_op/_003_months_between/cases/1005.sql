-- retrieve by function of months_between using parameter of date and then cast result to int


create class dummy( a int );
insert into dummy values (1);

select cast(months_between(date'10/10/2000', date'1/10/2000') as int) from dummy	;
select cast(months_between(date'10/10/2000', date'11/09/2000') as int) from dummy;

drop class dummy;