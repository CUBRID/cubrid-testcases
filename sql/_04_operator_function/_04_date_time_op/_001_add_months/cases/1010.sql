-- [er]retrieve by function of add_months using a string parameter on the second position


create class dummy( a int );
insert into dummy values (1);

select add_months(date'1/1/2222', '10') from dummy;
drop class dummy;
