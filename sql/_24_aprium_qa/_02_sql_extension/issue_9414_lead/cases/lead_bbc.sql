--TEST: test with bit strings and blob/clob data types and normal syntax
--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';

create table lead_bbc(
	col1 bit(20),
	col2 bit varying, 
	col3 blob,
	col4 clob
);


insert into lead_bbc values(B'1011', X'abc', X'0', 'cubrid');
insert into lead_bbc values(B'1011', x'bcd', X'1', 'cubrid');
insert into lead_bbc values(B'1011', X'abc', X'2', 'cubrid');
insert into lead_bbc values(B'1011', x'bcd', X'3', 'cubrid');
insert into lead_bbc values(B'1011', X'abc', X'4', 'cubrid');
insert into lead_bbc values(B'1001', x'bcd', X'5', 'cubrid');
insert into lead_bbc values(B'1001', X'abc', X'6', 'cubrid');
insert into lead_bbc values(B'1001', X'abc', X'7', 'cubrid');
insert into lead_bbc values(B'1001', X'cde', X'8', 'cubrid');
insert into lead_bbc values(B'0011', X'abc', X'9', 'cubrid');
insert into lead_bbc values(B'0011', X'abc', X'10', 'mysql');
insert into lead_bbc values(B'0011', X'cde', X'11', 'mysql');
insert into lead_bbc values(B'1010', X'abc', X'12', 'mysql');
insert into lead_bbc values(B'1111', X'abc', X'13', 'mysql');
insert into lead_bbc values(B'1111', x'bcd', X'14', 'mysql');
insert into lead_bbc values(B'1111', X'abc', X'15', 'mysql');
insert into lead_bbc values(B'1111', X'abc', X'16', 'mysql');
insert into lead_bbc values(B'1111', X'cde', X'17', 'mysql');
insert into lead_bbc values(B'1111', X'abc', X'18', 'mysql');
insert into lead_bbc values(B'1111', X'abc', X'19', 'mysql');


