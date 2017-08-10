-- [er]retrieve by function of add_months and result date more than 9999


create class dummy( a int );
insert into dummy values (1);

select add_months(date'12/1/9999', 1) from dummy;
drop class dummy;
