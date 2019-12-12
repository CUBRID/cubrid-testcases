-- retrieve by function of months_between using parameter of date and null on the second position



create class dummy( a int );
insert into dummy values (1);

select months_between(date'11/10/2000', date'11/10/2000') from dummy	;
select months_between(date'11/10/2000', null) from dummy;

drop class dummy;