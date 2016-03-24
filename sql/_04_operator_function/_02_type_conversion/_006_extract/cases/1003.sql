--retrieve by function of extract using parameter of second,minute,hour,day,month,year with operate of "+"

create class func_05 ( a timestamp , b date, c time );
insert into func_05 values( '00:00:01 01/01/1971', '01/01/1970', '01:02:03');
insert into func_05 values( '03:14:07 01/01/2038', '01/01/2038', '01:02:03');
insert into func_05 values( '01:02:03 am 01/01/1980', '01/01/1980', '01:02:03 am');
insert into func_05 values( '01:02:03 pm 01/01/1980', '01/01/1980', '01:02:03 pm');
insert into func_05 values( null , null, null);



select extract(second from a), extract(second from c) from func_05 order by 1,2	;
select extract(minute from a), extract(minute from c) from func_05 order by 1,2	;
select extract(hour from a), extract(hour from c) from func_05 order by 1,2	;
select extract(day from a), extract(day from b) from func_05 order by 1,2	;
select extract(month from a), extract(month from b) from func_05 order by 1,2	;
select extract(year from a), extract(year from b) from func_05 order by 1,2	;
select extract(second from a) + extract(second from c) from func_05 order by 1	;
select extract(minute from a) + extract(minute from c) from func_05 order by 1	;
select extract(year from a) +  extract(year from b) from func_05 order by 1;
 
drop class func_05;