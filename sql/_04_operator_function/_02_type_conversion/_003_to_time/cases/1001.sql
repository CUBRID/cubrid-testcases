-- retrieve by function of to_time using parameter of string,char,varchar field and using format_argument of '"AM" HH24 ":" MI ":" SS','"AM" HH12 ":" MI ":" SS' and using 'between' keyword and using "+" operator

create class func_04 ( a string , b char(11), c varchar(11), d int );
insert into func_04 values (null, null, null, 1 );
insert into func_04 values ( '00:00:00 AM', '00:00:00 AM', '00:00:00 AM', 1 );
insert into func_04 values ( '00:00:00 PM', '00:00:00 PM', '00:00:00 PM', 1 );
insert into func_04 values ( '00:00:00', '00:00:00', '00:00:00', 1 );
insert into func_04 values ( '12:00:00 AM', '12:00:00 AM', '12:00:00 AM', 1 );
insert into func_04 values ( 'AM 01:00:00', 'PM 00:00:00', 'AM 01:00:00', 2 );

 
select a, to_time(a), b, to_time(b), c, to_time(c) from func_04 where d=1 order by 1,3,5	;
select a, to_time(a,'"AM" HH24 ":" MI ":" SS') from func_04 where d=2 order by 1	;
select a, to_time(a,'"AM" HH12 ":" MI ":" SS') from func_04 where d=2 order by 1	;
select a from func_04 where to_time(a) between to_time(a) and to_time(a) and d=1 order by 1	;
select to_time(a) from func_04 where to_time(a) between to_time(a) and to_time(a) and d=1 order by 1	;
select to_time(tmp.tmpresult)  from (select to_char(to_time(a) +1) as tmpresult from func_04 where to_time(a) between to_time(a) and to_time(a) and d=1 order by 1) tmp;
select to_time(null) from func_04;
 

drop class func_04;