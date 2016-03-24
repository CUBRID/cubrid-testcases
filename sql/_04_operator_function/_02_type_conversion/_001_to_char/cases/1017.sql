-- [er]retrieve by function of to_char using parameter of monetary field and using parameter of '999999,999' format_argument


create class func_04 ( a smallint, b int, c numeric(38,10), d float, e monetary, f double );
insert into func_04 values ( 0,0,0,0,0,0);
insert into func_04(a) values ( null);
insert into func_04 values ( 1,1,1,1,1,1);
insert into func_04 values ( 127,10000,987654321.123456789,987654321.123,987654321.987,987654321.123);
insert into func_04 values (-127,-10000,-987654321.123456789,-987654321.123, -987654321.987,-987654321.123);
select e, to_char(e,'999999,999')  from func_04 order by 1;


drop class func_04;