--TEST: test with bit strings and blob/clob data types and normal syntax


create table dense_rank_bbc(
	col1 bit(20),
	col2 bit varying, 
	col3 blob,
	col4 clob
);


insert into dense_rank_bbc values(B'1011', X'abc', X'0', 'cubrid');
insert into dense_rank_bbc values(B'1011', x'bcd', X'1', 'cubrid');
insert into dense_rank_bbc values(B'1011', X'abc', X'2', 'cubrid');
insert into dense_rank_bbc values(B'1011', x'bcd', X'3', 'cubrid');
insert into dense_rank_bbc values(B'1011', X'abc', X'4', 'cubrid');
insert into dense_rank_bbc values(B'1001', x'bcd', X'5', 'cubrid');
insert into dense_rank_bbc values(B'1001', X'abc', X'6', 'cubrid');
insert into dense_rank_bbc values(B'1001', X'abc', X'7', 'cubrid');
insert into dense_rank_bbc values(B'1001', X'cde', X'8', 'cubrid');
insert into dense_rank_bbc values(B'0011', X'abc', X'9', 'cubrid');
insert into dense_rank_bbc values(B'0011', X'abc', X'10', 'mysql');
insert into dense_rank_bbc values(B'0011', X'cde', X'11', 'mysql');
insert into dense_rank_bbc values(B'1010', X'abc', X'12', 'mysql');
insert into dense_rank_bbc values(B'1111', X'abc', X'13', 'mysql');
insert into dense_rank_bbc values(B'1111', x'bcd', X'14', 'mysql');
insert into dense_rank_bbc values(B'1111', X'abc', X'15', 'mysql');
insert into dense_rank_bbc values(B'1111', X'abc', X'16', 'mysql');
insert into dense_rank_bbc values(B'1111', X'cde', X'17', 'mysql');
insert into dense_rank_bbc values(B'1111', X'abc', X'18', 'mysql');
insert into dense_rank_bbc values(B'1111', X'abc', X'19', 'mysql');


--TEST: OVER() clause
--TEST: no alias 
select d_rank from (select  col1, col2, dense_rank() over() d_rank from dense_rank_bbc) order by 1;
--TEST: with alias
select d_rank from (select  col2, blob_to_bit(col3), dense_rank() over(partition by null order by null) d_rank from dense_rank_bbc) order by 1;
--TEST: blob
select d_rank from (select  blob_to_bit(col3), clob_to_char(col4), dense_rank() over() d_rank from dense_rank_bbc where col1 > B'1011') order by 1;
--TEST: clob
select d_rank from (select  clob_to_char(col4), col1, dense_rank() over() d_rank from dense_rank_bbc) order by 1;
--TEST: syntax error
select col1, blob_to_bit(col3), clob_to_char(col4), dense_rank() over d_rank from dense_rank_bbc;
select col1, blob_to_bit(col3), col2, dense_rank() over(1) d_rank from dense_rank_bbc;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by bit(n)
select col1, col2, blob_to_bit(col3), clob_to_char(col4), dense_rank() over(partition by col1) d_rank from dense_rank_bbc order by 1, 2, blob_to_bit(col3), clob_to_char(col4);
--TEST: partition by bit varying
select col1, col2, blob_to_bit(col3), clob_to_char(col4), dense_rank() over(partition by col2) d_rank from dense_rank_bbc order by 2, 1, blob_to_bit(col3), clob_to_char(col4);
--TEST: partition by blob
select col1, col2, blob_to_bit(col3), clob_to_char(col4), dense_rank() over(partition by 3) d_rank from dense_rank_bbc order by blob_to_bit(col3), 1, 2, clob_to_char(col4);
--TEST: partition by clob
select col1, col2, blob_to_bit(col3), clob_to_char(col4), dense_rank() over(partition by 4) d_rank from dense_rank_bbc order by clob_to_char(col4), 1, 2, blob_to_bit(col3), 5;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, dense_rank() over(order by col1) d_rank from dense_rank_bbc;
--TEST: order by 2 column names
select col2, blob_to_bit(col3), dense_rank() over(order by col2, blob_to_bit(col3) asc) d_rank from dense_rank_bbc;
--TEST: order by more than 2 column names
select col1, col2, blob_to_bit(col3), clob_to_char(col4), dense_rank() over(order by col1, col2 desc, blob_to_bit(col3), clob_to_char(col4) asc) d_rank from dense_rank_bbc;
--TEST: order by columns not selected
select blob_to_bit(col3), dense_rank() over(order by clob_to_char(col4) desc, col2, col1 asc) d_rank from dense_rank_bbc order by 1, 2;
--TEST: order by 1 position
select clob_to_char(col4), dense_rank() over(order by 1) d_rank from dense_rank_bbc;
--TEST: order by 3 positions
select blob_to_bit(col3), col2, dense_rank() over(order by blob_to_bit(col3), 2 desc, 3 asc) d_rank from dense_rank_bbc;
--TEST: order by more than 3 positions
select col1, col2, blob_to_bit(col3), clob_to_char(col4), dense_rank() over(order by blob_to_bit(col3), 2 asc, 1 desc, clob_to_char(col4)) d_rank from dense_rank_bbc;
--TEST: order by positions not existed
select col2, dense_rank() over(order by 2) d_rank from dense_rank_bbc;
select col1, dense_rank() over(order by 3, 4, 1 desc) rank, col2, clob_to_char(col4) from dense_rank_bbc;
select blob_to_bit(col3), clob_to_char(col4), dense_rank() over(order by 5) d_rank from dense_rank_bbc;
select blob_to_bit(col3), col1, dense_rank() over(order by 100) d_rank from dense_rank_bbc;
--TEST: order by column names and positions
select col1, col2, blob_to_bit(col3), clob_to_char(col4), dense_rank() over(order by 1, col2 desc, 3, clob_to_char(col4) asc) d_rank from dense_rank_bbc;




--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by bit(n)
select col1, col2, blob_to_bit(col3), dense_rank() over(partition by col1 order by col1, blob_to_bit(col3)) from dense_rank_bbc;
--TEST: partition by bit varying
select col2, clob_to_char(col4), col1, dense_rank() over(partition by col2 order by col2, clob_to_char(col4), col1 desc) from dense_rank_bbc;
--TEST: partition by blob
select blob_to_bit(col3), dense_rank() over(partition by 1 order by blob_to_bit(col3), clob_to_char(col4)) rank, col2 from dense_rank_bbc;
--TEST: partition by clob
select clob_to_char(col4), col1, dense_rank() over(partition by 1 order by clob_to_char(col4), 2 desc) d_rank from dense_rank_bbc;
--TEST: syntax error
select col1, col2, dense_rank() over(order by col1, col2 partition by col2) from dense_rank_bbc;


delete from dense_rank_bbc;
drop table dense_rank_bbc; 















