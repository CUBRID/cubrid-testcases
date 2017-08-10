-- retrieve by function of add_months using parameter of date data type and null value



create class dummy( a int );
insert into dummy values (1);

select add_months(date'1/1/0001', 1) from dummy	;
select add_months(date'12/1/9999', -1) from dummy	;
select add_months(date'1/1/2222', 10.1) from dummy	;
select add_months(date'1/1/2222', 10.6) from dummy	;
select add_months(null, null) from dummy;


drop class dummy;
