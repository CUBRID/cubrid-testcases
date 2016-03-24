--[er]retrieve by function of extract using parameter of year that don't match on timetz type 

create class func_05 ( a timestamptz , b date, c time );
insert into func_05 values( '00:00:01 01/01/1971', '01/01/1970', '01:02:03');
insert into func_05 values( '03:14:07 01/01/2038', '01/01/2038', '01:02:03');
insert into func_05 values( '01:02:03 am 01/01/1980', '01/01/1980', '01:02:03 am');
insert into func_05 values( '01:02:03 pm 01/01/1980', '01/01/1980', '01:02:03 pm');
insert into func_05 values( null , null, null);
 

select extract(year from a),  extract(year from b), extract(year from c) from func_05 order by 1,2,3;

 

drop class func_05;
