--test valid timestamp format of string type with expicit conversion


select cast('2010-09-10' as timestamp);
select cast('2010-10-10 12:34:45' as timestamp);
select cast('16:23:11' as timestamp);
select cast('22:12:22.12' as timestamp);

select cast('11/10/2010' as timestamp);
select cast('11/10/2010 15:3:34' as timestamp);
select cast('11/10/66' as timestamp);
select cast('9/23/12 3:23:2' as timestamp);

select cast('100101' as timestamp);
select cast('20101110' as timestamp);
select cast('19890807131215' as timestamp);
select cast('660917080312' as timestamp);

--[er]
select cast('10000-12-12 1:1:1' as timestamp);
select cast('99/10/12 32:34:34' as timestamp);
select cast('abcde' as timestamp);
select cast('18191028282822' as timestamp);
