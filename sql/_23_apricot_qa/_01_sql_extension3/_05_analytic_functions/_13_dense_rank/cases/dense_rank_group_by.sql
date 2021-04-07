
--+ holdcas on;
--combination with group by ... having clause


create table drank_groupby(
	col1 int auto_increment primary key,
	col2 smallint,
	col3 char(30) default 'abc',
	col4 date default SYSDATE,
	col5 clob
);


insert into drank_groupby(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10', 'aello@domainname.com');
insert into drank_groupby(col2, col3, col4, col5) values(500, 'cubrid', '1990-11-10', 'bello@domainname.com');
insert into drank_groupby(col2, col3, col4, col5) values(500, 'mysql', '1990-10-11', 'cello@domainname.com');
insert into drank_groupby(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10', 'dello@domainname.com');
insert into drank_groupby(col2, col3, col4, col5) values(500, 'cubrid', '1991-10-10', 'eello@domainname.com');
insert into drank_groupby(col2, col3, col4, col5) values(501, 'oracle', '1990-10-10', 'fello@domainname.com');
insert into drank_groupby(col2, col3, col4, col5) values(501, 'cubrid', '1992-10-10', 'gello@domainname.com');
insert into drank_groupby(col2, col3, col4, col5) values(501, 'oracle', '1990-11-10', 'hello@domainname.com');
insert into drank_groupby(col2, col3, col4, col5) values(501, 'mysql', '1990-10-10', 'iello@domainname.com');
insert into drank_groupby(col2, col3, col4, col5) values(501, 'cubrid', '1990-10-10', 'jello@domainname.com');
insert into drank_groupby(col2, col3, col4, col5) values(501, 'mysql', '1991-11-10', 'kello@domainname.com');
insert into drank_groupby(col2, col3, col4, col5) values(502, 'cubrid', '1990-10-10', 'lello@domainname.com');
insert into drank_groupby(col2, col3, col4, col5) values(502, 'mysql', '1990-10-10', 'mello@domainname.com');
insert into drank_groupby(col2, col3, col4, col5) values(502, 'mysql', '1992-10-10', 'nello@domainname.com');
insert into drank_groupby(col2, col3, col4, col5) values(503, 'mysql', '1992-10-10', 'oello@domainname.com');
insert into drank_groupby(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10', 'pello@domainname.com');
insert into drank_groupby(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10', 'qello@domainname.com');
insert into drank_groupby(col2, col3, col4, col5) values(503, 'oracle', '1993-11-10', 'rello@domainname.com');
insert into drank_groupby(col2, col3, col4, col5) values(503, 'oracle', '1993-10-10', 'sello@domainname.com');
insert into drank_groupby(col2, col3, col4, col5) values(503, 'cubrid', '1993-11-10', 'tello@domainname.com');
insert into drank_groupby(col2, col3, col4, col5) values(503, 'cubrid', '1992-10-10', 'uello@domainname.com');
insert into drank_groupby(col2, col3, col4, col5) values(504, 'mysql', '1994-10-10', 'vello@domainname.com');
insert into drank_groupby(col2, col3, col4, col5) values(504, 'mysql', '1990-10-10', null);
insert into drank_groupby(col2, col3, col4, col5) values(504, 'cubrid', '1995-11-10', 'wello@domainname.com');
insert into drank_groupby(col2, col3, col4, col5) values(505, 'cubrid', '1991-10-10', '');
insert into drank_groupby(col2, col3, col4, col5) values(505, 'cubrid', '1996-10-10', 'xello@domainname.com');
insert into drank_groupby(col2, col3, col4, col5) values(505, 'mysql', '1990-10-10', 'yello@domainname.com');
insert into drank_groupby(col2, col3, col4, col5) values(505, 'cubrid', '1995-10-10', null);
insert into drank_groupby(col2, col3, col4, col5) values(505, 'cubrid', '1990-10-10', 'zello@domainname.com');



--TEST: over() clause + group by
select col1, dense_rank() over() d_rank from drank_groupby group by col1;
select col2, dense_rank() over() d_rank from drank_groupby group by col2;
select col1, col2, dense_rank() over() d_rank from drank_groupby group by col1;
select col1, col2, dense_rank() over() d_rank, col3 from drank_groupby group by col2;
select col1, col2, dense_rank() over() d_rank from drank_groupby group by col1, col2;


--TEST: over(partition by) clause + group by
select col3, dense_rank() over(partition by col3) d_rank from drank_groupby group by col3;
select col4, dense_rank() over(partition by col4) d_rank from drank_groupby group by col4;
select col3, col4, dense_rank() over(partition by col4) d_rank from drank_groupby group by col4;
select col3, col4, dense_rank() over(partition by col3) d_rank from drank_groupby group by col3, col4;
select col3, col4, clob_to_char(col5), dense_rank() over(partition by col4) d_rank from drank_groupby group by col3, col4;


--TEST: over(order by) clause + group by
select col1, dense_rank() over(order by col1) d_rank from drank_groupby group by col1;
select col2, dense_rank() over(order by col2) d_rank from drank_groupby group by col2;
select col1, col2, dense_rank() over(order by col1) d_rank from drank_groupby group by col1;
select col1, col2, dense_rank() over(order by col1, col2) d_rank, col3 from drank_groupby group by col2;
select col1, col2, dense_rank() over(order by col2) d_rank from drank_groupby group by col1, col2;


--TEST: over(partition by.. order by ..) clause + group by
select col3, dense_rank() over(partition by col3 order by col3) d_rank from drank_groupby group by col3;
select col4, dense_rank() over(partition by col4 order by col4) d_rank from drank_groupby group by col4;
select col3, col4, dense_rank() over(partition by col4 order by col3) d_rank from drank_groupby group by col4;
select col3, col4, dense_rank() over(partition by col3 order by col4) d_rank from drank_groupby group by col3, col4;
select col3, col4, clob_to_char(col5), dense_rank() over(partition by col4 order by col3) d_rank from drank_groupby group by col3, col4;


--TEST: over(partition by.. order by ..) clause + group by ... having ...
select col1, dense_rank() over(partition by col1 order by col1) d_rank from drank_groupby group by col1 having col1 > 500;
select col4, dense_rank() over(partition by col4 order by col4) d_rank from drank_groupby group by col4 having right(clob_to_char(col5), 4) =  '.com';
select col1, col2, col3, col4, clob_to_char(col5), dense_rank() over(partition by col3 order by col1) d_rank from drank_groupby group by col1, col2, col3, col4 having col2 in ('cubrid', 'mysql') and right(clob_to_char(col5), 12) = '@domainname.com';
 



delete from drank_groupby;
drop table drank_groupby;

--+ holdcas off;
