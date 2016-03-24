--test valid datetime format of string type with expicit conversion


select cast('2010-09-10' as datetime);
select cast('2010-10-10 12:34:45.12' as datetime);
select cast('16:23:11' as datetime);
select cast('22:12:22.12' as datetime);

select cast('11/10/2010' as datetime);
select cast('11/10/2010 15:3:34.321' as datetime);
select cast('11/10/66' as datetime);
select cast('9/23/12 3:23:2.400' as datetime);

select cast('100101' as datetime);
select cast('20101110' as datetime);
select cast('19890807131215.111' as datetime);
select cast('660917080312.456' as datetime);

--[er]
select cast('10000-12-12 1:1:1.9999' as datetime);
select cast('99/10/12 32:34:34.10101' as datetime);
select cast('abcde' as datetime);
select cast('18191028282822' as datetime);
