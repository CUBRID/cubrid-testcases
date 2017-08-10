-- [er]retrieve by function of add_months using a parameter  witch 0 as year


create class dummy( a int );
insert into dummy values (1);

select add_months(date'1/1/0000', 1) from dummy;
drop class dummy;
