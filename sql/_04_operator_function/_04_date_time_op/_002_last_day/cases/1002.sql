-- [er]retrieve by function of last_day using a string parameter



create class dummy( a int );
insert into dummy values (1);

-- common year

select last_day('2/1/2100') from dummy;

drop class dummy;
