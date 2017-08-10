--insert unmatched types of values into a mediumint column


create table medium_int(col1 mediumint);

--[er]
insert into medium_int values('aaabbb');
--[er]
insert into medium_int values(date'2010-11-12');
--[er]
insert into medium_int values(time'20:56:45');
--[er] 
insert into medium_int values(timestamp'11/11/11 15:29:34');
--[er]
insert into medium_int values(datetime'11/11/11 15:29:34.333');
--[er]
insert into medium_int values(B'1010111');
--[er]
insert into medium_int values(N'abcd');
--[er]
insert into medium_int values({1,24,3,76});


select * from medium_int;

drop table medium_int;





