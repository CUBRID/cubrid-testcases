--TEST: test with reuse_oid tables 


create table rank_bbc_2(
	col1 bit(20),
	col2 bit varying, 
	col3 blob,
	col4 clob
) reuse_oid;


insert into rank_bbc_2 values(B'1011', X'abc', X'0', char_to_clob('cubrid'));
insert into rank_bbc_2 values(B'1011', x'bcd', X'1', char_to_clob('cubrid'));
insert into rank_bbc_2 values(B'1011', X'abc', X'2', char_to_clob('cubrid'));
insert into rank_bbc_2 values(B'1011', x'bcd', X'3', char_to_clob('cubrid'));
insert into rank_bbc_2 values(B'1011', X'abc', X'4', char_to_clob('cubrid'));
insert into rank_bbc_2 values(B'1001', x'bcd', X'5', char_to_clob('cubrid'));
insert into rank_bbc_2 values(B'1001', X'abc', X'6', char_to_clob('cubrid'));
insert into rank_bbc_2 values(B'1001', X'abc', X'7', char_to_clob('cubrid'));
insert into rank_bbc_2 values(B'1001', X'cde', X'8', char_to_clob('cubrid'));
insert into rank_bbc_2 values(B'0011', X'abc', X'9', char_to_clob('cubrid'));
insert into rank_bbc_2 values(B'0011', X'abc', X'10', char_to_clob('mysql'));
insert into rank_bbc_2 values(B'0011', X'cde', X'11', char_to_clob('mysql'));
insert into rank_bbc_2 values(B'1010', X'abc', X'12', char_to_clob('mysql'));
insert into rank_bbc_2 values(B'1111', X'abc', X'13', char_to_clob('mysql'));
insert into rank_bbc_2 values(B'1111', x'bcd', X'14', char_to_clob('mysql'));
insert into rank_bbc_2 values(B'1111', X'abc', X'15', char_to_clob('mysql'));
insert into rank_bbc_2 values(B'1111', X'abc', X'16', char_to_clob('mysql'));
insert into rank_bbc_2 values(B'1111', X'cde', X'17', char_to_clob('mysql'));
insert into rank_bbc_2 values(B'1111', X'abc', X'18', char_to_clob('mysql'));
insert into rank_bbc_2 values(B'1111', X'abc', X'19', char_to_clob('mysql'));


--TEST: OVER() clause
--TEST: no alias 
select col1, col2, rank() over() from rank_bbc_2 order by 1, 2;
--TEST: with alias
select col2, blob_to_bit(col3), rank() over() rank from rank_bbc_2 order by 1, blob_to_bit(col3);
--TEST: blob
select blob_to_bit(col3), clob_to_char(col4), rank() over() rank from rank_bbc_2 where col1 > B'1011' order by blob_to_bit(col3), clob_to_char(col4);
--TEST: clob
select clob_to_char(col4), col1, rank() over() rank from rank_bbc_2 order by clob_to_char(col4), 2;
--TEST: syntax error
select col1, blob_to_bit(col3), clob_to_char(col4), rank() over rank from rank_bbc_2;
select col1, blob_to_bit(col3), col2, rank() over(1) rank from rank_bbc_2;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by bit(n)
select col1, col2, blob_to_bit(col3), clob_to_char(col4), rank() over(partition by col1) rank from rank_bbc_2 order by 1, 2, blob_to_bit(col3), clob_to_char(col4);
--TEST: partition by bit varying
select col1, col2, blob_to_bit(col3), clob_to_char(col4), rank() over(partition by col2) rank from rank_bbc_2 order by 2, 1, blob_to_bit(col3), clob_to_char(col4);
--TEST: partition by blob
select col1, col2, blob_to_bit(col3), clob_to_char(col4), rank() over(partition by col3) rank from rank_bbc_2 order by blob_to_bit(col3), 1, 2, clob_to_char(col4);
--TEST: partition by clob
select col1, col2, blob_to_bit(col3), clob_to_char(col4), rank() over(partition by col4) rank from rank_bbc_2 order by clob_to_char(col4), 1, 2, blob_to_bit(col3), 5;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, rank() over(order by col1) rank from rank_bbc_2;
--TEST: order by 2 column names
select col2, blob_to_bit(col3), rank() over(order by col2, blob_to_bit(col3) asc) rank from rank_bbc_2;
--TEST: order by more than 2 column names
select col1, col2, blob_to_bit(col3), clob_to_char(col4), rank() over(order by col1, col2 desc, blob_to_bit(col3), clob_to_char(col4) asc) rank from rank_bbc_2;
--TEST: order by columns not selected
select blob_to_bit(col3), rank() over(order by clob_to_char(col4) desc, col2, col1 asc) rank from rank_bbc_2 order by 1, 2;
--TEST: order by 1 position
select clob_to_char(col4), rank() over(order by 1) rank from rank_bbc_2;
--TEST: order by 3 positions
select blob_to_bit(col3), col2, rank() over(order by blob_to_bit(col3), 2 desc, 3 asc) rank from rank_bbc_2;
--TEST: order by more than 3 positions
select col1, col2, blob_to_bit(col3), clob_to_char(col4), rank() over(order by blob_to_bit(col3), 2 asc, 1 desc, clob_to_char(col4)) rank from rank_bbc_2;
--TEST: order by positions not existed
select col2, rank() over(order by 2) rank from rank_bbc_2;
select col1, rank() over(order by 3, 4, 1 desc) rank, col2, clob_to_char(col4) from rank_bbc_2;
select blob_to_bit(col3), clob_to_char(col4), rank() over(order by 5) rank from rank_bbc_2;
select blob_to_bit(col3), col1, rank() over(order by 100) rank from rank_bbc_2;
--TEST: order by column names and positions
select col1, col2, blob_to_bit(col3), clob_to_char(col4), rank() over(order by 1, col2 desc, 3, clob_to_char(col4) asc) rank from rank_bbc_2;




--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by bit(n)
select col1, col2, blob_to_bit(col3), rank() over(partition by col1 order by col1, blob_to_bit(col3)) from rank_bbc_2;
--TEST: partition by bit varying
select col2, clob_to_char(col4), col1, rank() over(partition by col2 order by col2, clob_to_char(col4), col1 desc) from rank_bbc_2;
--TEST: partition by blob
select blob_to_bit(col3), rank() over(partition by col3 order by blob_to_bit(col3), clob_to_char(col4)) rank, col2 from rank_bbc_2;
--TEST: partition by clob
select clob_to_char(col4), col1, rank() over(partition by col4 order by clob_to_char(col4), 2 desc) rank from rank_bbc_2;
--TEST: syntax error
select col1, col2, rank() over(order by col1, col2 partition by col2) from rank_bbc_2;



delete from rank_bbc_2;
drop table rank_bbc_2; 















