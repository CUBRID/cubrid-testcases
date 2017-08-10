--test valid time format of string type with implicit conversion


create table time_format(col1 time);


--[H]H:[M]M:[S]S[.msec] : msec is ignored in time value 
insert into time_format values('14:00:30');
insert into time_format values('2:3:4');
insert into time_format values('11:11:11.3');
--[er]
insert into time_format values('25:23:33');


--[H]HMMSS[.msec] 
insert into time_format values('121545');
insert into time_format values('51256');
insert into time_format values('060407.111');
--[er]
insert into time_format values('281256');
insert into time_format values('236123');



--[M]MSS[.msec]
insert into time_format values('518');
insert into time_format values('945.333');
insert into time_format values('1809');
insert into time_format values('2222');
--[er]
insert into time_format values('2845');
--[er]
insert into time_format values('267');



--[S]S[.msec]
insert into time_format values('10');
insert into time_format values('4');
insert into time_format values('59.321');
insert into time_format values('0');
--[er]
insert into time_format values('66');
insert into time_format values('50.1234');


--[er]
insert into time_format values('1232345');
insert into time_format values('6e10');
insert into time_format values('aa109');


select * from time_format order by 1;

drop table time_format;
