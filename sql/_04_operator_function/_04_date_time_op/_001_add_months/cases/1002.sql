-- retrieve by function of add_months using parameter of null and date whith cast from string or timestamp and using between keyword


create class dummy( a int );
insert into dummy values (1);

select add_months(null, 1) from dummy	;
select add_months(date'1/1/2222', null) from dummy	;
select add_months(cast('1/1/2222' as date), 1) from dummy;	
select add_months(cast(timestamp'1/1/2000 01:01:01' as date), 1) from dummy;
select * from dummy where date'9/10/2001' between add_months(date'10/10/2000',10)   and add_months(date'11/11/2000', 100);
drop class dummy;
