-- [er]retrieve by function of to_date using defult format_argument to suit the string whith not is the format 'HH:MI[:SS] [am|pm]'
create class func_04 ( a string , b char(11), c varchar(11), d int );
insert into func_04 values (null, null, null, 1 );
insert into func_04 values ( '00:00:00 AM', '00:00:00 AM', '00:00:00 AM', 1 );
insert into func_04 values ( '00:00:00 PM', '00:00:00 PM', '00:00:00 PM', 1 );
insert into func_04 values ( '00:00:00', '00:00:00', '00:00:00', 1 );
insert into func_04 values ( '12:00:00 AM', '12:00:00 AM', '12:00:00 AM', 1 );
insert into func_04 values ( 'AM 01:00:00', 'PM 00:00:00', 'AM 01:00:00', 2 );

 



select a, to_time(a), b, to_time(b), c, to_time(c) from func_04 where d=2 order by 1,3,5;

 
drop class func_04;