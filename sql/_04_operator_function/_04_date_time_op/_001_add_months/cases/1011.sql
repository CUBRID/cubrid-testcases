-- [er]retrieve by function of add_months using a string parameter on the first position


create class dummy( a int );
insert into dummy values (1);

select add_months('1/1/0001', 1) from dummy;
drop class dummy;
