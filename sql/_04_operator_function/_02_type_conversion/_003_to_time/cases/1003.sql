-- [er]retrieve by function of to_time using char parameter and 'aa' format_argument

create class func_04 ( a string , b char(11), c varchar(11), d int );
insert into func_04 values (null, null, null, 1 );
insert into func_04 values ( '00:00:00 AM', '00:00:00 AM', '00:00:00 AM', 1 );
insert into func_04 values ( '00:00:00 PM', '00:00:00 PM', '00:00:00 PM', 1 );
insert into func_04 values ( '00:00:00', '00:00:00', '00:00:00', 1 );
insert into func_04 values ( '12:00:00 AM', '12:00:00 AM', '12:00:00 AM', 1 );
insert into func_04 values ( 'AM 01:00:00', 'PM 00:00:00', 'AM 01:00:00', 2 );
 

select b, to_time(b,'"aa"') from func_04 where d=2 order by 1;
 
drop class func_04;