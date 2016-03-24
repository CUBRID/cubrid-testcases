-- retrieve by function of to_char using parameter of smallint field and using parameter of 's9,9,9' ,'c999.9' ,'00999.9' or 's9.eeee' format_argument


create class func_04 ( a smallint, b int, c numeric(38,10), d float, e monetary, f double );
insert into func_04 values ( 0,0,0,0,0,0);
insert into func_04(a) values ( null);
insert into func_04 values ( 1,1,1,1,1,1);
insert into func_04 values ( 127,10000,987654321.123456789,987654321.123,987654321.987,987654321.123);
insert into func_04 values (-127,-10000,-987654321.123456789,-987654321.123, -987654321.987,-987654321.123);


select a,to_char(a, 's9,9,9') from  func_04 order by 1	;
select a,to_char(a, 'c999.9') from  func_04 order by 1	;
select a,to_char(a, '00999.9') from  func_04 order by 1	;
select a, to_char(a,'s9.eeee') from func_04 order by 1;

drop class func_04;