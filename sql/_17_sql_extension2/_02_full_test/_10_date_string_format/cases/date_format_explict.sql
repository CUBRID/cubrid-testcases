--test valid date format of string type with expicit conversion


--YYYY-MM-DD, YY-MM-DD 
select cast('2010-11-10' as date);
select cast('10-11-10' as date);
select cast('97-4-13' as date);


--MM/DD/YYYY, MM/DD/YY 
select cast('3/23/1898' as date);
select cast('11/10/20' as date);
select cast('4/13/69' as date);


--YYYYMMDD, YYMMDD
select cast('19771215' as date);
select cast('770809' as date);
select cast('121212' as date);


--[er] YYYY/MM/DD 
select cast('2010/11/10' as date);
select cast('1111/12/12' as date);


-- exceptional cases
select cast('2010111' as date);
select cast('191222' as date);
select cast('19990803a' as date);
select cast('abcde' as date);
select cast('15/30/2010' as date);
select cast('11/32/30' as date);
