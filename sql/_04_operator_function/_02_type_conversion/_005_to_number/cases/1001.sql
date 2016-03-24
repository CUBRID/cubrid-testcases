-- retrieve by function of to_number and cast using parameter of string,char and varchar and using format_argument of '999.999999','000.000000','999,999'

create class func_04 ( a char(4), b char(8), c string, d varchar(20), e varchar(30), f char(20) );
insert into func_04 values ( '0','0','0','0','0','0');
insert into func_04(a) values ( null);
insert into func_04 values ( '1','1','1','1','1','1');
insert into func_04 values ( '127','10000','987654321.123456789','987654321.123','987654321.987','987654321.123');
insert into func_04 values ('-127','-10000','-987654321.123456789','-987654321.123', '-987654321.987','-987654321.123');


select a, to_number(a) from func_04 order by 1;	
select b, to_number(b) from func_04 order by 1;	
select c,cast(c as numeric(30,10)),d,cast(d as numeric(30,10)) from func_04 order by 1,3	;
select e,cast(e as numeric(30,10)),f,cast(f as numeric(30,10)) from func_04 order by 1,3	;
select a, to_number(a,'999.999999') from func_04 order by 1;	
select a, to_number(a,'000.000000') from func_04 order by 1;	
select a, to_number('111,123','999,999') from func_04 order by 1;	
select to_number(null) from func_04 order by 1;
 
drop class func_04;