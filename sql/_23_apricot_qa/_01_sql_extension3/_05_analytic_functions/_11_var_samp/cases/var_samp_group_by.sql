--combination with group by ... having clause
--+ holdcas on;
create table var_samp_groupby(
	col1 int auto_increment primary key,
	col2 smallint,
	col3 char(30) default 'abc',
	col4 date default SYSDATE,
	col5 clob,
	col6 monetary
);


insert into var_samp_groupby(col2, col3, col4, col5, col6) values(500, 'cubrid', '1990-10-10', 'aello@domainname.com', 123.12);
insert into var_samp_groupby(col2, col3, col4, col5, col6) values(500, 'cubrid', '1990-11-10', 'bello@domainname.com', 123.22);
insert into var_samp_groupby(col2, col3, col4, col5, col6) values(500, 'mysql', '1990-10-11', 'cello@domainname.com', 123.33);
insert into var_samp_groupby(col2, col3, col4, col5, col6) values(500, 'cubrid', '1990-10-10', 'dello@domainname.com', 123.44);
insert into var_samp_groupby(col2, col3, col4, col5, col6) values(500, 'cubrid', '1991-10-10', 'eello@domainname.com', 123.55);
insert into var_samp_groupby(col2, col3, col4, col5, col6) values(501, 'oracle', '1990-10-10', 'fello@domainname.com', 123.55);
insert into var_samp_groupby(col2, col3, col4, col5, col6) values(501, 'cubrid', '1992-10-10', 'gello@domainname.com', 123.66);
insert into var_samp_groupby(col2, col3, col4, col5, col6) values(501, 'oracle', '1990-11-10', 'hello@domainname.com', 123.77);
insert into var_samp_groupby(col2, col3, col4, col5, col6) values(501, 'mysql', '1990-10-10', 'iello@domainname.com', 123.88);
insert into var_samp_groupby(col2, col3, col4, col5, col6) values(501, 'cubrid', '1990-10-10', 'jello@domainname.com', 888.11);
insert into var_samp_groupby(col2, col3, col4, col5, col6) values(501, 'mysql', '1991-11-10', 'kello@domainname.com', 444.11);
insert into var_samp_groupby(col2, col3, col4, col5, col6) values(502, 'cubrid', '1990-10-10', 'lello@domainname.com', 555.33);
insert into var_samp_groupby(col2, col3, col4, col5, col6) values(502, 'mysql', '1990-10-10', 'mello@domainname.com', 888.55);
insert into var_samp_groupby(col2, col3, col4, col5, col6) values(502, 'mysql', '1992-10-10', 'nello@domainname.com', 292.14);
insert into var_samp_groupby(col2, col3, col4, col5, col6) values(503, 'mysql', '1992-10-10', 'oello@domainname.com', 928.45);
insert into var_samp_groupby(col2, col3, col4, col5, col6) values(503, 'cubrid', '1990-10-10', 'pello@domainname.com', 2902.123);
insert into var_samp_groupby(col2, col3, col4, col5, col6) values(503, 'cubrid', '1990-10-10', 'qello@domainname.com', 1231.54);
insert into var_samp_groupby(col2, col3, col4, col5, col6) values(503, 'oracle', '1993-11-10', 'rello@domainname.com', 888.234);
insert into var_samp_groupby(col2, col3, col4, col5, col6) values(503, 'oracle', '1993-10-10', 'sello@domainname.com', 123.555);
insert into var_samp_groupby(col2, col3, col4, col5, col6) values(503, 'cubrid', '1993-11-10', 'tello@domainname.com', 222.22);
insert into var_samp_groupby(col2, col3, col4, col5, col6) values(503, 'cubrid', '1992-10-10', 'uello@domainname.com', 222.22);
insert into var_samp_groupby(col2, col3, col4, col5, col6) values(504, 'mysql', '1994-10-10', 'vello@domainname.com', 11.1111);
insert into var_samp_groupby(col2, col3, col4, col5, col6) values(504, 'mysql', '1990-10-10', null, 322.111);
insert into var_samp_groupby(col2, col3, col4, col5, col6) values(504, 'cubrid', '1995-11-10', 'wello@domainname.com', 9999.99);
insert into var_samp_groupby(col2, col3, col4, col5, col6) values(505, 'cubrid', '1991-10-10', '', 123.33);
insert into var_samp_groupby(col2, col3, col4, col5, col6) values(505, 'cubrid', '1996-10-10', 'xello@domainname.com', 555.434);
insert into var_samp_groupby(col2, col3, col4, col5, col6) values(505, 'mysql', '1990-10-10', 'yello@domainname.com', 949.22);
insert into var_samp_groupby(col2, col3, col4, col5, col6) values(505, 'cubrid', '1995-10-10', null, 191.33);
insert into var_samp_groupby(col2, col3, col4, col5, col6) values(505, 'cubrid', '1990-10-10', 'zello@domainname.com', 5435.22);



