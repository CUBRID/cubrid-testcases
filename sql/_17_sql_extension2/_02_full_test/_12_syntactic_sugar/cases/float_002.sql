--insert unmatched types of values into a float column with precision and scale


create table float_scale(col1 float(20,8));

--[er]
insert into float_scale values('aaabbb');
--[er]
insert into float_scale values(date'2010-11-12');
--[er]
insert into float_scale values(time'20:56:45');
--[er] 
insert into float_scale values(timestamp'11/11/11 15:29:34');
--[er]
insert into float_scale values(datetime'11/11/11 15:29:34.333');
--[er]
insert into float_scaleo values(B'1010111');
--[er]
insert into float_scaleo values(N'abcd');
--[er]
insert into float_scaleo values({1,24,3,76}});


select * from float_scale;

drop table float_scale;





