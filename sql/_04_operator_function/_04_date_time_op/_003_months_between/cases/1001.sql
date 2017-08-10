-- retrieve by function of months_between using parameter of date and cast result to int


create class dummy( a int );
insert into dummy values (1);



select months_between(date'10/10/2000', date'11/10/2000') from dummy	;
select months_between(date'10/10/2000', date'1/10/2000') from dummy	;
select months_between(date'1/1/1', date'12/31/9999') from dummy	;
select months_between(date'12/31/9999', date'1/1/0001') from dummy	;
select cast(months_between(date'1/1/1', date'12/31/9999') as int) from dummy;
select cast(months_between(date'12/31/9999', date'1/1/0001') as int) from dummy;
drop class dummy;