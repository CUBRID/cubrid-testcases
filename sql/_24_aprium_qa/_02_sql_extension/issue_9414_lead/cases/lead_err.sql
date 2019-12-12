--TEST: error and special cases 


create table lead_err(
        col1 smallint auto_increment primary key,
        col2 bigint not null,
        col3 varchar default 'abc',
        col4 timestamp default CURRENT_TIMESTAMP,
        col5 bit(20)
);


insert into lead_err(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10 11:12:13', B'0001');
insert into lead_err(col2, col3, col4, col5) values(500, 'cubrid', '1990-11-10 11:12:13', B'0010');
insert into lead_err(col2, col3, col4, col5) values(500, 'mysql', '1990-10-11 11:12:13', B'0100');
insert into lead_err(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10 11:12:13', B'1000');
insert into lead_err(col2, col3, col4, col5) values(500, 'cubrid', '1991-10-10 11:12:13', B'0011');
insert into lead_err(col2, col3, col4, col5) values(501, 'oracle', '1990-10-10 11:12:13', B'0101');
insert into lead_err(col2, col3, col4, col5) values(501, 'cubrid', '1992-10-10 11:12:13', B'1001');
insert into lead_err(col2, col3, col4, col5) values(501, 'oracle', '1990-11-10 11:12:13', B'0110');
insert into lead_err(col2, col3, col4, col5) values(501, 'mysql', '1990-10-10 11:12:13', B'1010');
insert into lead_err(col2, col3, col4, col5) values(501, 'cubrid', '1990-10-10 11:12:13', B'1100');
insert into lead_err(col2, col3, col4, col5) values(501, 'mysql', '1991-11-10 11:12:13', B'0111');
insert into lead_err(col2, col3, col4, col5) values(502, 'cubrid', '1990-10-10 11:12:13', B'1110');
insert into lead_err(col2, col3, col4, col5) values(502, 'mysql', '1990-10-10 11:12:13', B'1111');
insert into lead_err(col2, col3, col4, col5) values(502, 'mysql', '1992-10-10 11:12:13', B'1010');
insert into lead_err(col2, col3, col4, col5) values(503, 'mysql', '1992-10-10 11:12:13', B'0101');
insert into lead_err(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10 11:12:13', B'1110');
insert into lead_err(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10 11:12:13', B'0111');
insert into lead_err(col2, col3, col4, col5) values(503, 'oracle', '1993-11-10 11:12:13', B'1101');
insert into lead_err(col2, col3, col4, col5) values(503, 'oracle', '1993-10-10 11:12:13', B'0011');
insert into lead_err(col2, col3, col4, col5) values(503, 'cubrid', '1993-11-10 11:12:13', B'0001');
insert into lead_err(col2, col3, col4, col5) values(503, 'cubrid', '1992-10-10 11:12:13', B'1100');
insert into lead_err(col2, col3, col4, col5) values(504, 'mysql', '1994-10-10 11:12:13', B'1011');
insert into lead_err(col2, col3, col4, col5) values(504, 'mysql', '1990-10-10 11:12:13', null);
insert into lead_err(col2, col3, col4, col5) values(504, 'cubrid', '1995-11-10 11:12:13', B'0110');
insert into lead_err(col2, col3, col4, col5) values(505, 'cubrid', '1991-10-10 11:12:13', '');
insert into lead_err(col2, col3, col4, col5) values(505, 'cubrid', '1996-10-10 11:12:13', B'1111');
insert into lead_err(col2, col3, col4, col5) values(505, 'mysql', '1990-10-10 11:12:13', B'0100');
insert into lead_err(col2, col3, col4, col5) values(505, 'cubrid', '1995-10-10 11:12:13', null);
insert into lead_err(col2, col3, col4, col5) values(505, 'cubrid', '1990-10-10 11:12:13', B'1111');


--TEST: pass unmatched data type to 'offset' param
select col1, col2, col3, col4, lead(col1, '4') over(order by col1) next_v from lead_err order by 1;
select col1, col2, col3, col4, lead(col2, 'aaa') over(order by 1) next_v from lead_err order by 1;
select col1, col2, col3, col4, lead(col3, 4.6) over(order by 1) next_v from lead_err order by 1;
select col1, col2, col3, col4, lead(col4, '2012-12-12') over(order by 1) next_v from lead_err order by 1;

--TEST: pass constant value to the 'expr'
select col1, lead(4.4) over(order by col1) next_v from lead_err;
select col1, col2, lead('abcd') over(partition by col1 order by col2) next_v from lead_err order by 1, 2;
select col3, lead(date'1999-11-11') over(order by col3) next_v from lead_err order by 1, 2;

--TEST: pass unmatched type to the 'default' param
select col1, lead(col2, 2, '999') over(order by 1) next_v from lead_err order by 1;
select col1, lead(col5, 3, 123) over(order by 1) next_v from lead_err order by 1;
select col1, lead(col3, 3, 123) over(order by 1) next_v from lead_err order by 1;
select col1, lead(col4, 3, 'abc') over(order by 1) next_v from lead_err order by 1;

--TEST: large numeric value to expr
select col2, lead(col2, 99999999999999999999) over(order by col2) from lead_err order by 1, 2;
select col2, lead(col2, 9999999999999999, -111) over(order by col2) from lead_err order by 1, 2;

--TEST: marginal numeric values to expr
select col1, lead(col3, 32767) over(order by col1) from lead_err order by 1, 2;
select col1, lead(col4, 2147483647, '2000-10-10') over(order by col1) from lead_err order by 1, 2;
select col1, lead(col2, 9223372036854775807, -1) over(order by col1) from lead_err order by 1, 2;
select col1, lead(col5, 1.7976931348623157E+308) over(order by col1) from lead_err order by 1, 2;

--TEST: out-of-range value
select col1, lead(col1, 1.7976931348623157E+309, 100) over(order by col1) from lead_err order by 1, 2;
select col1, lead(col2, 2147483649, 10.5) over(order by col1) from lead_err order by 1, 2;
select col1, lead(col3, -1, 'aaa') over(order by col1) from lead_err order by 1, 2;

--TEST: null value
select col1, lead(null) over(order by col1) from lead_err order by 1, 2;
select col1, lead(col2, null) over(order by col1) from lead_err order by 1, 2;
select col1, lead(col5, 3, null) over(order by col1) from lead_err order by 1, 2;
select col1, lead(null, null, null) over(order by col1) from lead_err order by 1, 2;


drop table lead_err; 















