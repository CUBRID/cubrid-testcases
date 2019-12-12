-- [er]retrieve by function of add_months using a parameter  witch 0 as day


create class dummy( a int );
insert into dummy values (1);

select add_months(date'1/0/0001', 1) from dummy;
drop class dummy;
