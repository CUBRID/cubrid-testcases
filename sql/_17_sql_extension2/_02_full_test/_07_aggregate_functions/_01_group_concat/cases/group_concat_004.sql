--multiple expressions



create table goo (
	col1 char(20),
	col2 varchar(30),
	col3 nchar(20),
	col4 nchar varying(20),
	col5 string,
	col6 bit(20),
	col7 bit varying(20),
	col8 integer,
	col9 smallint,
	col10 bigint, 
	col11 decimal,
	col12 real,
	col13 double precision,
	col14 monetary,
	col15 date,
	col16 time,
	col17 timestamp,
	col18 datetime
);


insert into goo values('a', 'b', 'c', 'd', 'e', 
			1, 2, 3, 4.4, 5.55, 6.666, 7, 
			date'1999-10-01', time'10:10:10', timestamp'1999-10-01 10:10:10', datetime'10:10:10:100 am 10/01/1999');
insert into goo values('aa', 'bb', 'cc', 'dd', 'ee', 
			11, 22, 33, 44.4, 55.55, 66.666, 77, 
			date'1999-10-02', time'10:10:11', timestamp'1999-10-02 10:10:11', datetime'10:10:11:100 am 10/02/1999');
insert into goo values('aaa', 'bbb', 'ccc', 'ddd', 'eee', 
			111, 222, 333, 444.4, 555.55, 666.666, 777, 
			date'1999-10-03', time'10:10:12', timestamp'1999-10-03 10:10:12', datetime'10:10:12:100 am 10/03/1999');
insert into goo values('aaaa', 'bbbb', 'cccc', 'dddd', 'eeee', 
			1111, 2222, 3333, 4444.4, 5555.55, 6666.666, 7777, 
			date'1999-10-04', time'10:10:13', timestamp'1999-10-04 10:10:13', datetime'10:10:13:100 am 10/04/1999');


select group_concat(col1, col2, col3 order by 1) from goo order by 1;
select group_concat(col6, col7 order by 1) from goo order by 1;
select group_concat(col8, col9, col10, col11, col12 order by 1) from goo order by 1;
select group_concat(col13, col14 order by 1) from goo order by 1;
select group_concat(col15, col16 order by 1) from goo order by 1;
select group_concat(col17, col18 order by 1) from goo order by 1;
select group_concat(col1, col6 order by 1) from goo order by 1;
select group_concat(col1, col7, col15 order by 1) from goo order by 1;
select group_concat(col7, col18 order by 1) from goo order by 1;
select group_concat(col4, col8, col12, col17 order by 1) from goo order by 1;


drop table goo;
