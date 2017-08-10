-- [er] retrieve by function of months_between using a  blank  parameter on the second position


create class dummy( a int );
insert into dummy values (1);

select months_between(date'11/11/2000',) from dummy;

drop class dummy;