--TEST: OVER() clause
--TEST: no alias 
select next_v from (select col1, lead(col1) over() next_v from lead_bbc) order by 1;
--TEST: with alias
select next_v from (select col2, blob_to_bit(col3), lead(col2, 2) over() next_v from lead_bbc) order by 1;
--TEST: with where clause
select next_v from (select blob_to_bit(col3), clob_to_char(col4), lead(blob_to_bit(col3)) over() next_v from lead_bbc where col1 > B'1011') order by 1;
--TEST: syntax error
select col1, blob_to_bit(col3), clob_to_char(col4), lead(col1) over next_v from lead_bbc;
select col1, blob_to_bit(col3), col2, lead(col2) over(1) next_v from lead_bbc;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by bit(n)
select next_v from (select col1, col2, blob_to_bit(col3), clob_to_char(col4), lead(col1, 3, B'1110') over(partition by col1) next_v from lead_bbc) order by 1;
--TEST: partition by bit varying
select next_v from (select col1, col2, blob_to_bit(col3), clob_to_char(col4), lead(col2) over(partition by col2) next_v from lead_bbc) order by 1;
--TEST: partition by blob
select col1, col2, blob_to_bit(col3), clob_to_char(col4), lead(col1) over(partition by col3) next_v from lead_bbc order by blob_to_bit(col3), 1, 2, clob_to_char(col4);
select col1, col2, blob_to_bit(col3), clob_to_char(col4), lead(blob_to_bit(col3), 1, X'23') over(partition by blob_to_bit(col3)) next_v from lead_bbc order by 1;
--TEST: partition by clob
select col1, col2, blob_to_bit(col3), clob_to_char(col4), lead(col2, 10, X'FFFF') over(partition by col4) next_v from lead_bbc order by clob_to_char(col4), 1, 2, blob_to_bit(col3), 5;
select next_v from (select col1, col2, blob_to_bit(col3), clob_to_char(col4), lead(clob_to_char(col4), 2, 'aaa') over(partition by clob_to_char(col4)) next_v from lead_bbc) order by 1;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, lead(col1, 1, null) over(order by col1) next_v from lead_bbc order by 1, 2;
--TEST: order by 2 column names
select col2, blob_to_bit(col3), lead(col2, 3, B'0001') over(order by col2, blob_to_bit(col3) asc) next_v from lead_bbc order by 1, 2, 3;
--TEST: order by blob column
select col2, blob_to_bit(col3), lead(col3, 1, X'12') over(order by col3) next_v from lead_bbc;
--TEST: order by clob column
select col2, blob_to_bit(col3), clob_to_char(col4), lead(blob_to_bit(col3)) over(order by col4 desc) next_v from lead_bbc;
--TEST: order by more than 2 column names
select col1, col2, blob_to_bit(col3), clob_to_char(col4), lead(col4) over(order by col1, col2 desc, blob_to_bit(col3), clob_to_char(col4) asc) next_v from lead_bbc order by 1, 2, 3, 4, 5;
--TEST: order by columns not selected
select blob_to_bit(col3), lead(clob_to_char(col4)) over(order by clob_to_char(col4) desc, col2, col1 asc) next_v from lead_bbc order by 1;
--TEST: order by 1 position
select blob_to_bit(col3), lead(blob_to_bit(col3), 5, X'111') over(order by 1) next_v from lead_bbc order by 1, 2;
--TEST: order by 3 positions
select blob_to_bit(col3), col2, lead(clob_to_char(col4), 3, 'aaa') over(order by blob_to_bit(col3), 2 desc, 3 asc) next_v from lead_bbc order by 1, 2, 3;
--TEST: order by more than 3 positions
select col1, col2, blob_to_bit(col3), clob_to_char(col4), lead(col2, 10, X'123') over(order by blob_to_bit(col3), 2 asc, 1 desc, clob_to_char(col4)) next_v from lead_bbc order by 1, 2, 3, 4, 5;
--TEST: order by positions not existed
select col2, lead(col1, 1, X'F000') over(order by 2) next_v from lead_bbc order by 1, 2;
select col1, lead(col2) over(order by 3, 4, 1 desc) next_v, col2, clob_to_char(col4) from lead_bbc order by 1, 2;
select blob_to_bit(col3), clob_to_char(col4), lead(col3) over(order by 5) next_v from lead_bbc;
select blob_to_bit(col3), col1, lead(clob_to_char(col4), 8, null) over(order by 100) next_v from lead_bbc;
--TEST: order by column names and positions
select col1, col2, blob_to_bit(col3), clob_to_char(col4), lead(col2) over(order by 1, col2 desc, 3, clob_to_char(col4) asc) next_v from lead_bbc order by 1, 2, 3, 4, 5;




--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by bit(n)
select col1, col2, blob_to_bit(col3), lead(col1, 100, X'1000') over(partition by col1 order by col1, blob_to_bit(col3)) from lead_bbc;
--TEST: partition by bit varying
select col2, clob_to_char(col4), col1, lead(col2, 2, B'1000') over(partition by col2 order by col2, clob_to_char(col4), col1 desc) from lead_bbc;
--TEST: partition by blob
select blob_to_bit(col3), lead(blob_to_bit(col3), 3) over(partition by col3 order by blob_to_bit(col3), clob_to_char(col4)) next_v, col2 from lead_bbc;
--TEST: partition by clob
select clob_to_char(col4), col1, lead(clob_to_char(col4), 1, char_to_clob('aaa')) over(partition by col4 order by clob_to_char(col4), 2 desc) next_v from lead_bbc;
select clob_to_char(col4), col1, lead(col2) over(partition by clob_to_char(col4) order by 2, 1 desc) next_v from lead_bbc order by 1,2,3;
--TEST: syntax error
select col1, col2, lead(col1) over(order by col1, col2 partition by col2) from lead_bbc;


delete from lead_bbc;

drop table lead_bbc; 
set system parameters 'dont_reuse_heap_file=no';
--+ holdcas off;














