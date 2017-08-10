--TEST: test with bit strings and blob/clob data types and normal syntax


create table count_bbc(
	col1 bit(20),
	col2 bit varying, 
	col3 blob,
	col4 clob
);


insert into count_bbc values(B'1011', X'abc', X'0', 'cubrid');
insert into count_bbc values(B'1011', x'bcd', X'1', 'cubrid');
insert into count_bbc values(B'1011', X'abc', X'2', 'cubrid');
insert into count_bbc values(B'1011', x'bcd', X'3', 'cubrid');
insert into count_bbc values(B'1011', X'abc', X'4', 'cubrid');
insert into count_bbc values(B'1001', x'bcd', X'5', 'cubrid');
insert into count_bbc values(B'1001', X'abc', X'6', 'cubrid');
insert into count_bbc values(B'1001', X'abc', X'7', 'cubrid');
insert into count_bbc values(B'1001', X'cde', X'8', 'cubrid');
insert into count_bbc values(B'0011', X'abc', X'9', 'cubrid');
insert into count_bbc values(B'0011', X'abc', X'10', 'mysql');
insert into count_bbc values(B'0011', X'cde', X'11', 'mysql');
insert into count_bbc values(B'1010', X'abc', X'12', 'mysql');
insert into count_bbc values(B'1111', X'abc', X'13', 'mysql');
insert into count_bbc values(B'1111', x'bcd', X'14', 'mysql');
insert into count_bbc values(B'1111', X'abc', X'15', 'mysql');
insert into count_bbc values(B'1111', X'abc', X'16', 'mysql');
insert into count_bbc values(B'1111', X'cde', X'17', 'mysql');
insert into count_bbc values(B'1111', X'abc', X'18', 'mysql');
insert into count_bbc values(B'1111', X'abc', X'19', 'mysql');


--TEST: OVER() clause
--TEST: bit(n) 
select col1, col2, count(col1) over() from count_bbc order by 1, 2;
--TEST: bit varying, with alias+all
select col2, blob_to_bit(col3), count(all col2) over() cnt from count_bbc order by 1, blob_to_bit(col3);
--TEST: blob, with where clause
select blob_to_bit(col3), clob_to_char(col4), count(col3) over() cnt from count_bbc where col1 > B'1011' order by blob_to_bit(col3), clob_to_char(col4);
--TEST: clob, distinct
select clob_to_char(col4), col1, count(distinct col4) over() cnt from count_bbc order by clob_to_char(col4), 2;
--TEST: syntax error
select col1, blob_to_bit(col3), clob_to_char(col4), count(*) over cnt from count_bbc;
select col1, blob_to_bit(col3), col2, count(*) over(1) cnt from count_bbc;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by bit(n)
select col1, col2, blob_to_bit(col3), clob_to_char(col4), count(*) over(partition by col1) cnt from count_bbc order by 1, 2, blob_to_bit(col3), clob_to_char(col4);
--TEST: partition by bit varying
select col1, col2, blob_to_bit(col3), clob_to_char(col4), count(distinct col4) over(partition by col2) cnt from count_bbc order by 2, 1, blob_to_bit(col3), clob_to_char(col4);
--TEST: partition by blob
select col1, col2, blob_to_bit(col3), clob_to_char(col4), count(*) over(partition by col3) cnt from count_bbc order by blob_to_bit(col3), 1, 2, clob_to_char(col4);
--TEST: partition by clob
select col1, col2, blob_to_bit(col3), clob_to_char(col4), count(all col2) over(partition by col4) cnt from count_bbc order by clob_to_char(col4), 1, 2, blob_to_bit(col3), 5;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, count(col2) over(order by col1) cnt from count_bbc;
--TEST: order by 2 column names
select col2, blob_to_bit(col3), count(all col4) over(order by col2, blob_to_bit(col3) asc) cnt from count_bbc;
--TEST: order by more than 2 column names
select col1, col2, blob_to_bit(col3), clob_to_char(col4), count(*) over(order by col1, col2 desc, blob_to_bit(col3), clob_to_char(col4) asc) cnt from count_bbc;
--TEST: order by columns not selected
select blob_to_bit(col3), count(distinct col2) over(order by clob_to_char(col4) desc, col2, col1 asc) cnt from count_bbc order by 1;
--TEST: order by 1 position
select clob_to_char(col4), count(all col2) over(order by 1) cnt from count_bbc;
--TEST: order by 3 positions
select blob_to_bit(col3), col2, count(*) over(order by blob_to_bit(col3), 2 desc, 3 asc) cnt from count_bbc;
--TEST: order by more than 3 positions
select col1, col2, blob_to_bit(col3), clob_to_char(col4), count(*) over(order by blob_to_bit(col3), 2 asc, 1 desc, clob_to_char(col4)) cnt from count_bbc;
--TEST: order by positions not existed
select col2, count(distinct col1) over(order by 2) cnt from count_bbc;
select col1, count(all col3) over(order by 3, 4, 1 desc) cnt, col2, clob_to_char(col4) from count_bbc;
select blob_to_bit(col3), clob_to_char(col4), count(*) over(order by 5) cnt from count_bbc;
select blob_to_bit(col3), col1, count(*) over(order by 100) cnt from count_bbc;
--TEST: order by column names and positions
select col1, col2, blob_to_bit(col3), clob_to_char(col4), count(*) over(order by 1, col2 desc, 3, clob_to_char(col4) asc) cnt from count_bbc;




--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by bit(n)
select col1, col2, blob_to_bit(col3), count(distinct col4) over(partition by col1 order by 1, 2, blob_to_bit(col3)) from count_bbc;
--TEST: partition by bit varying
select col2, clob_to_char(col4), col1, count(col2) over(partition by col2 order by col2, clob_to_char(col4), col1 desc) from count_bbc;
--TEST: partition by blob
select blob_to_bit(col3), count(all col4) over(partition by col3 order by blob_to_bit(col3), clob_to_char(col4), 3) cnt, col2 from count_bbc;
--TEST: partition by clob
select clob_to_char(col4), col1, count(*) over(partition by col4 order by clob_to_char(col4), 2 desc) cnt from count_bbc;
--TEST: syntax error
select col1, col2, count(distinct col3) over(order by col1, col2 partition by col2) from count_bbc;


delete from count_bbc;
drop table count_bbc; 















