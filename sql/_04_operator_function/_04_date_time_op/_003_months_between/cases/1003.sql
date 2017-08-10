-- [er] retrieve by function of months_between using  blank  parameters



create class dummy( a int );
insert into dummy values (1);

select months_between(,) from dummy;

drop class dummy;