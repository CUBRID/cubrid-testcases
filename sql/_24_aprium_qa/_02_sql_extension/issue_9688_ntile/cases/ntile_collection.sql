--TEST: test with collection data types and normal syntax


create table ntile_coll(
	col1 set(int),
	col2 multiset(char(2)), 
	col3 list(bigint),
	col4 sequence(datetime)
);


insert into ntile_coll values({1, 2, 3}, {'a'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into ntile_coll values({1, 2, 3}, {'d', 'd', 'd'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into ntile_coll values({1, 2, 3}, {'a'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into ntile_coll values({1, 2, 3}, {'d', 'd', 'd'}, {'1993-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into ntile_coll values({1, 2, 3}, {'a'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into ntile_coll values({3, 5}, {'d', 'd', 'd'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into ntile_coll values({3, 5}, {'a'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into ntile_coll values({3, 5}, {'a'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into ntile_coll values({3, 5}, {'r', 'r'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into ntile_coll values({3}, {'a'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into ntile_coll values({3}, {'a'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into ntile_coll values({3}, {'r', 'r'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into ntile_coll values({2, 4, 6}, {'a'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into ntile_coll values({11, 12}, {'a'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into ntile_coll values({11, 12}, {'d', 'd', 'd'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into ntile_coll values({11, 12}, {'a'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into ntile_coll values({11, 12}, {'a'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into ntile_coll values({11, 12}, {'r', 'r'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into ntile_coll values({11, 12}, {'a'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into ntile_coll values({11, 12}, {'a'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});


--TEST: OVER() clause
--TEST: no alias
select  new.col1, new.col2, ntile(8) over() b_num from (select * from ntile_coll order by 1,2,3,4) new order by 1;
--TEST: with alias
select  new.col2, new.col3, ntile(5) over() b_num from (select * from ntile_coll order by 1,2,3,4) new order by 1;
--TEST: with where clause
select  col3, col4, ntile(9) over() b_num from ntile_coll where col1 > {1, 2, 3} order by 1;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by set
select  col1, col2, col3, col4, ntile(1) over(partition by col1) b_num from ntile_coll order by 1, 2, 3, 4;
--TEST: partition by multiset
select  new.col1, new.col2, new.col3, new.col4, ntile(2) over(partition by new.col2) b_num from (select * from ntile_coll order by 1,2,3,4) new order by 1, 2, 3, 4;
--TEST: partition by list
select  new.col1, new.col2, new.col3, new.col4, ntile(3) over(partition by new.col3) b_num from (select * from ntile_coll order by 1,2,3,4) new order by 1, 2, 3, 4;
--TEST: partition by sequence
select  new.col1, new.col2, new.col3, new.col4, ntile(4) over(partition by new.col4) b_num from (select * from ntile_coll order by 1,2,3,4) new order by 1, 2, 3, 4;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, ntile(10) over(order by col1) b_num from ntile_coll;
--TEST: order by 2 column names
select col2, col3, ntile(11) over(order by col2, col3 asc) b_num from ntile_coll;
--TEST: order by more than 2 column names
select col1, col2, col3, col4, ntile(4) over(order by col1, col2 desc, col3, col4 asc) b_num from ntile_coll;
--TEST: order by columns not selected
select col3, ntile(14) over(order by col4 desc, col2, col1 asc) b_num from ntile_coll;
--TEST: order by 1 position
select col4, ntile(3) over(order by 1) b_num from ntile_coll;
--TEST: order by 3 positions
select col3, col2, ntile(13) over(order by 1, 2 desc, 3 asc) b_num from ntile_coll;
--TEST: order by more than 3 positions
select col1, col2, col3, col4, ntile(7) over(order by 3, 2 asc, 1 desc, 4) b_num from ntile_coll;
--TEST: order by positions not existed
select col2, ntile(1) over(order by 2) b_num from ntile_coll;
select col1, ntile(2) over(order by 3, 4, 1 desc) b_num, col2, col4 from ntile_coll;
select col3, col4, ntile(3) over(order by 5) b_num from ntile_coll;
select col3, col1, ntile(4) over(order by 100) b_num from ntile_coll;
--TEST: order by column names and positions
select col1, col2, col3, col4, ntile(8) over(order by 1, col2 desc, 3, col4 asc) b_num from ntile_coll;




--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by set
select col1, col2, col3, ntile(5) over(partition by col1 order by col1, col2, col3) from ntile_coll;
--TEST: partition by multiset
select col2, col4, col1, ntile(4) over(partition by col2 order by col2, col4, col1 desc) from ntile_coll;
--TEST: sorting confliction
select new.col3, ntile(3) over(partition by new.col3 order by new.col3 desc) b_num, new.col2 from (select * from ntile_coll order by 1,2,3,4) new;
--TEST: partition by sequence
select col4, col1, ntile(2) over(partition by col4 order by 1, 2 desc) b_num from ntile_coll;
--TEST: syntax error
select col1, col2, ntile(1) over(order by col1, col2 partition by col2) from ntile_coll;



drop table ntile_coll; 















