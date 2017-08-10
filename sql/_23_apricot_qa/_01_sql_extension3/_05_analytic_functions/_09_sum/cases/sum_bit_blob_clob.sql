--TEST: test with bit strings and blob/clob data types and normal syntax


create table sum_bbc(
	col1 bit(20),
	col2 bit varying, 
	col3 blob,
	col4 clob,
	col5 bigint
);


insert into sum_bbc values(B'1011', X'abc', X'0', char_to_clob('123'), 123.5678);
insert into sum_bbc values(B'1011', x'bcd', X'1', char_to_clob('11111'), 123.1234);
insert into sum_bbc values(B'1011', X'abc', X'2', char_to_clob('9898'), 123.2345);
insert into sum_bbc values(B'1011', x'bcd', X'3', char_to_clob('123.456'), 123.5678);
insert into sum_bbc values(B'1011', X'abc', X'4', char_to_clob('9999999'), 123.1234);
insert into sum_bbc values(B'1001', x'bcd', X'5', char_to_clob('9999999'), 123.2345);
insert into sum_bbc values(B'1001', X'abc', X'6', char_to_clob('123'), 123.3456);
insert into sum_bbc values(B'1001', X'abc', X'7', char_to_clob('123'), 123.3456);
insert into sum_bbc values(B'1001', X'cde', X'8', char_to_clob('123.456'), 123.3456);
insert into sum_bbc values(B'0011', X'abc', X'9', char_to_clob('7766'), 123.5678);
insert into sum_bbc values(B'0011', X'abc', X'10', char_to_clob('9898'), 123.4567);
insert into sum_bbc values(B'0011', X'cde', X'11', char_to_clob('123.456'), 123.5678);
insert into sum_bbc values(B'1010', X'abc', X'12', char_to_clob('3333'), 123.1234);
insert into sum_bbc values(B'1111', X'abc', X'13', char_to_clob('123'), 123.4567);
insert into sum_bbc values(B'1111', x'bcd', X'14', char_to_clob('9898'), 123.2345);
insert into sum_bbc values(B'1111', X'abc', X'15', char_to_clob('7766'), 123.4567);
insert into sum_bbc values(B'1111', X'abc', X'16', char_to_clob('9898'), 123.1357);
insert into sum_bbc values(B'1111', X'cde', X'17', char_to_clob('123'), 123.1357);
insert into sum_bbc values(B'1111', X'abc', X'18', char_to_clob('999999'), 123.9999);
insert into sum_bbc values(B'1111', X'abc', X'19', char_to_clob('9999999'), 123.9999);


--TEST: OVER() clause
--TEST: bit(n) 
select trunc(summary, 2) from (select col1, col2, sum(col5) over() summary from sum_bbc) order by 1;
--TEST: bit varying, with alias+all
select col2, blob_to_bit(col3), sum(all col5) over() summary from sum_bbc order by 1, blob_to_bit(col3);
--TEST: blob, with where clause
select blob_to_bit(col3), clob_to_char(col4), sum(col5) over() summary from sum_bbc where col1 > B'1011' order by blob_to_bit(col3), clob_to_char(col4);
--TEST: clob, distinct
select clob_to_char(col4), col1, sum(unique clob_to_char(col4)) over() summary from sum_bbc order by clob_to_char(col4), 2;
--TEST: syntax error
select col1, blob_to_bit(col3), clob_to_char(col4), sum(col5) over summary from sum_bbc;
select col1, blob_to_bit(col3), col2, sum(col5) over(1) summary from sum_bbc;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by bit(n)
select trunc(summary, 2) from (select col1, col2, blob_to_bit(col3), clob_to_char(col4), sum(col5) over(partition by col1) summary from sum_bbc) order by 1;
--TEST: partition by bit varying
select col1, col2, blob_to_bit(col3), clob_to_char(col4), sum(all clob_to_char(col4)) over(partition by col2) summary from sum_bbc order by 2, 1, blob_to_bit(col3), clob_to_char(col4);
--TEST: partition by blob
select trunc(summary, 2) from (select col1, col2, blob_to_bit(col3), clob_to_char(col4), sum(distinctrow col5) over(partition by 3) summary from sum_bbc) order by 1;
--TEST: partition by clob
select col1, col2, blob_to_bit(col3), clob_to_char(col4), sum(all col5) over(partition by 4) summary from sum_bbc order by clob_to_char(col4), 1, 2, blob_to_bit(col3), 5;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select trunc(summary, 2) from (select col1, sum(col5) over(order by col1) summary from sum_bbc) order by 1;
--TEST: order by 2 column names
select col2, blob_to_bit(col3), sum(all clob_to_char(col4)) over(order by col2, blob_to_bit(col3) asc) summary1, sum(all clob_to_char(col4)) over() summary2 from sum_bbc;
--TEST: order by more than 2 column names
select col1, col2, blob_to_bit(col3), clob_to_char(col4), sum(unique col5) over(order by col1, col2 desc, blob_to_bit(col3), clob_to_char(col4) asc) summary from sum_bbc;
--TEST: order by columns not selected
select blob_to_bit(col3), sum(distinct clob_to_char(col4)) over(order by clob_to_char(col4) desc, col2, col1 asc) summary from sum_bbc order by 1, 2;
--TEST: order by 1 position
select clob_to_char(col4), sum(all col5) over(order by 1) summary from sum_bbc;
--TEST: order by 3 positions
select blob_to_bit(col3), col2, sum(clob_to_char(col4)) over(order by blob_to_bit(col3), 2 desc, 3 asc) summary from sum_bbc;
--TEST: order by more than 3 positions
select col1, col2, blob_to_bit(col3), clob_to_char(col4), sum(unique col5) over(order by blob_to_bit(col3), 2 asc, 1 desc, clob_to_char(col4)) summary from sum_bbc;
--TEST: order by positions not existed
select col2, sum(distinct col5) over(order by 2) summary from sum_bbc;
select col1, sum(all col5) over(order by 3, 4, 1 desc) summary, col2, clob_to_char(col4) from sum_bbc;
select blob_to_bit(col3), clob_to_char(col4), sum(col5) over(order by 5) summary from sum_bbc;
select blob_to_bit(col3), col1, sum(col5) over(order by 100) summary from sum_bbc;
--TEST: order by column names and positions
select col1, col2, blob_to_bit(col3), clob_to_char(col4), sum(distinctrow col5) over(order by 1, col2 desc, 3, clob_to_char(col4) asc) summary from sum_bbc;




--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by bit(n)
select col1, col2, blob_to_bit(col3), sum(distinct clob_to_char(col4)) over(partition by col1 order by 1, 2, blob_to_bit(col3)) summary1, sum(distinct clob_to_char(col4)) over(partition by col1) summary2 from sum_bbc;
--TEST: partition by bit varying
select col2, clob_to_char(col4), col1, sum(col5) over(partition by col2 order by col2, clob_to_char(col4), col1 desc) from sum_bbc;
--TEST: partition by blob
select summary from (select blob_to_bit(col3), sum(all clob_to_char(col4)) over(partition by col3 order by blob_to_bit(col3), clob_to_char(col4), 3) summary, col2 from sum_bbc) order by 1;
--TEST: partition by clob
select clob_to_char(col4), col1, sum(unique col5) over(partition by col4 order by clob_to_char(col4), 2 desc) summary from sum_bbc;
--TEST: syntax error
select col1, col2, sum(distinct col5) over(order by col1, col2 partition by col2) from sum_bbc;


delete from sum_bbc;
drop table sum_bbc; 















