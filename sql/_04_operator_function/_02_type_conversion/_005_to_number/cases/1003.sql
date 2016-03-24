-- [er]retrieve by function of to_number using parameter of string and using defult format_argument 

create class func_04 ( a char(4), b char(8), c string, d varchar(20), e varchar(30), f char(20) );
insert into func_04 values ( '0','0','0','0','0','0');
insert into func_04(a) values ( null);
insert into func_04 values ( '1','1','1','1','1','1');
insert into func_04 values ( '127','10000','987654321.123456789','987654321.123','987654321.987','987654321.123');
insert into func_04 values ('-127','-10000','-987654321.123456789','-987654321.123', '-987654321.987','-987654321.123');
 

select d, to_number(d) from func_04 order by 1;
 
drop class func_04;