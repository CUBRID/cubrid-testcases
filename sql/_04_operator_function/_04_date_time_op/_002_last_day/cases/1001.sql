-- retrieve by function of last_day  using parameter of null and  date whith cast from timestamp



create class dummy( a int );
insert into dummy values (1);

select last_day(date'2/1/2000') from dummy ; 	
select last_day(date'2/1/2001') from dummy ; 
select last_day(date'2/1/2002') from dummy ; 
select last_day(date'2/1/2003') from dummy  ;
select last_day(date'2/1/2004') from dummy  ;
select last_day(date'2/1/2100') from dummy  ;
select last_day(cast(timestamp '2/2/2000 01:01:01' as date))  from dummy	;
select last_day(NULL) from dummy	;
select last_day(cast(timestamp'1/1/2000 01:01:01' as date)) from dummy;

drop class dummy;
