--combination with group by ... having clause


create table max_groupby(
	col1 int auto_increment primary key,
	col2 smallint,
	col3 char(30) default 'abc',
	col4 date default SYSDATE,
	col5 clob,
	col6 monetary
);


insert into max_groupby(col2, col3, col4, col5, col6) values(500, 'cubrid', '1990-10-10', 'aello@domainname.com', 123.12);
insert into max_groupby(col2, col3, col4, col5, col6) values(500, 'cubrid', '1990-11-10', 'bello@domainname.com', 123.22);
insert into max_groupby(col2, col3, col4, col5, col6) values(500, 'mysql', '1990-10-11', 'cello@domainname.com', 123.33);
insert into max_groupby(col2, col3, col4, col5, col6) values(500, 'cubrid', '1990-10-10', 'dello@domainname.com', 123.44);
insert into max_groupby(col2, col3, col4, col5, col6) values(500, 'cubrid', '1991-10-10', 'eello@domainname.com', 123.55);
insert into max_groupby(col2, col3, col4, col5, col6) values(501, 'oracle', '1990-10-10', 'fello@domainname.com', 123.55);
insert into max_groupby(col2, col3, col4, col5, col6) values(501, 'cubrid', '1992-10-10', 'gello@domainname.com', 123.66);
insert into max_groupby(col2, col3, col4, col5, col6) values(501, 'oracle', '1990-11-10', 'hello@domainname.com', 123.77);
insert into max_groupby(col2, col3, col4, col5, col6) values(501, 'mysql', '1990-10-10', 'iello@domainname.com', 123.88);
insert into max_groupby(col2, col3, col4, col5, col6) values(501, 'cubrid', '1990-10-10', 'jello@domainname.com', 888.11);
insert into max_groupby(col2, col3, col4, col5, col6) values(501, 'mysql', '1991-11-10', 'kello@domainname.com', 444.11);
insert into max_groupby(col2, col3, col4, col5, col6) values(502, 'cubrid', '1990-10-10', 'lello@domainname.com', 555.33);
insert into max_groupby(col2, col3, col4, col5, col6) values(502, 'mysql', '1990-10-10', 'mello@domainname.com', 888.55);
insert into max_groupby(col2, col3, col4, col5, col6) values(502, 'mysql', '1992-10-10', 'nello@domainname.com', 292.14);
insert into max_groupby(col2, col3, col4, col5, col6) values(503, 'mysql', '1992-10-10', 'oello@domainname.com', 928.45);
insert into max_groupby(col2, col3, col4, col5, col6) values(503, 'cubrid', '1990-10-10', 'pello@domainname.com', 2902.123);
insert into max_groupby(col2, col3, col4, col5, col6) values(503, 'cubrid', '1990-10-10', 'qello@domainname.com', 1231.54);
insert into max_groupby(col2, col3, col4, col5, col6) values(503, 'oracle', '1993-11-10', 'rello@domainname.com', 888.234);
insert into max_groupby(col2, col3, col4, col5, col6) values(503, 'oracle', '1993-10-10', 'sello@domainname.com', 123.555);
insert into max_groupby(col2, col3, col4, col5, col6) values(503, 'cubrid', '1993-11-10', 'tello@domainname.com', 222.22);
insert into max_groupby(col2, col3, col4, col5, col6) values(503, 'cubrid', '1992-10-10', 'uello@domainname.com', 222.22);
insert into max_groupby(col2, col3, col4, col5, col6) values(504, 'mysql', '1994-10-10', 'vello@domainname.com', 11.1111);
insert into max_groupby(col2, col3, col4, col5, col6) values(504, 'mysql', '1990-10-10', null, 322.111);
insert into max_groupby(col2, col3, col4, col5, col6) values(504, 'cubrid', '1995-11-10', 'wello@domainname.com', 9999.99);
insert into max_groupby(col2, col3, col4, col5, col6) values(505, 'cubrid', '1991-10-10', '', 123.33);
insert into max_groupby(col2, col3, col4, col5, col6) values(505, 'cubrid', '1996-10-10', 'xello@domainname.com', 555.434);
insert into max_groupby(col2, col3, col4, col5, col6) values(505, 'mysql', '1990-10-10', 'yello@domainname.com', 949.22);
insert into max_groupby(col2, col3, col4, col5, col6) values(505, 'cubrid', '1995-10-10', null, 191.33);
insert into max_groupby(col2, col3, col4, col5, col6) values(505, 'cubrid', '1990-10-10', 'zello@domainname.com', 5435.22);



--TEST: over() clause + group by
select col1, max(col1) over() maximum from max_groupby group by col1;
select col2, max(col2) over() maximum from max_groupby group by col2;
select col1, col2, max(col3) over() maximum from max_groupby group by col1;
select col1, col2, max(unique col4) over() maximum, col3 from max_groupby group by col2;
select col1, col2, max(unique clob_to_char(col5)) over() maximum from max_groupby group by col1, col2;


--TEST: over(partition by) clause + group by
select col3, max(all col6) over(partition by col3) maximum from max_groupby group by col3;
select col4, max(col1) over(partition by col4) maximum from max_groupby group by col4;
select col3, col4, max(unique col2) over(partition by col4) maximum from max_groupby group by col4;
select col3, col4, max(distinct col3) over(partition by col3) maximum from max_groupby group by col3, col4;
select col3, col4, clob_to_char(col5), max(col6) over(partition by col4) maximum from max_groupby group by col3, col4;


--TEST: over(order by) clause + group by
select col1, max(col4) over(order by col1) maximum from max_groupby group by col1;
select col2, max(all col2) over(order by col2) maximum from max_groupby group by col2;
select col1, col2, max(unique col3) over(order by col1) maximum from max_groupby group by col1;
select col1, col2, max(unique col4) over(order by col1, col2) maximum, col3 from max_groupby group by col2;
select col1, col2, max(distinct col1) over(order by col2) maximum from max_groupby group by col1, col2;


--TEST: over(partition by.. order by ..) clause + group by
select col3, max(col6) over(partition by col3 order by col3) maximum from max_groupby group by col3;
select col4, max(all col1) over(partition by col4 order by col4) maximum from max_groupby group by col4;
select col3, col4, max(unique col2) over(partition by col4 order by col3) maximum from max_groupby group by col4;
select col3, col4, max(unique col3) over(partition by col3 order by col4) maximum from max_groupby group by col3, col4;
select col3, col4, clob_to_char(col5), max(all clob_to_char(col5)) over(partition by col4 order by col3) maximum from max_groupby group by col3, col4;


--TEST: over(partition by.. order by ..) clause + group by ... having ...
select col1, max(col1) over(partition by col1 order by col1) maximum from max_groupby group by col1 having col1 > 500;
select col4, max(col2) over(partition by col4 order by col4) maximum from max_groupby group by col4 having right(clob_to_char(col5), 4) =  '.com';
select col1, col2, col3, col4, clob_to_char(col5), max(col6) over(partition by col3 order by col1) maximum from max_groupby group by col1, col2, col3, col4 having col2 in ('cubrid', 'mysql') and right(clob_to_char(col5), 12) = '@domainname.com';
 



delete from max_groupby;
drop table max_groupby;


