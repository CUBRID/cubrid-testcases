--TEST: test with reuse_oid tables 

drop table if exists p_disc_collection;
create table p_disc_collection(
        col1 set(int),
        col2 multiset(smallint),
        col3 list(timestamp),
        col4 sequence(datetime),
        num smallint
);

insert into p_disc_collection values({1, 2, 3}, {1, 1, 3}, {'1990-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 100);
insert into p_disc_collection values({1, 2, 3}, {4, 4}, {'1991-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 60);
insert into p_disc_collection values({1, 2, 3}, {1, 1, 3}, {'1992-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 70);
insert into p_disc_collection values({1, 2, 3}, {4, 4}, {'1993-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 60);
insert into p_disc_collection values({1, 2, 3}, {1, 1, 3}, {'1994-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 50);
insert into p_disc_collection values({3, 5}, {4, 4}, {'1995-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 60);
insert into p_disc_collection values({3, 5}, {1, 1, 3}, {'1996-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 70);
insert into p_disc_collection values({3, 5}, {1, 1, 3}, {'1997-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 60);
insert into p_disc_collection values({3, 5}, {8, 10}, {'1998-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 60);
insert into p_disc_collection values({7, 9}, {1, 1, 3}, {'1999-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 70);
insert into p_disc_collection values({7, 9}, {1, 1, 3}, {'2000-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 65);
insert into p_disc_collection values({7, 9}, {8, 10}, {'2001-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 60);
insert into p_disc_collection values({9, 11, 13}, {1, 1, 3}, {'2002-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 60);
insert into p_disc_collection values({11, 12, 15}, {1, 1, 3}, {'2003-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 80);
insert into p_disc_collection values({11, 12, 15}, {4, 4}, {'2004-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 70);
insert into p_disc_collection values({11, 12, 15}, {1, 1, 3}, {'2005-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 85);
insert into p_disc_collection values({11, 12, 15}, {1, 1, 3}, {'2006-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 60);
insert into p_disc_collection values({11, 12, 15}, {8, 10}, {'2007-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 90);
insert into p_disc_collection values({11, 12, 15}, {1, 1, 3}, {'2008-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 60);
insert into p_disc_collection values({11, 12, 15}, {1, 1, 3}, {'2009-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 63);


--TEST: OVER() clause
--TEST: set 
select  col1, col2, percentile_disc(0.333333) within group (order by col1) over() p_disc from p_disc_collection order by 1, 2, 3;
--TEST: multiset
select  col2, col3, percentile_disc(0.77) within group (order by col2) over() p_disc from p_disc_collection order by 1, 2, 3;
--TEST: list with where clause
select  col3, col4, percentile_disc(0.89) within group (order by col3) over() p_disc from p_disc_collection where col1 > {1, 2, 3} order by 1, 2, 3;
--TEST: sequence
select  col4, col1, percentile_disc(0.21) within group (order by col4) over() p_disc from p_disc_collection order by 1, 2, 3;
--TEST: wrong type of arguments
select percentile_disc(col1) within group (order by num) over() from p_disc_collection;
select percentile_disc(col2) within group (order by num) over() from p_disc_collection;
select percentile_disc(col3) within group (order by num) over() from p_disc_collection;
select percentile_disc(col4) within group (order by num) over() from p_disc_collection;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by set
select col1, col2, col3, col4, percentile_disc(0.3) within group (order by num desc) over(partition by col1) p_disc from p_disc_collection order by 1, 2, 3, 4;
--TEST: partition by multiset
select col1, col2, col3, col4, percentile_disc(0.9) within group (order by num) over(partition by col2) p_disc from p_disc_collection order by 2, 1, 3, 4;
--TEST: partition by list
select col1, col2, col3, col4, percentile_disc(0.6) within group (order by num asc) over(partition by col3) p_disc from p_disc_collection order by 3, 1, 2, 4;
--TEST: partition by sequence
select col1, col2, col3, col4, percentile_disc(1) within group (order by num) over(partition by col4) p_disc from p_disc_collection order by 4, 1, 2, 3, 5;


--TEST: [er] OVER(ORDER BY) clause
select col1, percentile_disc(0.3) within group (order by num) over(order by col3) from p_disc_collection order by 1, 2, 3;


--TEST: [er] OVER(PARTITION BY ORDER BY) clause
select col1, col2, col3, percentile_disc(0.7) within group (order by num desc) over(partition by col1 order by col1, col2, col3) from p_disc_collection;


--TEST: [er] out-of-range
select percentile_disc(-10) within group (order by num) over(partition by col2) from p_disc_collection;
select percentile_disc(2) within group (order by num) over(partition by col1, col3) from p_disc_collection;
select percentile_disc(100) within group (order by num desc) over(partition by col4) from p_disc_collection;



drop table p_disc_collection; 















