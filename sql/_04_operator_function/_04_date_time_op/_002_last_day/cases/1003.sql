-- [er]retrieve by function of last_day and use a time date type as data date type to cast


create class dummy( a int );
insert into dummy values (1);
select last_day(cast(time'01:01:01' as date)) from dummy;

drop class dummy;
