--combination with limit clause and prepare statement

drop table if exists p_cont_limit;
create table p_cont_limit(
	col1 smallint auto_increment primary key,
	col2 bigint not null,
	col3 varchar default 'abc',
	col4 timestamp default CURRENT_TIMESTAMP,
	col5 bit(20)
);


insert into p_cont_limit(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10', B'0001');
insert into p_cont_limit(col2, col3, col4, col5) values(500, 'cubrid', '1990-11-10', B'0010');
insert into p_cont_limit(col2, col3, col4, col5) values(500, 'mysql', '1990-10-11', B'0100');
insert into p_cont_limit(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10', B'1000');
insert into p_cont_limit(col2, col3, col4, col5) values(500, 'cubrid', '1991-10-10', B'0011');
insert into p_cont_limit(col2, col3, col4, col5) values(501, 'oracle', '1990-10-10', B'0101');
insert into p_cont_limit(col2, col3, col4, col5) values(501, 'cubrid', '1992-10-10', B'1001');
insert into p_cont_limit(col2, col3, col4, col5) values(501, 'oracle', '1990-11-10', B'0110');
insert into p_cont_limit(col2, col3, col4, col5) values(501, 'mysql', '1990-10-10', B'1010');
insert into p_cont_limit(col2, col3, col4, col5) values(501, 'cubrid', '1990-10-10', B'1100');
insert into p_cont_limit(col2, col3, col4, col5) values(501, 'mysql', '1991-11-10', B'0111');
insert into p_cont_limit(col2, col3, col4, col5) values(502, 'cubrid', '1990-10-10', B'1110');
insert into p_cont_limit(col2, col3, col4, col5) values(502, 'mysql', '1990-10-10', B'1111');
insert into p_cont_limit(col2, col3, col4, col5) values(502, 'mysql', '1992-10-10', B'1010');
insert into p_cont_limit(col2, col3, col4, col5) values(503, 'mysql', '1992-10-10', B'0101');
insert into p_cont_limit(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10', B'1110');
insert into p_cont_limit(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10', B'0111');
insert into p_cont_limit(col2, col3, col4, col5) values(503, 'oracle', '1993-11-10', B'1101');
insert into p_cont_limit(col2, col3, col4, col5) values(503, 'oracle', '1993-10-10', B'0011');
insert into p_cont_limit(col2, col3, col4, col5) values(503, 'cubrid', '1993-11-10', B'0001');
insert into p_cont_limit(col2, col3, col4, col5) values(503, 'cubrid', '1992-10-10', B'1100');
insert into p_cont_limit(col2, col3, col4, col5) values(504, 'mysql', '1994-10-10', B'1011');
insert into p_cont_limit(col2, col3, col4, col5) values(504, 'mysql', '1990-10-10', null);
insert into p_cont_limit(col2, col3, col4, col5) values(504, 'cubrid', '1995-11-10', B'0110');
insert into p_cont_limit(col2, col3, col4, col5) values(505, 'cubrid', '1991-10-10', '');
insert into p_cont_limit(col2, col3, col4, col5) values(505, 'cubrid', '1996-10-10', B'1111');
insert into p_cont_limit(col2, col3, col4, col5) values(505, 'mysql', '1990-10-10', B'0100');
insert into p_cont_limit(col2, col3, col4, col5) values(505, 'cubrid', '1995-10-10', null);
insert into p_cont_limit(col2, col3, col4, col5) values(505, 'cubrid', '1990-10-10', B'1111');




--TEST: over() clause
select *, percentile_cont(0.5) within group (order by col1) over() p_cont from p_cont_limit order by 1, 2, 3, 4, 5, 6 limit 20;
select *, percentile_cont(0.88) within group (order by col2) over() p_cont from p_cont_limit order by 6, col1 limit 10;
select col1, col2, col3, col4, percentile_cont(0.4) within group (order by col4) over() p_cont from p_cont_limit order by 1, col2, col3, 4, 5 limit 1;


--TEST: over(partition by) clause
select *, percentile_cont(0.1) within group (order by col1) over(partition by col3) from p_cont_limit order by col2, col1 limit -1;
select *, percentile_cont(0.6) within group (order by col2) over(partition by col4) p_cont from p_cont_limit order by 1, 2, 3, 4, 5, 6 limit 100;
select col3, col4, percentile_cont(1) within group (order by col1) over(partition by col4) p_cont from p_cont_limit order by 1, 2, 3 limit 2;
select col3, col4, percentile_cont(0.7) within group (order by col4) over(partition by col5, col3) from p_cont_limit order by 1, 2, 3 limit 3;


--TEST: over(order by) clause
select col1, col2, percentile_cont(0.8) within group (order by col2) over(order by col4) p_cont1 from p_cont_limit order by 1, 2, 3 limit 20;


--TEST: over(partition by) clause + ps
prepare st from 'select *, percentile_cont(?) within group (order by col2) over(partition by col3) p_cont1 from p_cont_limit order by 1, 2, 3, 4, 5, 6 limit ?';
execute st using 0.323, 10;
prepare st from 'select *, percentile_cont(?) within group (order by col1) over(partition by col4) p_cont from p_cont_limit order by 1, 2, 3, 4, 5, 6 limit ?';
execute st using -1, 20;
prepare st from 'select col3, col4, col2, percentile_cont(?) within group (order by col4 desc) over(partition by col3, col5) p_cont from p_cont_limit order by 1, 2, 3, 4 limit ?';
execute st using 0.99, 5;
prepare st from 'select col3, col4, col5, percentile_cont(?) within group (order by col2) over(partition by col4) p_cont from p_cont_limit order by 1, 2, 4 desc, 3 asc limit ?';
execute st using 1, -1;


--TEST: over(partition by) clause + group by ... having ...
prepare st from 'select col1, col2, percentile_cont(?) within group (order by col1) over(partition by col3) p_cont from p_cont_limit group by col1 having col1 > ? order by col2 desc, col1 limit ?';
execute st using 0.4, 500, 1;
prepare st from 'select new.col4, percentile_cont(?) within group (order by new.col2 desc) over(partition by new.col4, new.col3, new.col5) p_cont from (select * from p_cont_limit order by 1 desc,2,3,4,5) new group by new.col4 having right(new.col3, 4) =  ? order by 2 asc, 1 limit ?';
execute st using 0.6, 'brid', 15;
prepare st from 'select col1, col2, col3, col4, col5, percentile_cont(?) within group (order by col1) over(partition by col3) p_cont from p_cont_limit group by col1, col2, col3, col4 having col3 in (''cubrid'', ?) order by col3 desc, col2 asc, 6, 1 limit ?';
execute st using 0.2, 'mysql', 30;

deallocate prepare st;
 



drop table p_cont_limit;


