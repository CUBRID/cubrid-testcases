--test seperators in date format with implicit conversion


create table date_seperator(col1 date);

insert into date_seperator values('2010-11-10');
insert into date_seperator values('11/11/2010');

--[er]
insert into date_seperator values('2010|11|10');
--[er]
insert into date_seperator values('11|10|2010');
--[er]
insert into date_seperator values('2010@11@10');
--[er]
insert into date_seperator values('11@10@2010');
--[er]
insert into date_seperator values('2010\11\10');
--[er]
insert into date_seperator values('11\10\2010');
--[er]
insert into date_seperator values('2010+11+10');
--[er]
insert into date_seperator values('11+10+2010');
--[er]
insert into date_seperator values('2010:11:10');
--[er]
insert into date_seperator values('11:10:2010');


select * from date_seperator order by 1;

drop table date_seperator;
