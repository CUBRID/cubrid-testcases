--TEST: pass bit/blob/clob type values to the second param

drop table if exists p_cont;
create table p_cont(
	col1 bit(20),
	col2 bit varying, 
	col3 blob,
	col4 clob,
	num int
);


insert into p_cont values(B'1011', X'abc', X'0', 'cubrid', 70);
insert into p_cont values(B'1011', x'bcd', X'1', 'cubrid', 60);
insert into p_cont values(B'1011', X'abc', X'2', 'cubrid', 50);
insert into p_cont values(B'1011', x'bcd', X'3', 'cubrid', 90);
insert into p_cont values(B'1011', X'abc', X'4', 'cubrid', 85);
insert into p_cont values(B'1001', x'bcd', X'5', 'cubrid', 80);
insert into p_cont values(B'1001', X'abc', X'6', 'cubrid', 70);
insert into p_cont values(B'1001', X'abc', X'7', 'cubrid', 95);
insert into p_cont values(B'1001', X'cde', X'8', 'cubrid', 40);
insert into p_cont values(B'0011', X'abc', X'9', 'cubrid', 90);
insert into p_cont values(B'0011', X'abc', X'10', 'mysql', 60);
insert into p_cont values(B'0011', X'cde', X'11', 'mysql', 55);
insert into p_cont values(B'1010', X'abc', X'12', 'mysql', 90);
insert into p_cont values(B'1111', X'abc', X'13', 'mysql', 70);
insert into p_cont values(B'1111', x'bcd', X'14', 'mysql', 90);
insert into p_cont values(B'1111', X'abc', X'15', 'mysql', 35);
insert into p_cont values(B'1111', X'abc', X'16', 'mysql', 60);
insert into p_cont values(B'1111', X'cde', X'17', 'mysql', 60);
insert into p_cont values(B'1111', X'abc', X'18', 'mysql', 75);
insert into p_cont values(B'1111', X'abc', X'19', 'mysql', 80);


--test: pass constant bit/blob/clob values to the second param
select col2, percentile_cont(0.8) within group(order by B'0001') from p_cont group by col2 order by 1, 2;
select col2, blob_to_bit(col3), percentile_cont(0.2) within group(order by X'0') from p_cont group by col2 order by 1, 2;
select col2, percentile_cont(0.3) within group(order by bit_to_blob(X'100')) from p_cont group by col2 order by 1, 2;
select col2, percentile_cont(0.5) within group(order by char_to_clob('100')) from p_cont group by col2 order by 1, 2;

--test: pass bit/blob/clob type columns to the second param
select col2, percentile_cont(0.5) within group(order by col1) from p_cont group by col2 order by 1, 2;
select col2, percentile_cont(0.1) within group(order by col2) from p_cont group by col2 order by 1, 2;
select col2, percentile_cont(0.8) within group(order by col3) from p_cont group by col2 order by 1, 2;
select col2, percentile_cont(0.9) within group(order by col4) from p_cont group by col2 order by 1, 2;
select col2, percentile_cont(0.9) within group(order by blob_to_bit(col3)) from p_cont group by col2 order by 1, 2;
select col2, percentile_cont(0.9) within group(order by clob_to_char(col4)) from p_cont group by col2 order by 1, 2;

--test: [er] pass more than 1 columns to the second param
select col2, percentile_cont(0.5) within group(order by col1, col3) from p_cont group by col2 order by 1, 2;
select col2, percentile_cont(0.1) within group(order by col2, col4, col1) from p_cont group by col2 order by 1, 2;
select col2, col3, col4, percentile_cont(0.8) within group(order by 3, 2, 1) from p_cont group by col2, col3, col4 order by 1, 2;


drop table p_cont;









