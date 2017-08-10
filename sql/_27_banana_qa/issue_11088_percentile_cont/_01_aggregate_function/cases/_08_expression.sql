--TEST: pass expresstions to the params

drop table if exists p_cont;
create table p_cont(
	col1 int auto_increment primary key,
	col2 float not null,
	col3 char(20) default 'abc',
	col4 datetime default SYS_DATETIME,
	col5 bit varying
);


insert into p_cont(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10 11:23:34.123', B'0001');
insert into p_cont(col2, col3, col4, col5) values(500, 'cubrid', '1990-11-10 11:23:34.123', B'0010');
insert into p_cont(col2, col3, col4, col5) values(500, 'mysql', '1990-10-11 11:23:34.123', B'0100');
insert into p_cont(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10 11:23:34.123', B'1000');
insert into p_cont(col2, col3, col4, col5) values(500, 'cubrid', '1991-10-10 11:23:34.123', B'0011');
insert into p_cont(col2, col3, col4, col5) values(501, 'oracle', '1990-10-10 11:23:34.123', B'0101');
insert into p_cont(col2, col3, col4, col5) values(501, 'cubrid', '1992-10-10 11:23:34.123', B'1001');
insert into p_cont(col2, col3, col4, col5) values(501, 'oracle', '1990-11-10 11:23:34.123', B'0110');
insert into p_cont(col2, col3, col4, col5) values(501, 'mysql', '1990-10-10 11:23:34.123', B'1010');
insert into p_cont(col2, col3, col4, col5) values(501, 'cubrid', '1990-10-10 11:23:34.123', B'1100');
insert into p_cont(col2, col3, col4, col5) values(501, 'mysql', '1991-11-10 11:23:34.123', B'0111');
insert into p_cont(col2, col3, col4, col5) values(502, 'cubrid', '1990-10-10 11:23:34.123', B'1110');
insert into p_cont(col2, col3, col4, col5) values(502, 'mysql', '1990-10-10 11:23:34.123', B'1111');
insert into p_cont(col2, col3, col4, col5) values(502, 'mysql', '1992-10-10 11:23:34.123', B'1010');
insert into p_cont(col2, col3, col4, col5) values(503, 'mysql', '1992-10-10 11:23:34.123', B'0101');
insert into p_cont(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10 11:23:34.123', B'1110');
insert into p_cont(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10 11:23:34.123', B'0111');
insert into p_cont(col2, col3, col4, col5) values(503, 'oracle', '1993-11-10 11:23:34.123', B'1101');
insert into p_cont(col2, col3, col4, col5) values(503, 'oracle', '1993-10-10 11:23:34.123', B'0011');
insert into p_cont(col2, col3, col4, col5) values(503, 'cubrid', '1993-11-10 11:23:34.123', B'0001');
insert into p_cont(col2, col3, col4, col5) values(503, 'cubrid', '1992-10-10 11:23:34.123', B'1100');
insert into p_cont(col2, col3, col4, col5) values(504, 'mysql', '1994-10-10 11:23:34.123', B'1011');
insert into p_cont(col2, col3, col4, col5) values(504, 'mysql', '1990-10-10 11:23:34.123', null);
insert into p_cont(col2, col3, col4, col5) values(504, 'cubrid', '1995-11-10 11:23:34.123', B'0110');
insert into p_cont(col2, col3, col4, col5) values(505, 'cubrid', '1991-10-10 11:23:34.123', '');
insert into p_cont(col2, col3, col4, col5) values(505, 'cubrid', '1996-10-10 11:23:34.123', B'1111');
insert into p_cont(col2, col3, col4, col5) values(505, 'mysql', '1990-10-10 11:23:34.123', B'0100');
insert into p_cont(col2, col3, col4, col5) values(505, 'cubrid', '1995-10-10 11:23:34.123', null);
insert into p_cont(col2, col3, col4, col5) values(505, 'cubrid', '1990-10-10 11:23:34.123', B'1111');

create view p_cont_v as select * from p_cont order by 1,2,3,4,5;

--test: pass expresstions to the first param 
select col2, percentile_cont(50/100.0) within group(order by col1) p_cont from p_cont_v group by col2 order by 1, 2;
select col2, percentile_cont(0.3+0.7) within group(order by col2) p_cont from p_cont_v group by col2 order by 1, 2;
select col2, percentile_cont(100<101) within group(order by col4) p_cont from p_cont_v group by col2 order by 1, 2;
select col2, percentile_cont(abs(-0.2330)) within group(order by col1) p_cont from p_cont_v group by col2 order by 1, 2;
select col2, percentile_cont(ceil(0.11111)) within group(order by col1) p_cont from p_cont_v group by col2 order by 1, 2;
select col4, percentile_cont(floor(1.99999)) within group(order by col1) p_cont from p_cont_v group by col4 order by 1, 2;
select col2, percentile_cont(round(0.685642315, 3)) within group(order by col1) p_cont from p_cont_v group by col2 order by 1, 2;
select col2, percentile_cont(round(col2/1000, 3)) within group(order by col1) p_cont from p_cont_v group by col2 order by 1, 2;
select col2, percentile_cont(incr(col1)) within group(order by col1) p_cont from p_cont_v group by col2 order by 1, 2;


--test: pass expresstions to the second param
select col3, percentile_cont(0.2) within group(order by col1+col2) p_cont from p_cont_v group by col3 order by 1, 2;
select col3, col5, percentile_cont(0.5) within group(order by col2-col1) p_cont from p_cont_v group by col5, col3 order by 1, 2, 3;
select col2, percentile_cont(0.8) within group(order by round(col2/col1, 2) asc) p_cont from p_cont_v group by col2 order by 1, 2;
select col5, percentile_cont(0.4) within group(order by width_bucket(col2, 500, 505, 5)) p_cont from p_cont_v group by col5 order by 1, 2;
select col2 from (select col2, percentile_cont(900/1000) within group (order by SYSDATE) p_cont from p_cont_v group by col2 order by 1, 2) order by 1;
select col2, if(p_cont-CURRENT_TIMESTAMP<=3, 'ok', 'nok') result from (select col2, percentile_cont(0) within group (order by CURRENT_TIMESTAMP desc) p_cont from p_cont_v group by col2) order by 1, 2;
select col2, percentile_cont(1) within group (order by year(col4)) p_cont from p_cont_v group by col2 having col1<20 order by 1, 2;
select col2, percentile_cont(0.7) within group (order by adddate(col4, 10) desc) p_cont from p_cont_v group by col2 having col1<20 order by 1, 2;
select col5, percentile_cont(0.3) within group (order by to_char(col4, 'HH24:MI:SS.FF DD/MM/YYYY')) p_cont from p_cont_v group by col5 having max(col1)<20 order by 1, 2;
select col5, percentile_cont(0.6) within group (order by decr(col1)) p_cont from p_cont_v group by col5 having max(col1)<20 order by 1, 2;

drop view p_cont_v;
drop table p_cont;




