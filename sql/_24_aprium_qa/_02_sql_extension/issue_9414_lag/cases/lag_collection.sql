--TEST: test with collection data types and normal syntax


create table lag_coll(
	col1 set(int),
	col2 multiset(char(2)), 
	col3 list(bigint),
	col4 sequence(datetime)
);


insert into lag_coll values({1, 2, 3}, {'a'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into lag_coll values({1, 2, 3}, {'d', 'd', 'd'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into lag_coll values({1, 2, 3}, {'a'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into lag_coll values({1, 2, 3}, {'d', 'd', 'd'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into lag_coll values({1, 2, 3}, {'a'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into lag_coll values({3, 5}, {'d', 'd', 'd'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into lag_coll values({3, 5}, {'a'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into lag_coll values({3, 5}, {'a'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into lag_coll values({3, 5}, {'r', 'r'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into lag_coll values({3}, {'a'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into lag_coll values({3}, {'a'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into lag_coll values({3}, {'r', 'r'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into lag_coll values({2, 4, 6}, {'a'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into lag_coll values({11, 12}, {'a'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into lag_coll values({11, 12}, {'d', 'd', 'd'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into lag_coll values({11, 12}, {'a'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into lag_coll values({11, 12}, {'a'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into lag_coll values({11, 12}, {'r', 'r'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into lag_coll values({11, 12}, {'a'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});
insert into lag_coll values({11, 12}, {'a'}, {12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111'});


--TEST: OVER() clause
--TEST: no alias
select  new.col1, new.col2, lag(new.col1) over() next_v from (select * from lag_coll order by 1,2,3,4 ) new ;
--TEST: with alias
select  col2, col3, lag(col3, 2, {1, 1, 1}) over(order by col3) next_v from lag_coll order by 1;
--TEST: with where clause
select  col3, col4, lag(col4, 3, {'2012-12-12 12:12:12'}) over() next_v from lag_coll where col1 > {1, 2, 3} order by 1;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by set
select  new.col1, new.col2, new.col3, new.col4, lag(new.col2, 3) over(partition by new.col1) next_v from (select * from lag_coll order by 1, 2, 3, 4) new;
--TEST: partition by multiset
select  new.col1, new.col2, new.col3, new.col4, lag(new.col3, 2, {100, 200, 300}) over(partition by new.col2) next_v from (select * from lag_coll order by 1, 2, 3, 4) new;
--TEST: partition by list
select  new.col1, new.col2, new.col3, new.col4, lag(new.col4) over(partition by new.col3) next_v from (select * from lag_coll order by 1, 2, 3, 4) new;
--TEST: partition by sequence
select  new.col1, new.col2, new.col3, new.col4, lag(new.col1, 1, {9, 10, 11}) over(partition by new.col4) next_v from (select * from lag_coll order by 1, 2, 3, 4) new;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, lag(col1, 1, null) over(order by col1) next_v from lag_coll;
--TEST: order by 2 column names
select col2, col3, lag(col2, 10) over(order by col2, col3 asc) next_v from lag_coll;
--TEST: order by more than 2 column names
select col1, col2, col3, col4, lag(col2, 2, {'zz'}) over(order by col1, col2 desc, col3, col4 asc) next_v from lag_coll;
--TEST: order by columns not selected
select col3, lag(col4, 4) over(order by col4 desc, col2, col1 asc) next_v from lag_coll;
--TEST: order by 1 position
select new.col4, lag(new.col1, 10, {11111}) over(order by 1) next_v from (select * from lag_coll order by 1, 2, 3, 4) new;
--TEST: order by 3 positions
select col3, col2, lag(col3, 19, {100000, 2000000}) over(order by 1, 2 desc, 3 asc) next_v from lag_coll;
--TEST: order by more than 3 positions
select col1, col2, col3, col4, lag(col4, 2) over(order by 3, 2 asc, 1 desc, 4) next_v from lag_coll;
--TEST: order by positions not existed
select col2, lag(col1) over(order by 2) next_v from lag_coll;
select col1, lag(col2) over(order by 3, 4, 1 desc) next_v, col2, col4 from lag_coll;
select col3, col4, lag(col3) over(order by 5) next_v from lag_coll;
select col3, col1, lag(col4) over(order by 100) next_v from lag_coll;
--TEST: order by column names and positions
select col1, col2, col3, col4, lag(col2, 11, {'aa', 'bb', 'aa'}) over(order by 1, col2 desc, 3, col4 asc) next_v from lag_coll;




--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by set
select col1, col2, col3, lag(col2) over(partition by col1 order by col1, col2, col3) from lag_coll;
--TEST: partition by multiset
select col2, col4, col1, lag(col4, 2) over(partition by col2 order by col2, col4, col1 desc) from lag_coll;
--TEST: sorting confliction
select col3, lag(col3, 100, {}) over(partition by col3 order by col3 desc) from (select * from lag_coll order by 1, 2, 3, 4) ;
--TEST: partition by sequence
select col4, col2, lag(col2, 2, {'ab'}) over(partition by col4 order by 1, 2 desc) from (select * from lag_coll order by 1,2,3,4);
--TEST: syntax error
select col1, col2, lag(1) over(order by col1, col2 partition by col2) from lag_coll;



drop table lag_coll; 















