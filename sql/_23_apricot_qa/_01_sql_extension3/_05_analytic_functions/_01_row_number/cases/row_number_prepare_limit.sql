--combination with limit clause and prepare statement


create table rn_limit(
	col1 smallint auto_increment primary key,
	col2 bigint not null,
	col3 varchar default 'abc',
	col4 timestamp default CURRENT_TIMESTAMP,
	col5 bit(20)
);


insert into rn_limit(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10 18:19:29', B'0001');
insert into rn_limit(col2, col3, col4, col5) values(500, 'cubrid', '1990-11-10 18:19:29', B'0010');
insert into rn_limit(col2, col3, col4, col5) values(500, 'mysql', '1990-10-11 18:19:29', B'0100');
insert into rn_limit(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10 18:19:29', B'1000');
insert into rn_limit(col2, col3, col4, col5) values(500, 'cubrid', '1991-10-10 18:19:29', B'0011');
insert into rn_limit(col2, col3, col4, col5) values(501, 'oracle', '1990-10-10 18:19:29', B'0101');
insert into rn_limit(col2, col3, col4, col5) values(501, 'cubrid', '1992-10-10 18:19:29', B'1001');
insert into rn_limit(col2, col3, col4, col5) values(501, 'oracle', '1990-11-10 18:19:29', B'0110');
insert into rn_limit(col2, col3, col4, col5) values(501, 'mysql', '1990-10-10 18:19:29', B'1010');
insert into rn_limit(col2, col3, col4, col5) values(501, 'cubrid', '1990-10-10 18:19:29', B'1100');
insert into rn_limit(col2, col3, col4, col5) values(501, 'mysql', '1991-11-10 18:19:29', B'0111');
insert into rn_limit(col2, col3, col4, col5) values(502, 'cubrid', '1990-10-10 18:19:29', B'1110');
insert into rn_limit(col2, col3, col4, col5) values(502, 'mysql', '1990-10-10 18:19:29', B'1111');
insert into rn_limit(col2, col3, col4, col5) values(502, 'mysql', '1992-10-10 18:19:29', B'1010');
insert into rn_limit(col2, col3, col4, col5) values(503, 'mysql', '1992-10-10 18:19:29', B'0101');
insert into rn_limit(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10 18:19:29', B'1110');
insert into rn_limit(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10 18:19:29', B'0111');
insert into rn_limit(col2, col3, col4, col5) values(503, 'oracle', '1993-11-10 18:19:29', B'1101');
insert into rn_limit(col2, col3, col4, col5) values(503, 'oracle', '1993-10-10 18:19:29', B'0011');
insert into rn_limit(col2, col3, col4, col5) values(503, 'cubrid', '1993-11-10 18:19:29', B'0001');
insert into rn_limit(col2, col3, col4, col5) values(503, 'cubrid', '1992-10-10 18:19:29', B'1100');
insert into rn_limit(col2, col3, col4, col5) values(504, 'mysql', '1994-10-10 18:19:29', B'1011');
insert into rn_limit(col2, col3, col4, col5) values(504, 'mysql', '1990-10-10 18:19:29', null);
insert into rn_limit(col2, col3, col4, col5) values(504, 'cubrid', '1995-11-10 18:19:29', B'0110');
insert into rn_limit(col2, col3, col4, col5) values(505, 'cubrid', '1991-10-10 18:19:29', '');
insert into rn_limit(col2, col3, col4, col5) values(505, 'cubrid', '1996-10-10 18:19:29', B'1111');
insert into rn_limit(col2, col3, col4, col5) values(505, 'mysql', '1990-10-10 18:19:29', B'0100');
insert into rn_limit(col2, col3, col4, col5) values(505, 'cubrid', '1995-10-10 18:19:29', null);
insert into rn_limit(col2, col3, col4, col5) values(505, 'cubrid', '1990-10-10 18:19:29', B'1111');




--TEST: over() clause + order by
select row_num from (select *, row_number() over() row_num from rn_limit order by 1, 2, 3, 4, 5, 6 limit 20) order by 1;
select row_num from (select *, row_number() over() row_num from rn_limit order by 6, col1 limit 10) order by 1;
select col1, col2, col3, col4, row_number() over() row_num from rn_limit order by 1, col2, col3, 4, 5 limit 1;


--TEST: over(partition by order by) clause + order by
select *, row_number() over(partition by col3 order by col1) from rn_limit order by col2, col1 limit -1;
select *, row_number() over(partition by col4 order by col1) row_num from rn_limit order by 4, row_num, col2 limit 100;
select col3, col4, row_number() over(partition by col4 order by col1) row_num from rn_limit order by col1, row_num limit 2;
select col3, col4, row_number() over(partition by col3 order by col4, col5) from rn_limit order by col3, 3, col4 limit 3;


--TEST: over(order by) clause + order by
select col1, col2, col3, row_number() over(order by col1) row_num from rn_limit order by col3, col2, row_num limit 10;
select row_num from (select col2, row_number() over(order by col2) row_num, col3 from rn_limit) order by 1 limit 15;
select *, row_number() over(order by col3 asc, col5 desc) from rn_limit order by col5 asc, col3 desc limit -100;
select *, row_number() over(order by col1, col2, col3 desc, col4, col5), col3 from rn_limit order by 5 desc, 4, 3, 2, 1 limit 30;
select col1, col2, row_number() over(order by col2) from rn_limit order by col3, col4, col1 limit 20;


--TEST: over(partition by.. order by ..) clause + order by
prepare st from 'select *, row_number() over(partition by col3 order by col1) from rn_limit order by col3 limit ?';
execute st using 10;
prepare st from 'select *, row_number() over(partition by col4 order by col4, col1 desc) row_num from rn_limit order by col1 limit ?';
execute st using 20;
prepare st from 'select col1, col3, col4, row_number() over(partition by col4 order by col3, col2, col1 desc) row_num from rn_limit order by row_num, col4 limit ?';
execute st using 1;
prepare st from 'select col3, col4, col2, row_number() over(partition by col3 order by col4) from rn_limit order by ?, ? limit ?';
execute st using 3, 4, 5;
prepare st from 'select row_num from (select col3, col4, col5, row_number() over(partition by col4 order by col3, col2) row_num from rn_limit) order by 1 limit ?';
execute st using -1;


--TEST: over(partition by.. order by ..) clause + order by ... having ...
prepare st from 'select col1, col2, row_number() over(partition by col1 order by col2) from rn_limit group by col1 having col1 > 500 order by col2 desc, col1 limit ?';
execute st using 1;
prepare st from 'select col5, col2, col4, row_number() over(partition by col4 order by col4, col2, col5) from rn_limit group by col4 having right(col3, 2) =  'id' order by 4, 3 desc, 2 asc, 1 limit ?';
execute st using 15;
prepare st from 'select col1, col2, col3, col4, col5, row_number() over(partition by col3 order by col2 desc, col4, col5) from rn_limit group by col1, col2, col3, col4 having col3 in ('cubrid', 'mysql') order by col3 desc, col2 asc, 6, 1 limit ?';
execute st using 30;
 
deallocate prepare st;


drop table rn_limit;


