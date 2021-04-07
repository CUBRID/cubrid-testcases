--+ holdcas on;

--TEST: test with bit strings and blob/clob data types and normal syntax


create table rownum_bbc(
	col1 bit(20),
	col2 bit varying, 
	col3 blob,
	col4 clob
);


insert into rownum_bbc values(B'1011', X'abc', X'0', 'cubrid');
insert into rownum_bbc values(B'1011', x'bcd', X'1', 'cubrid');
insert into rownum_bbc values(B'1011', X'abc', X'2', 'cubrid');
insert into rownum_bbc values(B'1011', x'bcd', X'3', 'cubrid');
insert into rownum_bbc values(B'1011', X'abc', X'4', 'cubrid');
insert into rownum_bbc values(B'1001', x'bcd', X'5', 'cubrid');
insert into rownum_bbc values(B'1001', X'abc', X'6', 'cubrid');
insert into rownum_bbc values(B'1001', X'abc', X'7', 'cubrid');
insert into rownum_bbc values(B'1001', X'cde', X'8', 'cubrid');
insert into rownum_bbc values(B'0011', X'abc', X'9', 'cubrid');
insert into rownum_bbc values(B'0011', X'abc', X'10', 'mysql');
insert into rownum_bbc values(B'0011', X'cde', X'11', 'mysql');
insert into rownum_bbc values(B'1010', X'abc', X'12', 'mysql');
insert into rownum_bbc values(B'1111', X'abc', X'13', 'mysql');
insert into rownum_bbc values(B'1111', x'bcd', X'14', 'mysql');
insert into rownum_bbc values(B'1111', X'abc', X'15', 'mysql');
insert into rownum_bbc values(B'1111', X'abc', X'16', 'mysql');
insert into rownum_bbc values(B'1111', X'cde', X'17', 'mysql');
insert into rownum_bbc values(B'1111', X'abc', X'18', 'mysql');
insert into rownum_bbc values(B'1111', X'abc', X'19', 'mysql');


--TEST: OVER() clause
--TEST: no alias 
select row_number() over() from rownum_bbc order by 1;
--TEST: with alias
select row_num from (select col2, blob_to_bit(col3), row_number() over() row_num from rownum_bbc) order by 1;
--TEST: blob
select row_num from (select blob_to_bit(col3), clob_to_char(col4), row_number() over() row_num from rownum_bbc where col1 > B'1011') order by 1;
--TEST: clob
select row_num from (select clob_to_char(col4), col1, row_number() over() row_num from rownum_bbc) order by 1;
--TEST: syntax error
select col1, blob_to_bit(col3), clob_to_char(col4), row_number() over row_num from rownum_bbc;
select col1, blob_to_bit(col3), col2, row_number() over(1) row_num from rownum_bbc;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by bit(n)
select row_num from (select col1, col2, blob_to_bit(col3), clob_to_char(col4), row_number() over(partition by col1) row_num from rownum_bbc) order by 1;
--TEST: partition by bit varying
select row_num from (select col1, col2, blob_to_bit(col3), clob_to_char(col4), row_number() over(partition by col2) row_num from rownum_bbc) order by 1;
--TEST: partition by blob
select col1, col2, blob_to_bit(col3), clob_to_char(col4), row_number() over(partition by col3) row_num from rownum_bbc order by blob_to_bit(col3), 1, 2, clob_to_char(col4);
select row_num from (select col1, col2, blob_to_bit(col3), clob_to_char(col4), row_number() over(partition by blob_to_bit(col3)) row_num from rownum_bbc) order by 1;
--TEST: partition by clob
select col1, col2, blob_to_bit(col3), clob_to_char(col4), row_number() over(partition by col4) row_num from rownum_bbc order by clob_to_char(col4), 1, 2, blob_to_bit(col3), 5;
select row_num from (select col1, col2, blob_to_bit(col3), clob_to_char(col4), row_number() over(partition by clob_to_char(col4)) row_num from rownum_bbc) order by 1;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, row_number() over(order by col1) row_num from rownum_bbc order by 1, 2;
--TEST: order by 2 column names
select col2, blob_to_bit(col3), row_number() over(order by col2, blob_to_bit(col3) asc) row_num from rownum_bbc order by 1, 2, 3;
--TEST: order by blob column
select col2, blob_to_bit(col3), row_number() over(order by col3) row_num from rownum_bbc;
--TEST: order by clob column
select col2, blob_to_bit(col3), clob_to_char(col4), row_number() over(order by col4 desc) row_num from rownum_bbc;
--TEST: order by more than 2 column names
select col1, col2, blob_to_bit(col3), clob_to_char(col4), row_number() over(order by col1, col2 desc, blob_to_bit(col3), clob_to_char(col4) asc) row_num from rownum_bbc order by 1, 2, 3, 4, 5;
--TEST: order by columns not selected
select row_num from (select blob_to_bit(col3), row_number() over(order by clob_to_char(col4) desc, col2, col1 asc) row_num from rownum_bbc) order by 1;
--TEST: order by 1 position
select clob_to_char(col4), row_number() over(order by 1) row_num from rownum_bbc order by 1, 2;
--TEST: order by 3 positions
select blob_to_bit(col3), col2, row_number() over(order by blob_to_bit(col3), 2 desc, 3 asc) row_num from rownum_bbc order by 1, 2, 3;
--TEST: order by more than 3 positions
select col1, col2, blob_to_bit(col3), clob_to_char(col4), row_number() over(order by blob_to_bit(col3), 2 asc, 1 desc, clob_to_char(col4)) row_num from rownum_bbc order by 1, 2, 3, 4, 5;
--TEST: order by positions not existed
select col2, row_number() over(order by 2) row_num from rownum_bbc order by 1, 2;
select col1, row_number() over(order by 3, 4, 1 desc) row_num, col2, clob_to_char(col4) from rownum_bbc order by 1, 2;
select blob_to_bit(col3), clob_to_char(col4), row_number() over(order by 5) row_num from rownum_bbc;
select blob_to_bit(col3), col1, row_number() over(order by 100) row_num from rownum_bbc;
--TEST: order by column names and positions
select col1, col2, blob_to_bit(col3), clob_to_char(col4), row_number() over(order by 1, col2 desc, 3, clob_to_char(col4) asc) row_num from rownum_bbc order by 1, 2, 3, 4, 5;




--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by bit(n)
select col1, col2, blob_to_bit(col3), row_number() over(partition by col1 order by col1, blob_to_bit(col3)) from rownum_bbc;
--TEST: partition by bit varying
select col2, clob_to_char(col4), col1, row_number() over(partition by col2 order by col2, clob_to_char(col4), col1 desc) from rownum_bbc;
--TEST: partition by blob
select blob_to_bit(col3), row_number() over(partition by col3 order by blob_to_bit(col3), clob_to_char(col4)) row_num, col2 from rownum_bbc;
--TEST: partition by clob
select clob_to_char(col4), col1, row_number() over(partition by col4 order by clob_to_char(col4), 2 desc) row_num from rownum_bbc;
select clob_to_char(col4), col1, row_number() over(partition by clob_to_char(col4) order by 2, 1 desc) row_num from rownum_bbc;
--TEST: syntax error
select col1, col2, row_number() over(order by col1, col2 partition by col2) from rownum_bbc;


delete from rownum_bbc;

drop table rownum_bbc; 
--+ holdcas off;














