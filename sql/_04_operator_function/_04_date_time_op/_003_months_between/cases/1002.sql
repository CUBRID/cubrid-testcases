-- [er] retrieve by function of months_between using a blank date data type parameter


create class dummy( a int );
insert into dummy values (1);

select months_between(date'',date'') from dummy;

drop class dummy;