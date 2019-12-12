--update 4 tables with datetime type column for join condition



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


--TEST: error, false join condition
update md1 m1, md2 m2, md3 m3, md4 m4 set m1.col1=m2.col1, m3.col1=m4.col1 where m2.col1=m1.col1 and m1.id1=m3.col1 and m4.col1=m2.col1;


--TEST: without table aliases, 4 rows updated
update md1, md2, md3, md4 set md1.col1='updated1', md2.col1=md1.col1, md3.col1=md4.col1, md4.col1=md3.col1 where md1.id1=md2.id2 and md1.id1=md3.id3 and md2.id2=md4.id4 and truncate(md1.id1, 2)=truncate(md2.id2, 2) and day(md4.col1)=4;
--TEST: check update result
select if (col1 = 'updated1', 'ok', 'nok') from md1 where id1=33;
select if (col1 = 'ccc', 'ok', 'nok') from md2 where id2=33;
select if (col1 = '2011-09-04', 'ok', 'nok') from md3 where id3=33;
select if (col1 = '2011-09-02', 'ok', 'nok') from md4 where id4=33;


--TEST: with table aliases, 2 rows updated
update md1 as m1, md2 m2, (select id3, col1 from (select * from md3 where month(col1)=9) md3) m3, (select id4, date(col1) as col1 from md4) as m4 set m2.col1='updated2', m1.col1=m2.col1 where m1.id1=m2.id2 and m3.id3=m1.id1 and m4.id4=m2.id2 and m1.id1=33;
--TEST: check update result
select if (col1 = 'ccc', 'ok', 'nok') from md1 where id1=33;
select if (col1 = 'updated2', 'ok', 'nok') from md2 where id2=33;


--TEST: inner join, 1 row updated
update md1 as m1 
	inner join (select id2, substr(col1, 1, 6) from md2) m2 on m1.id1=m2.id2 
	inner join (select id3 from md3) m3 on m3.id3=m2.id2 
	inner join md4 as m4 on m4.id4=m1.id1 
	set m1.id1=m2.id2+m3.id3+m4.id4, m1.col1=m4.col1
	where m1.id1 > (select sum(id2)/10 from md2);
--TEST: check update result
select if (length(col1) > 5, 'ok', 'nok') from md1 where id1 > 100;


--TEST: left outer join
--TEST: error, multiple assignments to one column
update md2 m2 
	left outer join md1 m1 on m1.id1=m2.id2 
	left outer join md3 m3 on m3.id3=m2.id2
	inner join md4 m4 on m4.id4=m3.id3
	set m4.id4=m1.id1*m2.id2*m3.id3, m4.col1='updated3', m4.col1=null 
	where m3.id3 > (select max(id4)/10 from md4 m4);
--TEST: set a column twice, set invalid value, 5 rows updated in mysql
update md2 m2
        left outer join md1 m1 on m1.id1=m2.id2 
        left outer join md3 m3 on m3.id3=m2.id2
        inner join md4 m4 on m4.id4=m3.id3
	set m2.col1=m1.col1, m3.col1=m4.col1, m1.col1='updated3', m4.id4=m1.id1*m2.id2*m3.id3, m4.col1=adddate(m3.col1, -1) 
        where m3.id3 < (select max(id4) from md4);
--TEST: check update result
select if (col1 = 'updated3', 'ok', 'nok') from md1 where id1=33;
select if (col1 = 'ccc', 'ok', 'nok') from md2 where id2=33;
select if (col1 in ('2011-09-02', '2011-09-08'), 'ok', 'nok') from md3 where id3 in (33, 88);
select if (col1 = '2011-09-03', 'ok', 'nok') from md4 where id4 in (35937, null);


--TEST: right outer join
--TEST: error, update a derived table
update md1 m1 
	left outer join md2 m2 on m1.id1=m2.id2
	right outer join (select * from md3) m3 on m3.id3=m2.id2 
	right outer join md4 m4 on m4.id4=m3.id3
	set m3.col1='updated4', m2.id2=m4.id4*m2.id2
	where m3.id3 is null;
--TEST: error, not null error
update md1 m1 
        left outer join md2 m2 on m1.id1=m2.id2
        right outer join md3 m3 on m3.id3=m2.id2   
        right outer join md4 m4 on m4.id4=m3.id3
	set m1.id1=m4.id4, m2.col1='updated4', m3.col1=m4.col1, m4.col1=m1.col1
        where m3.id3 is null;
select if (count(*) >= 1, 'nok', 'ok') from md4 where col1 is null;



drop table md1, md2, md3, md4;






