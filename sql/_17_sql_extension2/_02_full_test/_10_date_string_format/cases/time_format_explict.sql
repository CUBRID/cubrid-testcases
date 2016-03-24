--test valid time format of string type with expicit conversion


--[H]H:[M]M:[S]S[.msec] : msec is ignored in time value 
select cast('14:00:30' as time);
select cast('2:3:4' as time);
select cast('11:11:11.3' as time);
--[er]
select cast('25:23:33' as time);


--[H]HMMSS[.msec] 
select cast('121545' as time);
select cast('51256' as time);
select cast('060407.111' as time);
--[er]
select cast('281256' as time);
select cast('236123' as time);



--[M]MSS[.msec]
select cast('518' as time);
select cast('945.333' as time);
select cast('1809' as time);
select cast('2222' as time);
--[er]
select cast('2845' as time);
--[er]
select cast('267' as time);



--[S]S[.msec]
select cast('10' as time);
select cast('4' as time);
select cast('59.321' as time);
select cast('0' as time);
--[er]
select cast('66' as time);
select cast('50.1234' as time);


--[er]
select cast('1232345' as time);
select cast('6e10' as time);
select cast('aa109' as time);
