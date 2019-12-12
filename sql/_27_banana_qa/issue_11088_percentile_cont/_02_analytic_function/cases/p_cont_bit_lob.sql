--TEST: test with bit strings and blob/clob data types and normal syntax

drop table if exists p_cont_bbc;
create table p_cont_bbc(
	col1 bit(20),
	col2 bit varying, 
	col3 blob,
	col4 clob,
	col5 double
);


insert into p_cont_bbc values(B'1011', X'abc', X'0', char_to_clob('123'), 123.5678);
insert into p_cont_bbc values(B'1011', x'bcd', X'1', char_to_clob('11111'), 123.1234);
insert into p_cont_bbc values(B'1011', X'abc', X'2', char_to_clob('9898'), 123.2345);
insert into p_cont_bbc values(B'1011', x'bcd', X'3', char_to_clob('123.456'), 123.5678);
insert into p_cont_bbc values(B'1011', X'abc', X'4', char_to_clob('9999999'), 123.1234);
insert into p_cont_bbc values(B'1001', x'bcd', X'5', char_to_clob('9999999'), 123.2345);
insert into p_cont_bbc values(B'1001', X'abc', X'6', char_to_clob('123'), 123.3456);
insert into p_cont_bbc values(B'1001', X'abc', X'7', char_to_clob('123'), 123.3456);
insert into p_cont_bbc values(B'1001', X'cde', X'8', char_to_clob('123.456'), 123.3456);
insert into p_cont_bbc values(B'0011', X'abc', X'9', char_to_clob('7766'), 123.5678);
insert into p_cont_bbc values(B'0011', X'abc', X'10', char_to_clob('9898'), 123.4567);
insert into p_cont_bbc values(B'0011', X'cde', X'11', char_to_clob('123.456'), 123.5678);
insert into p_cont_bbc values(B'1010', X'abc', X'12', char_to_clob('3333'), 123.1234);
insert into p_cont_bbc values(B'1111', X'abc', X'13', char_to_clob('123'), 123.4567);
insert into p_cont_bbc values(B'1111', x'bcd', X'14', char_to_clob('9898'), 123.2345);
insert into p_cont_bbc values(B'1111', X'abc', X'15', char_to_clob('7766'), 123.4567);
insert into p_cont_bbc values(B'1111', X'abc', X'16', char_to_clob('9898'), 123.1357);
insert into p_cont_bbc values(B'1111', X'cde', X'17', char_to_clob('123'), 123.1357);
insert into p_cont_bbc values(B'1111', X'abc', X'18', char_to_clob('999999'), 123.9999);
insert into p_cont_bbc values(B'1111', X'abc', X'19', char_to_clob('9999999'), 123.9999);


--TEST: OVER() clause
--TEST: bit(n) 
select  col1, col2, percentile_cont(0.1) within group (order by col1) over() p_cont from p_cont_bbc order by 1, 2, 3;
--TEST: bit varying, with alias
select  col2, blob_to_bit(col3), percentile_cont(0.2) within group (order by col2) over() p_cont from p_cont_bbc order by 1, 2, 3;
--TEST: blob, with where clause
select  blob_to_bit(col3), clob_to_char(col4), percentile_cont(0.3) within group (order by col3) over() p_cont from p_cont_bbc where col1 > B'1011' order by 1, 2, 3;
select  blob_to_bit(col3), clob_to_char(col4), percentile_cont(0.3) within group (order by blob_to_bit(col3)) over() p_cont from p_cont_bbc where col1 > B'1011' order by 1, 2, 3;
--TEST: clob
select  clob_to_char(col4), col1, percentile_cont(0.4) within group (order by clob_to_char(col4)) over() p_cont from p_cont_bbc order by 1, 2, 3;
select  col1, col2, blob_to_bit(col3), clob_to_char(col4), percentile_cont(0.5) within group (order by col4) over() p_cont from p_cont_bbc order by 1, 2, 3;
--TEST: wrong type of arguments
select percentile_cont(col1) within group (order by col5) over() p_cont from p_cont_bbc;
select percentile_cont(col2) within group (order by col5) over() p_cont from p_cont_bbc;
select percentile_cont(col3) within group (order by col5) over() p_cont from p_cont_bbc;
select percentile_cont(col4) within group (order by col5) over() p_cont from p_cont_bbc;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by bit(n)
select  col1, col2, blob_to_bit(col3), clob_to_char(col4), percentile_cont(0.6) within group (order by col5) over(partition by col1) p_cont from p_cont_bbc order by 1, 2, 3;
--TEST: partition by bit varying
select col2, blob_to_bit(col3), clob_to_char(col4), percentile_cont(0.7) within group (order by col5 desc) over(partition by col2) p_cont from p_cont_bbc order by 1, 2, 3;
--TEST: partition by blob
select blob_to_bit(col3), clob_to_char(col4), percentile_cont(0.8) within group (order by col5) over(partition by blob_to_bit(col3)) p_cont from p_cont_bbc order by blob_to_bit(col3), clob_to_char(col4);
select blob_to_bit(col3), clob_to_char(col4), percentile_cont(0.8) within group (order by col5) over(partition by col3) p_cont from p_cont_bbc order by blob_to_bit(col3), clob_to_char(col4);
--TEST: partition by clob
select clob_to_char(col4), percentile_cont(0.9) within group (order by col5) over(partition by clob_to_char(col4)) p_cont from p_cont_bbc order by 1, 2;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select  col1, percentile_cont(0) within group (order by col5) over(order by col1) p_cont1, percentile_cont(0.6) within group (order by col5) over() p_cont2 from p_cont_bbc order by 1, 2, 3;
--TEST: order by 2 column names
select col2, blob_to_bit(col3), percentile_cont(0.5) within group (order by clob_to_char(col4)) over(order by col2, blob_to_bit(col3) asc) p_cont from p_cont_bbc order by 1, 2;
--TEST: order by 1 position
select clob_to_char(col4), percentile_cont(0.8) within group (order by 5) over(order by 1) p_cont from p_cont_bbc order by 1, 2, 3;



--TEST: OVER(PARTITION BY ORDER BY) clause
select col1, col2, blob_to_bit(col3), percentile_cont(0.5) within group (order by clob_to_char(col4)) over(partition by col1 order by 1, 2, blob_to_bit(col3)) from p_cont_bbc;


--TEST: order by position
select col2, clob_to_char(col4), col5, percentile_cont(0.4) within group (order by 3) over(partition by col2, col1 desc) p_cont from p_cont_bbc order by 1, 2, 3;
--TEST: partition by position
select col1, blob_to_bit(col3), percentile_cont(0.6) within group (order by clob_to_char(col4)) over(partition by 1, 2) p_cont, col2 from p_cont_bbc order by 1, 2, 3;
--TEST: order by multiple columns
select clob_to_char(col4), col1, percentile_cont(0.9) within group (order by col5, col1) over(partition by clob_to_char(col4), 2 desc) p_cont from p_cont_bbc;


delete from p_cont_bbc;
drop table p_cont_bbc; 















