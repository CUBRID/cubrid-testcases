--delete from 4 tables with datetime type column for join condition

drop table if exists md1;
drop table if exists md2;
drop table if exists md3;
drop table if exists md4;

create table md1(id1 int primary key, col1 char(10));
insert into md1 values(11, 'aaa'), (22, 'bbb'), (33, 'ccc'), (44, 'ddd'), (55, 'eee'), (66, 'fff'), (77, 'fff'), (88, 'ggg');


create table md2(id2 smallint unique, col1 char(100));
insert into md2 values(33, 'cubrid'), (22, 'aaa'), (88, 'aaa'), (99, 'abcabc'), (55, 'eee'), (100, 'mysql'), (66, 'fff');


create table md3(id3 int primary key, col1 date);
insert into md3 values(11, '2011-09-01'), (33, date'2011-09-02'), (99, '2011-09-03'), (44, '2011-09-04'), (88, '2011-09-04'), (333, '2011-09-05');


create table md4(id4 bigint, col1 date not null);
insert into md4 values(333, '2011-09-02'), (22, '2011-09-04'), (88, '2011-09-08'), (33, '2011-09-04'), (55, '2011-09-10');


select * from md1 order by 1;
select * from md2 order by 1;
select * from md3 order by 1;
select * from md4 order by 1;


--error, false join condition
delete from m1, m2, m3, m4 using md1 m1, md2 m2, md3 m3, md4 m4 where m2.col1=m1.col1 and m1.id1=m3.col1 and m4.col1=m2.col1;


--without table aliases, 4 rows deleted
delete from md1, md2, md3, md4 using md1, md2, md3, md4 where md1.id1=md2.id2 and md1.id1=md3.id3 and md2.id2=md4.id4 and truncate(md1.id1, 2)=truncate(md2.id2, 2) and day(md4.col1)=4;
select if (count(*) = 7, 'ok', 'nok') from md1;
select if (count(*) = 6, 'ok', 'nok') from md2;
select if (count(*) = 5, 'ok', 'nok') from md3;
select if (count(*) = 4, 'ok', 'nok') from md4;


--[er] with table aliases, delete from a derived table
delete from m2, m3 using md1 as m1, md2 m2, (select id3, col1 from (select * from md3 where month(col1)=9) md3) m3, (select id4, date(col1) as col1 from md4) as m4 where m1.id1=m2.id2 and m3.id3=m1.id1 and m4.id4=m2.id2 and m1.id1=33;
select if (count(*) = 7, 'ok', 'nok') from md1;
select if (count(*) = 6, 'ok', 'nok') from md2;
select if (count(*) = 5, 'ok', 'nok') from md3;
select if (count(*) = 4, 'ok', 'nok') from md4;


--inner join, 1 row deleted
delete from m1 
	using md1 as m1 
	inner join (select id2, substr(col1, 1, 6) from md2) m2 on m1.id1=m2.id2 
	inner join (select id3 from md3) m3 on m3.id3=m2.id2 
	inner join md4 as m4 on m4.id4=m1.id1 
	where m1.id1 > (select sum(id2)/5 from md2);
select if (count(*) = 6, 'ok', 'nok') from md1;
select if (count(*) = 6, 'ok', 'nok') from md2;
select if (count(*) = 5, 'ok', 'nok') from md3;
select if (count(*) = 4, 'ok', 'nok') from md4;

--left outer join
--success, 2 rows deleted
delete from m1, m2, m3
        using md2 m2
        left outer join md1 m1 on m1.id1=m2.id2 
        left outer join md3 m3 on m3.id3=m2.id2
        inner join md4 m4 on m4.id4=m3.id3
        where m3.id3 > (select max(id4)/10 from md4);
select if (count(*) = 6, 'ok', 'nok') from md1;
select if (count(*) = 5, 'ok', 'nok') from md2;
select if (count(*) = 4, 'ok', 'nok') from md3;
select if (count(*) = 4, 'ok', 'nok') from md4;


--right outer join
--error, delete from a derived table
delete from m2, m1, m4, m3 
	using md1 m1 
	left outer join md2 m2 on m1.id1=m2.id2
	right outer join (select * from md3) m3 on m3.id3=m2.id2 
	right outer join md4 m4 on m4.id4=m3.id3
	where m3.id3 is null;
--success, 3 rows deleted
delete from m2, m1, m4, m3
        using md1 m1 
        left outer join md2 m2 on m1.id1=m2.id2
        right outer join md3 m3 on m3.id3=m2.id2   
        right outer join md4 m4 on m4.id4=m3.id3
        where m3.id3 is null;
select if (count(*) = 6, 'ok', 'nok') from md1;
select if (count(*) = 5, 'ok', 'nok') from md2;
select if (count(*) = 4, 'ok', 'nok') from md3;
select if (count(*) = 1, 'ok', 'nok') from md4;



drop table md1, md2, md3, md4;






