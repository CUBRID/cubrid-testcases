-- [er]retrieve by function of add_months and result date less than 1


create class dummy( a int );
insert into dummy values (1);

select add_months(date'1/1/0001', -1) from dummy;
drop class dummy;
