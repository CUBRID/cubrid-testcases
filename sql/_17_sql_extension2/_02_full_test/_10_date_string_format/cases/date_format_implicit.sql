--test valid date format of string type with implicit conversion


create table string_date_format(col1 date);


--YYYY-MM-DD, YY-MM-DD 
insert into string_date_format values('2010-11-10');
insert into string_date_format values('10-11-10');
insert into string_date_format values('97-4-13');


--MM/DD/YYYY, MM/DD/YY 
insert into string_date_format values('3/23/1898');
insert into string_date_format values('11/10/20');
insert into string_date_format values('4/13/69');


--YYYYMMDD, YYMMDD
insert into string_date_format values('19771215');
insert into string_date_format values('770809');
insert into string_date_format values('121212');


--[er] YYYY/MM/DD 
insert into string_date_format values('2010/11/10');
insert into string_date_format values('1111/12/12');


--[er] exceptional cases
insert into string_date_format values('2010111');
insert into string_date_format values('191222');
insert into string_date_format values('19990803a');
insert into string_date_format values('abcde');
insert into string_date_format values('15/30/2010');
insert into string_date_format values('11/32/30');


select * from string_date_format order by 1;

drop table string_date_format;
