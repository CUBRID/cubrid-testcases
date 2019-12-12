--TEST: pass collection type values to the second param

drop table if exists p_cont;
create table p_cont(
	col1 set(int),
	col2 multiset(smallint), 
	col3 list(timestamp),
	col4 sequence(datetime),
	num smallint
);

insert into p_cont values({1, 2, 3}, {1, 1, 3}, {'1990-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 100);
insert into p_cont values({1, 2, 3}, {4, 4}, {'1991-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 60);
insert into p_cont values({1, 2, 3}, {1, 1, 3}, {'1992-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 70);
insert into p_cont values({1, 2, 3}, {4, 4}, {'1993-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 60);
insert into p_cont values({1, 2, 3}, {1, 1, 3}, {'1994-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 50);
insert into p_cont values({3, 5}, {4, 4}, {'1995-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 60);
insert into p_cont values({3, 5}, {1, 1, 3}, {'1996-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 70);
insert into p_cont values({3, 5}, {1, 1, 3}, {'1997-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 60);
insert into p_cont values({3, 5}, {8, 10}, {'1998-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 60);
insert into p_cont values({7, 9}, {1, 1, 3}, {'1999-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 70);
insert into p_cont values({7, 9}, {1, 1, 3}, {'2000-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 65);
insert into p_cont values({7, 9}, {8, 10}, {'2001-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 60);
insert into p_cont values({9, 11, 13}, {1, 1, 3}, {'2002-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 60);
insert into p_cont values({11, 12, 15}, {1, 1, 3}, {'2003-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 80);
insert into p_cont values({11, 12, 15}, {4, 4}, {'2004-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 70);
insert into p_cont values({11, 12, 15}, {1, 1, 3}, {'2005-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 85);
insert into p_cont values({11, 12, 15}, {1, 1, 3}, {'2006-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 60);
insert into p_cont values({11, 12, 15}, {8, 10}, {'2007-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 90);
insert into p_cont values({11, 12, 15}, {1, 1, 3}, {'2008-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 60);
insert into p_cont values({11, 12, 15}, {1, 1, 3}, {'2009-1-1 11:11:11'}, {datetime'2011-11-11 11:11:11.111'}, 63);

--test: pass constant collection values to the second param
select col1, percentile_cont(0.5) within group(order by {0.5}) from p_cont group by col1 order by 1, 2;
select col1, percentile_cont(1) within group(order by {'1'}) from p_cont group by col1 order by 1, 2;
select col1, percentile_cont(0.9) within group(order by {time'12:12:12'}) from p_cont group by col1 order by 1, 2;
select col1, percentile_cont(0) within group(order by {date'2009-12-12'}) from p_cont group by col1 order by 1, 2;

--test: pass collection type columns to the second param
select col1, percentile_cont(0.5) within group(order by col1) from p_cont group by col1 order by 1, 2;
select col1, percentile_cont(0.5) within group(order by col2) from p_cont group by col1 order by 1, 2;
select col1, percentile_cont(0.5) within group(order by col3) from p_cont group by col1 order by 1, 2;
select col1, percentile_cont(0.5) within group(order by col4) from p_cont group by col1 order by 1, 2;

--test: [er] pass more than 1 columns to the second param
select col2, percentile_cont(0.5) within group(order by col1, col3) from p_cont group by col2 order by 1, 2;
select col2, percentile_cont(0.1) within group(order by col2, col4, col1) from p_cont group by col2 order by 1, 2;
select col2, col3, col4, percentile_cont(0.8) within group(order by 3, 2, 1) from p_cont group by col2, col3, col4 order by 1, 2;


drop table p_cont;

