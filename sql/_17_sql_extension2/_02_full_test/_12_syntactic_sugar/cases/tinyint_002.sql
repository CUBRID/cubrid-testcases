--insert unmatched types of values into a tinyint column


create table tiny_int(col1 tinyint);

--[er]
insert into tiny_int values('aaabbb');
--[er]
insert into tiny_int values(date'2010-11-12');
--[er]
insert into tiny_int values(time'20:56:45');
--[er] 
insert into tiny_int values(timestamp'11/11/11 15:29:34');
--[er]
insert into tiny_int values(datetime'11/11/11 15:29:34.333');
--[er]
insert into tiny_int values(B'1010111');
--[er]
insert into tiny_int values(N'abcd');
--[er]
insert into tiny_int values({1,24,3,76});


select * from tiny_int;

drop table tiny_int;





