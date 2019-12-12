-- retrieve by function of add_months using between and >= operatiors



create class dummy( a int );
insert into dummy values (1);


select * from dummy where date'9/10/2001' between add_months(date'10/10/2000',10)   and add_months(date'11/11/2000', null);	
select * from dummy where  add_months(date'10/10/2000',0) >=  add_months(date'11/11/2000', -1);	
select * from dummy where  add_months(date'10/11/2000',0) >=  add_months(date'11/11/2000', -1);
drop class dummy;
