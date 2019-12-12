--combination with order by clause


create table drank_orderby(
	col1 smallint auto_increment primary key,
	col2 bigint not null,
	col3 varchar default 'abc',
	col4 timestamp default CURRENT_TIMESTAMP,
	col5 bit(20)
);


insert into drank_orderby(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10', B'0001');
insert into drank_orderby(col2, col3, col4, col5) values(500, 'cubrid', '1990-11-10', B'0010');
insert into drank_orderby(col2, col3, col4, col5) values(500, 'mysql', '1990-10-11', B'0100');
insert into drank_orderby(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10', B'1000');
insert into drank_orderby(col2, col3, col4, col5) values(500, 'cubrid', '1991-10-10', B'0011');
insert into drank_orderby(col2, col3, col4, col5) values(501, 'oracle', '1990-10-10', B'0101');
insert into drank_orderby(col2, col3, col4, col5) values(501, 'cubrid', '1992-10-10', B'1001');
insert into drank_orderby(col2, col3, col4, col5) values(501, 'oracle', '1990-11-10', B'0110');
insert into drank_orderby(col2, col3, col4, col5) values(501, 'mysql', '1990-10-10', B'1010');
insert into drank_orderby(col2, col3, col4, col5) values(501, 'cubrid', '1990-10-10', B'1100');
insert into drank_orderby(col2, col3, col4, col5) values(501, 'mysql', '1991-11-10', B'0111');
insert into drank_orderby(col2, col3, col4, col5) values(502, 'cubrid', '1990-10-10', B'1110');
insert into drank_orderby(col2, col3, col4, col5) values(502, 'mysql', '1990-10-10', B'1111');
insert into drank_orderby(col2, col3, col4, col5) values(502, 'mysql', '1992-10-10', B'1010');
insert into drank_orderby(col2, col3, col4, col5) values(503, 'mysql', '1992-10-10', B'0101');
insert into drank_orderby(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10', B'1110');
insert into drank_orderby(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10', B'0111');
insert into drank_orderby(col2, col3, col4, col5) values(503, 'oracle', '1993-11-10', B'1101');
insert into drank_orderby(col2, col3, col4, col5) values(503, 'oracle', '1993-10-10', B'0011');
insert into drank_orderby(col2, col3, col4, col5) values(503, 'cubrid', '1993-11-10', B'0001');
insert into drank_orderby(col2, col3, col4, col5) values(503, 'cubrid', '1992-10-10', B'1100');
insert into drank_orderby(col2, col3, col4, col5) values(504, 'mysql', '1994-10-10', B'1011');
insert into drank_orderby(col2, col3, col4, col5) values(504, 'mysql', '1990-10-10', null);
insert into drank_orderby(col2, col3, col4, col5) values(504, 'cubrid', '1995-11-10', B'0110');
insert into drank_orderby(col2, col3, col4, col5) values(505, 'cubrid', '1991-10-10', '');
insert into drank_orderby(col2, col3, col4, col5) values(505, 'cubrid', '1996-10-10', B'1111');
insert into drank_orderby(col2, col3, col4, col5) values(505, 'mysql', '1990-10-10', B'0100');
insert into drank_orderby(col2, col3, col4, col5) values(505, 'cubrid', '1995-10-10', null);
insert into drank_orderby(col2, col3, col4, col5) values(505, 'cubrid', '1990-10-10', B'1111');




--TEST: error, over() clause + order by
select *, dense_rank() over() d_rank from drank_orderby order by 1, 2, 3, 4, 5, 6;
select *, dense_rank() over() d_rank from drank_orderby order by 6, col1;
select col1, col2, col3, col4, dense_rank() over() d_rank from drank_orderby order by 1, col2, col3, 4, 5;


--TEST: error, over(partition by) clause + order by
select *, dense_rank() over(partition by col3) from drank_orderby order by 1, 2, 3, 4, 5, 6;
select *, dense_rank() over(partition by col4) d_rank from drank_orderby order by 1, 2, 3, 4, 5, 6;
select col3, col4, dense_rank() over(partition by col4) d_rank from drank_orderby order by 1, 2, 3;
select col3, col4, dense_rank() over(partition by col3) from drank_orderby order by col3, 3, col4;


--TEST: over(order by) clause + order by
select col1, col2, col3, dense_rank() over(order by col1) d_rank from drank_orderby order by 1, 2, 3, 4;
select col2, dense_rank() over(order by col2) d_rank, col3 from drank_orderby order by col3, col2, 2 desc;
select *, dense_rank() over(order by col3 asc, col5 desc) from drank_orderby order by 1, 2, 3, 4, 5, 6;
select *, dense_rank() over(order by col1, col2, col3 desc, col4, col5), col3 from drank_orderby order by 6, 5 desc, 4, 3, 2, 1;
select col1, col2, dense_rank() over(order by col2) from drank_orderby order by 1, 2, 3;


--TEST: over(partition by.. order by ..) clause + order by
select *, dense_rank() over(partition by col3 order by col1) from drank_orderby order by 1, 2, 3, 4, 5, 6;
select *, dense_rank() over(partition by col4 order by col4, col1 desc) d_rank from drank_orderby order by col1, 2, 3, 4, 5, 6;
select col1, col3, col4, dense_rank() over(partition by col4 order by col3, col2, col1 desc) d_rank from drank_orderby order by 1, 2, 3, 4;
select col3, col4, col2, dense_rank() over(partition by col3 order by col4) from drank_orderby order by col3, col4, 3, 4;
select col3, col4, col5, dense_rank() over(partition by col4 order by col3, col2) from drank_orderby order by 1, 2, 4 desc, 3 asc;


--TEST: over(partition by.. order by ..) clause + order by ... having ...
--select col1, col2, dense_rank() over(partition by col1 order by col2) from drank_orderby group by col1 having col1 > 500 order by col2 desc, col1;
--select col5, col2, col4, dense_rank() over(partition by col4 order by col4, col2, col5) from drank_orderby group by col4 having right(clob_to_char(col5), 4) =  '.com' order by 4, 3 desc, 2 asc, 1;
--select col1, col2, col3, col4, col5, dense_rank() over(partition by col3 order by col2 desc, col4, col5) from drank_orderby group by col1, col2, col3, col4 having col2 in ('cubrid', 'mysql') and right(clob_to_char(col5), 12) = '@domainname.com' order by col3 desc, col2 asc, 6, 1;
 



drop table drank_orderby;