--TEST: over() clause + group by
select col1, var_samp(col1) over() var_samp from var_samp_groupby group by col1;
select col2, var_samp(col2) over() var_samp from var_samp_groupby group by col2;
select col1, col2, var_samp(col2) over() var_samp from var_samp_groupby group by col1;
select 1 from (select col1, col2, var_samp(unique col2) over() var_samp, col3 from var_samp_groupby group by col2);
select col1, col2, var_samp(distinctrow col1) over() var_samp from var_samp_groupby group by col1, col2;


--TEST: over(partition by) clause + group by
select col3, var_samp(all col6) over(partition by col3) var_samp from var_samp_groupby group by col3;
select col4, var_samp(col6) over(partition by col4) var_samp from var_samp_groupby group by col4;
select 1 from (select col3, col4, var_samp(unique col6) over(partition by col4) var_samp from var_samp_groupby group by col4);
select 1 from (select col3, col4, var_samp(distinct col6) over(partition by col3) var_samp from var_samp_groupby group by col3, col4);
select 1 from (select col3, col4, clob_to_char(col5), var_samp(col6) over(partition by col4) var_samp from var_samp_groupby group by col3, col4);


--TEST: over(order by) clause + group by
select col1, var_samp(col1) over(order by col1) var_samp from var_samp_groupby group by col1;
select col2, var_samp(all col2) over(order by col2) var_samp from var_samp_groupby group by col2;
select col1, col2, var_samp(distinctrow col2) over(order by col1) var_samp from var_samp_groupby group by col1;
select 1 from (select col1, col2, var_samp(unique col6) over(order by col1, col2) var_samp, col3 from var_samp_groupby group by col2);
select col1, col2, var_samp(distinct col1) over(order by col2) var_samp from var_samp_groupby group by col1, col2;


--TEST: over(partition by.. order by ..) clause + group by
select col3, var_samp(col6) over(partition by col3 order by col3) var_samp from var_samp_groupby group by col3;
select col4, var_samp(all col2) over(partition by col4 order by col4) var_samp from var_samp_groupby group by col4;
select 1 from (select col3, col4, var_samp(unique col2) over(partition by col4 order by col3) var_samp from var_samp_groupby group by col4);
select 1 from (select col3, col4, var_samp(distinctrow col6) over(partition by col3 order by col4) var_samp from var_samp_groupby group by col3, col4);
select 1 from (select col3, col4, clob_to_char(col5), var_samp(all col6) over(partition by col4 order by col3) var_samp from var_samp_groupby group by col3, col4);


--TEST: over(partition by.. order by ..) clause + group by ... having ...
select col1, var_samp(col1) over(partition by col1 order by col1) var_samp from var_samp_groupby group by col1 having col1 > 500;
select 1 from (select col4, var_samp(col2) over(partition by col4 order by col4) var_samp from var_samp_groupby group by col4 having right(clob_to_char(col5), 4) =  '.com');
select col1, col2, col3, col4, clob_to_char(col5), var_samp(col6) over(partition by col3 order by col1) var_samp from var_samp_groupby group by col1, col2, col3, col4 having col2 in ('cubrid', 'mysql') and right(clob_to_char(col5), 12) = '@domainname.com';
 



delete from var_samp_groupby;
drop table var_samp_groupby;

commit;
--+ holdcas off;
