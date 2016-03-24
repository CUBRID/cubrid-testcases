-- [er]retrieve by function of to_char using parameter of timestamp and date and using parameter of unsuitable format_argument


create class func_04 ( a timestamp , b date, c time );
insert into func_04 values( '00:00:01 01/01/1971', '01/01/1970', '01:02:03');
insert into func_04 values( '03:14:07 01/01/2038', '01/01/2038', '01:02:03');
insert into func_04 values( '01:02:03 am 01/01/1980', '01/01/1980', '01:02:03 am');
insert into func_04 values( '01:02:03 pm 01/01/1980', '01/01/1980', '01:02:03 pm');
insert into func_04 values( '12:00:00 pm 01/01/1980', '01/01/1980', '12:00:00 pm');
insert into func_04 values( '12:00:00 am 01/01/1980', '12/31/1980', '12:00:00 am');
insert into func_04 values( null , null, null);



select b,to_char(b), to_char(b,null) from func_04 order by 1	;
select b, to_char(b,'999999,999')  from func_04 order by 1	;
select b, to_char(b,'00000000099') from func_04 order by 1	;
select b,to_char(b, 's'+'9999999.0') from  func_04 order by 1	;
select b,to_char(b, 's999') from  func_04 order by 1	;
select b,to_char(b, 's999.00') from  func_04 order by 1	;
select b, to_char(b,'s999999.EEEE') from func_04 order by 1	;
select b,to_char(b, 's9,9,9') from  func_04 order by 1	;
select b,to_char(b, 'c999.9') from  func_04 order by 1	;
select b,to_char(b, '00999999.9') from  func_04 order by 1	;
select b, to_char(b,'s9.eeee') from func_04 order by 1	;
select b, to_char(b, 'c') from func_04	;
select c,to_char(c), to_char(c,null), to_char(c,'999999,999')  from func_04 order by 1	;
select c, to_char(c,'0000000000000099') ,to_char(c, 's'+'9999999.0') from  func_04 order by 1	;
select c,to_char(c, 's999999999999'),to_char(c, 's999.00') from  func_04 order by 1	;
select c, to_char(c,'s999999999999.EEEE'),  to_char(c, 's9999,9,9,9') from  func_04 order by 1	;
select c,to_char(c, 'c000099999999.9'), to_char(c, '00999999.9') from  func_04 order by 1	;
select c, to_char(c,'s9.eeee'), to_char(c, 'c') from func_04	;

select d1002,to_char(d1002), to_char(d1002,null), to_char(d1002,'999999,999')  from func_04 order by 1	;
select d1002, to_char(d1002,'0000000000000099') ,to_char(d1002, 's'+'9999999.0') from  func_04 order by 1	;
select d1002,to_char(d1002, 's999999999999'),to_char(d1002, 's999.00') from  func_04 order by 1	;
select d1002, to_char(d1002,'s999999999999.EEEE'),  to_char(d1002, 's9999,9,9,9') from  func_04 order by 1	;
select d1002,to_char(d1002, 'c000099999999.9'), to_char(d1002, '00999999.9') from  func_04 order by 1	;
select d1002, to_char(d1002,'s9.eeee'), to_char(d1002, 'c') from func_04	;
select e1002, to_char(e1002,'999999,999')  from func_04 order by 1	;

select f1002,to_char(f1002), to_char(f1002,null), to_char(f1002,'999999,999')  from func_04 order by 1	;
select f1002, to_char(f1002,'0000000000000099') ,to_char(f1002, 's'+'9999999.0') from  func_04 order by 1	;
select f1002,to_char(f1002, 's999999999999'),to_char(f1002, 's999.00') from  func_04 order by 1	;
select f1002, to_char(f1002,'s999999999999.EEEE'),  to_char(f1002, 's9999,9,9,9') from  func_04 order by 1	;
select f1002,to_char(f1002, 'c000099999999.9'), to_char(f1002, '00999999.9') from  func_04 order by 1	;
select f1002, to_char(f1002,'s9.eeee'), to_char(f1002, 'c') from func_04	;
select to_char(null)  from func_04	;


drop class func_04;

