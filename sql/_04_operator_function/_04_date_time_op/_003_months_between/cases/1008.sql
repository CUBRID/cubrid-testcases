-- retrieve by function of months_between using parameter of sys_date and cast sys_timestamp to date and then cast result to int


create class dummy( a int );
insert into dummy values (1);

select cast(months_between(sys_date,sys_date) as int) from dummy	;
select cast(months_between(cast(sys_timestamp as date) ,cast(sys_timestamp as date)) as int) from dummy;

drop class dummy;