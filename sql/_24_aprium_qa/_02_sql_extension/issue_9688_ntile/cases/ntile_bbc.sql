--TEST: test with bit strings and blob/clob data types and normal syntax


create table ntile_bbc(
	col1 bit(20),
	col2 bit varying, 
	col3 blob,
	col4 clob
);


insert into ntile_bbc values(B'1011', X'abc', X'0', 'cubrid');
insert into ntile_bbc values(B'1011', x'bcd', X'1', 'cubrid');
insert into ntile_bbc values(B'1011', X'abc', X'2', 'cubrid');
insert into ntile_bbc values(B'1011', x'bcd', X'3', 'cubrid');
insert into ntile_bbc values(B'1011', X'abc', X'4', 'cubrid');
insert into ntile_bbc values(B'1001', x'bcd', X'5', 'cubrid');
insert into ntile_bbc values(B'1001', X'abc', X'6', 'cubrid');
insert into ntile_bbc values(B'1001', X'abc', X'7', 'cubrid');
insert into ntile_bbc values(B'1001', X'cde', X'8', 'cubrid');
insert into ntile_bbc values(B'0011', X'abc', X'9', 'cubrid');
insert into ntile_bbc values(B'0011', X'abc', X'10', 'mysql');
insert into ntile_bbc values(B'0011', X'cde', X'11', 'mysql');
insert into ntile_bbc values(B'1010', X'abc', X'12', 'mysql');
insert into ntile_bbc values(B'1111', X'abc', X'13', 'mysql');
insert into ntile_bbc values(B'1111', x'bcd', X'14', 'mysql');
insert into ntile_bbc values(B'1111', X'abc', X'15', 'mysql');
insert into ntile_bbc values(B'1111', X'abc', X'16', 'mysql');
insert into ntile_bbc values(B'1111', X'cde', X'17', 'mysql');
insert into ntile_bbc values(B'1111', X'abc', X'18', 'mysql');
insert into ntile_bbc values(B'1111', X'abc', X'19', 'mysql');


--TEST: OVER() clause
--TEST: no alias 
select ntile(20) over() from ntile_bbc order by 1;
--TEST: with alias
select col2, blob_to_bit(col3), ntile(4) over() b_num from ntile_bbc order by 1,2,3;
--TEST: with where clause
select blob_to_bit(col3), clob_to_char(col4), ntile(3) over() b_num from ntile_bbc where col1 > B'1011' order by 1,2,3;
--TEST: syntax error
select col1, blob_to_bit(col3), clob_to_char(col4), ntile(11) over b_num from ntile_bbc;
select col1, blob_to_bit(col3), col2, ntile(6) over(1) b_num from ntile_bbc;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by bit(n)
select col1, col2, blob_to_bit(col3), clob_to_char(col4), ntile(1) over(partition by col1) b_num from ntile_bbc order by 1,2,3,4;
--TEST: partition by bit varying
select col1, col2, blob_to_bit(col3), clob_to_char(col4), ntile(2) over(partition by col2) b_num from ntile_bbc order by 1,2,3,4;
--TEST: partition by blob
select col1, col2, blob_to_bit(col3), clob_to_char(col4), ntile(3) over(partition by col3) b_num from ntile_bbc order by blob_to_bit(col3), 1, 2, clob_to_char(col4);
select col1, col2, blob_to_bit(col3), clob_to_char(col4), ntile(4) over(partition by blob_to_bit(col3)) b_num from ntile_bbc order by 1,2,3,4,5;
--TEST: partition by clob
select col1, col2, blob_to_bit(col3), clob_to_char(col4), ntile(5) over(partition by col4) b_num from ntile_bbc order by clob_to_char(col4), 1, 2, blob_to_bit(col3), 5;
select col1, col2, blob_to_bit(col3), clob_to_char(col4), ntile(6) over(partition by clob_to_char(col4)) b_num from ntile_bbc order by 1;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, ntile(1) over(order by col1) b_num from ntile_bbc order by 1, 2;
--TEST: order by 2 column names
select col2, blob_to_bit(col3), ntile(3) over(order by col2, blob_to_bit(col3) asc) b_num from ntile_bbc order by 1, 2, 3;
--TEST: order by blob column
select col2, blob_to_bit(col3), ntile(5) over(order by col3) b_num from ntile_bbc;
--TEST: order by clob column
select col2, blob_to_bit(col3), clob_to_char(col4), ntile(7) over(order by col4 desc) b_num from ntile_bbc;
--TEST: order by more than 2 column names
select col1, col2, blob_to_bit(col3), clob_to_char(col4), ntile(9) over(order by col1, col2 desc, blob_to_bit(col3), clob_to_char(col4) asc) b_num from ntile_bbc order by 1, 2, 3, 4, 5;
--TEST: order by columns not selected
select blob_to_bit(col3), ntile(11) over(order by clob_to_char(col4) desc, col2, col1 asc) b_num from ntile_bbc order by 1,2;
--TEST: order by 1 position
select clob_to_char(col4), ntile(13) over(order by 1) b_num from ntile_bbc order by 1, 2;
--TEST: order by 3 positions
select blob_to_bit(col3), col2, ntile(15) over(order by blob_to_bit(col3), 2 desc, 3 asc) b_num from ntile_bbc order by 1, 2, 3;
--TEST: order by more than 3 positions
select col1, col2, blob_to_bit(col3), clob_to_char(col4), ntile(17) over(order by blob_to_bit(col3), 2 asc, 1 desc, clob_to_char(col4)) b_num from ntile_bbc order by 1, 2, 3, 4, 5;
--TEST: order by positions not existed
select col2, ntile(19) over(order by 2) b_num from ntile_bbc order by 1, 2;
select col1, ntile(21) over(order by 3, 4, 1 desc) b_num, col2, clob_to_char(col4) from ntile_bbc order by 1, 2;
select blob_to_bit(col3), clob_to_char(col4), ntile(23) over(order by 5) b_num from ntile_bbc;
select blob_to_bit(col3), col1, ntile(1000) over(order by 100) b_num from ntile_bbc;
--TEST: order by column names and positions
select col1, col2, blob_to_bit(col3), clob_to_char(col4), ntile(25) over(order by 1, col2 desc, 3, clob_to_char(col4) asc) b_num from ntile_bbc order by 1, 2, 3, 4, 5;




--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by bit(n)
select col1, col2, blob_to_bit(col3), ntile(2) over(partition by col1 order by col1, blob_to_bit(col3)) from ntile_bbc;
--TEST: partition by bit varying
select col2, clob_to_char(col4), col1, ntile(4) over(partition by col2 order by col2, clob_to_char(col4), col1 desc) from ntile_bbc;
--TEST: partition by blob
select blob_to_bit(col3), ntile(6) over(partition by col3 order by blob_to_bit(col3), clob_to_char(col4)) b_num, col2 from ntile_bbc;
--TEST: partition by clob
select clob_to_char(col4), col1, ntile(8) over(partition by col4 order by clob_to_char(col4), 2 desc) b_num from ntile_bbc;
select clob_to_char(col4), col1, ntile(10) over(partition by clob_to_char(col4) order by 2, 1 desc) b_num from ntile_bbc;
--TEST: syntax error
select col1, col2, ntile(12) over(order by col1, col2 partition by col2) from ntile_bbc;


delete from ntile_bbc;

drop table ntile_bbc; 















