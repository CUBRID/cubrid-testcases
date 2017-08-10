--test valid datetime format of string type with implicit conversion


create table datetime_format(col1 datetime);


insert into datetime_format values('2010-09-10');
insert into datetime_format values('2010-10-10 12:34:45.12');
insert into datetime_format values('16:23:11');
insert into datetime_format values('22:12:22.12');

insert into datetime_format values('11/10/2010');
insert into datetime_format values('11/10/2010 15:3:34.321');
insert into datetime_format values('11/10/66');
insert into datetime_format values('9/23/12 3:23:2.400');

insert into datetime_format values('100101');
insert into datetime_format values('20101110');
insert into datetime_format values('19890807131215.111');
insert into datetime_format values('660917080312.456');

--[er]
insert into datetime_format values('10000-12-12 1:1:1.9999');
insert into datetime_format values('99/10/12 32:34:34.10101');
insert into datetime_format values('abcde');
insert into datetime_format values('18191028282822');


select * from datetime_format order by 1;

drop table datetime_format;
