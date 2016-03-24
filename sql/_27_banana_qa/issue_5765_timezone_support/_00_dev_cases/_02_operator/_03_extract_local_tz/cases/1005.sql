-- [er]retrieve by function of extract using parameter of second that don't match on date data type 
set timezone '+9:00';

create class func_05 ( a timestampltz , b date, c time );
insert into func_05 values( '00:00:01 01/01/1971', '01/01/1970', '01:02:03');
insert into func_05 values( '03:14:07 01/01/2038', '01/01/2038', '01:02:03');
insert into func_05 values( '01:02:03 am 01/01/1980', '01/01/1980', '01:02:03 am');
insert into func_05 values( '01:02:03 pm 01/01/1980', '01/01/1980', '01:02:03 pm');
insert into func_05 values( null , null, null);
 
select extract(second from a),  extract(second from b), extract(second from c) from func_05 order by 1,2,3;
 

drop class func_05;
set timezone 'default';
