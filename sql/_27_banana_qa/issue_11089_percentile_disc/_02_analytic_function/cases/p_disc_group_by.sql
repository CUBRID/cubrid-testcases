--combination with group by ... having clause

drop table if exists p_disc_groupby;
create table p_disc_groupby(
	col1 int auto_increment primary key,
	col2 smallint,
	col3 char(30) default 'abc',
	col4 date default SYSDATE,
	col5 varchar(30),
	col6 float
);


insert into p_disc_groupby(col2, col3, col4, col5, col6) values(500, 'cubrid', '1990-10-10', 'aello@domainname.com', 123.12);
insert into p_disc_groupby(col2, col3, col4, col5, col6) values(500, 'cubrid', '1990-11-10', 'bello@domainname.com', 123.22);
insert into p_disc_groupby(col2, col3, col4, col5, col6) values(500, 'mysql', '1990-10-11', 'cello@domainname.com', 123.33);
insert into p_disc_groupby(col2, col3, col4, col5, col6) values(500, 'cubrid', '1990-10-10', 'dello@domainname.com', 123.44);
insert into p_disc_groupby(col2, col3, col4, col5, col6) values(500, 'cubrid', '1991-10-10', 'eello@domainname.com', 123.55);
insert into p_disc_groupby(col2, col3, col4, col5, col6) values(501, 'oracle', '1990-10-10', 'fello@domainname.com', 123.55);
insert into p_disc_groupby(col2, col3, col4, col5, col6) values(501, 'cubrid', '1992-10-10', 'gello@domainname.com', 123.66);
insert into p_disc_groupby(col2, col3, col4, col5, col6) values(501, 'oracle', '1990-11-10', 'hello@domainname.com', 123.77);
insert into p_disc_groupby(col2, col3, col4, col5, col6) values(501, 'mysql', '1990-10-10', 'iello@domainname.com', 123.88);
insert into p_disc_groupby(col2, col3, col4, col5, col6) values(501, 'cubrid', '1990-10-10', 'jello@domainname.com', 888.11);
insert into p_disc_groupby(col2, col3, col4, col5, col6) values(501, 'mysql', '1991-11-10', 'kello@domainname.com', 444.11);
insert into p_disc_groupby(col2, col3, col4, col5, col6) values(502, 'cubrid', '1990-10-10', 'lello@domainname.com', 555.33);
insert into p_disc_groupby(col2, col3, col4, col5, col6) values(502, 'mysql', '1990-10-10', 'mello@domainname.com', 888.55);
insert into p_disc_groupby(col2, col3, col4, col5, col6) values(502, 'mysql', '1992-10-10', 'nello@domainname.com', 292.14);
insert into p_disc_groupby(col2, col3, col4, col5, col6) values(503, 'mysql', '1992-10-10', 'oello@domainname.com', 928.45);
insert into p_disc_groupby(col2, col3, col4, col5, col6) values(503, 'cubrid', '1990-10-10', 'pello@domainname.com', 2902.123);
insert into p_disc_groupby(col2, col3, col4, col5, col6) values(503, 'cubrid', '1990-10-10', 'qello@domainname.com', 1231.54);
insert into p_disc_groupby(col2, col3, col4, col5, col6) values(503, 'oracle', '1993-11-10', 'rello@domainname.com', 888.234);
insert into p_disc_groupby(col2, col3, col4, col5, col6) values(503, 'oracle', '1993-10-10', 'sello@domainname.com', 123.555);
insert into p_disc_groupby(col2, col3, col4, col5, col6) values(503, 'cubrid', '1993-11-10', 'tello@domainname.com', 222.22);
insert into p_disc_groupby(col2, col3, col4, col5, col6) values(503, 'cubrid', '1992-10-10', 'uello@domainname.com', 222.22);
insert into p_disc_groupby(col2, col3, col4, col5, col6) values(504, 'mysql', '1994-10-10', 'vello@domainname.com', 11.1111);
insert into p_disc_groupby(col2, col3, col4, col5, col6) values(504, 'mysql', '1990-10-10', null, 322.111);
insert into p_disc_groupby(col2, col3, col4, col5, col6) values(504, 'cubrid', '1995-11-10', 'wello@domainname.com', 9999.99);
insert into p_disc_groupby(col2, col3, col4, col5, col6) values(505, 'cubrid', '1991-10-10', '', 123.33);
insert into p_disc_groupby(col2, col3, col4, col5, col6) values(505, 'cubrid', '1996-10-10', 'xello@domainname.com', 555.434);
insert into p_disc_groupby(col2, col3, col4, col5, col6) values(505, 'mysql', '1990-10-10', 'yello@domainname.com', 949.22);
insert into p_disc_groupby(col2, col3, col4, col5, col6) values(505, 'cubrid', '1995-10-10', null, 191.33);
insert into p_disc_groupby(col2, col3, col4, col5, col6) values(505, 'cubrid', '1990-10-10', 'zello@domainname.com', 5435.22);



--TEST: over() clause + group by
select col1, percentile_disc(0.1) within group (order by col1) over() p_disc from p_disc_groupby group by col1 order by 1, 2;
select col2, percentile_disc(0.2) within group (order by col2) over() p_disc from p_disc_groupby group by col2 order by 1, 2;
select col3, col2, percentile_disc(0.3) within group (order by col3) over() p_disc from p_disc_groupby group by col3, col2 order by 1, 2;
select col4, percentile_disc(0.4) within group (order by col4) over() p_disc from p_disc_groupby group by col4 order by 1, 2;
select col5, col2, percentile_disc(0.5) within group (order by col5) over() p_disc from p_disc_groupby group by col5, col2 order by 1, 2;
select col6, percentile_disc(0.5) within group (order by col6) over() p_disc from p_disc_groupby group by col6 order by 1, 2;


--TEST: over(partition by) clause + group by
select col1, col4, col6, percentile_disc(0.6) within group (order by col6) over(partition by col4) p_disc from p_disc_groupby group by col1, col4, col6;
select col2, col6, percentile_disc(0.88) within group (order by col6) over(partition by col2) p_disc from p_disc_groupby group by col2, col6;
select col3, col5, col4, col6, col1, percentile_disc(0.5) within group (order by col1 desc) over(partition by col3, col5) p_disc from p_disc_groupby group by col3, col5, col4, col6, col1;


--TEST: [er] over(order by) clause + group by
select col1, col6, percentile_disc(0.5) within group (order by col1) over(order by col6) p_disc from p_disc_groupby group by col1, col6;


--TEST: [er] over(partition by.. order by ..) clause + group by
select col3, col2, col5, col1, percentile_disc(0.9999999) within group (order by col6) over(partition by col3 order by col5) p_disc from p_disc_groupby group by col3, col2, col1, col5;
 

--TEST: over(partition by) clause + group by ... having ...
select col1, col4, col5, percentile_disc(0.33) within group (order by col1) over(partition by col4) p_disc from p_disc_groupby group by col1, col4, col5 having col1 > 500;



drop table p_disc_groupby;
