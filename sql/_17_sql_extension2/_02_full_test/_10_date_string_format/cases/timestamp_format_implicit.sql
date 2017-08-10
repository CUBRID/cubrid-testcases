--test valid timestamp format of string type with implicit conversion


create table timestamp_format(col1 timestamp);

insert into timestamp_format values('2010-09-10');
insert into timestamp_format values('2010-10-10 12:34:45');
insert into timestamp_format values('16:23:11');
insert into timestamp_format values('22:12:22.12');

insert into timestamp_format values('11/10/2010');
insert into timestamp_format values('11/10/2010 15:3:34');
insert into timestamp_format values('11/10/66');
insert into timestamp_format values('9/23/12 3:23:2');

insert into timestamp_format values('100101');
insert into timestamp_format values('20101110');
insert into timestamp_format values('19890807131215');
insert into timestamp_format values('660917080312');

--[er]
insert into timestamp_format values('10000-12-12 1:1:1');
insert into timestamp_format values('99/10/12 32:34:34');
insert into timestamp_format values('abcde');
insert into timestamp_format values('18191028282822');


select * from timestamp_format order by 1;


drop table timestamp_format;
