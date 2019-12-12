--TEST: test with bit strings and blob/clob data types and normal syntax


create table stddev_pop_bbc(
	col1 bit(20),
	col2 bit varying, 
	col3 blob,
	col4 clob,
	col5 double
);


insert into stddev_pop_bbc values(B'1011', X'abc', X'0', '123', 123.5678);
insert into stddev_pop_bbc values(B'1011', x'bcd', X'1', '11111', 123.1234);
insert into stddev_pop_bbc values(B'1011', X'abc', X'2', '9898', 123.2345);
insert into stddev_pop_bbc values(B'1011', x'bcd', X'3', '123.456', 123.5678);
insert into stddev_pop_bbc values(B'1011', X'abc', X'4', '9999999', 123.1234);
insert into stddev_pop_bbc values(B'1001', x'bcd', X'5', '9999999', 123.2345);
insert into stddev_pop_bbc values(B'1001', X'abc', X'6', '123', 123.3456);
insert into stddev_pop_bbc values(B'1001', X'abc', X'7', '123', 123.3456);
insert into stddev_pop_bbc values(B'1001', X'cde', X'8', '123.456', 123.3456);
insert into stddev_pop_bbc values(B'0011', X'abc', X'9', '7766', 123.5678);
insert into stddev_pop_bbc values(B'0011', X'abc', X'10', '9898', 123.4567);
insert into stddev_pop_bbc values(B'0011', X'cde', X'11', '123.456', 123.5678);
insert into stddev_pop_bbc values(B'1010', X'abc', X'12', '3333', 123.1234);
insert into stddev_pop_bbc values(B'1111', X'abc', X'13', '123', 123.4567);
insert into stddev_pop_bbc values(B'1111', x'bcd', X'14', '9898', 123.2345);
insert into stddev_pop_bbc values(B'1111', X'abc', X'15', '7766', 123.4567);
insert into stddev_pop_bbc values(B'1111', X'abc', X'16', '9898', 123.1357);
insert into stddev_pop_bbc values(B'1111', X'cde', X'17', '123', 123.1357);
insert into stddev_pop_bbc values(B'1111', X'abc', X'18', '999999', 123.9999);
insert into stddev_pop_bbc values(B'1111', X'abc', X'19', '9999999', 123.9999);


--TEST: OVER() clause
--TEST: bit(n) 
select stddev_pop from (select  col1, col2, trunc(stddev_pop(col5) over(), 2) stddev_pop from stddev_pop_bbc) order by 1;
--TEST: bit varying, with alias+all
select stddev_pop from (select  col2, blob_to_bit(col3), trunc(stddev_pop(all col5) over(), 5) stddev_pop from stddev_pop_bbc) order by 1;
--TEST: blob, with where clause
select stddev_pop from (select  blob_to_bit(col3), clob_to_char(col4), trunc(stddev_pop(col5) over(), 5) stddev_pop from stddev_pop_bbc where col1 > B'1011') order by 1;
--TEST: clob, distinct
select stddev_pop from (select  clob_to_char(col4), col1, trunc(stddev_pop(unique clob_to_char(col4)) over(), 5) stddev_pop from stddev_pop_bbc) order by 1;
--TEST: syntax error
select col1, blob_to_bit(col3), clob_to_char(col4), trunc(stddev_pop(col5) over stddev_pop from stddev_pop_bbc;
select col1, blob_to_bit(col3), col2, trunc(stddev_pop(col5) over(1), 5) stddev_pop from stddev_pop_bbc;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by bit(n)
select col1, col2, blob_to_bit(col3), clob_to_char(col4), trunc(stddev_pop(col5) over(partition by col1), 5) stddev_pop from stddev_pop_bbc order by 1, 2, blob_to_bit(col3), clob_to_char(col4);
--TEST: partition by bit varying
select col1, col2, blob_to_bit(col3), clob_to_char(col4), trunc(stddev_pop(all clob_to_char(col4)) over(partition by col2), 5) stddev_pop from stddev_pop_bbc order by 2, 1, blob_to_bit(col3), clob_to_char(col4);
--TEST: partition by blob
select col1, col2, blob_to_bit(col3), clob_to_char(col4), trunc(stddev_pop(distinctrow col5) over(partition by col3), 5) stddev_pop from stddev_pop_bbc order by blob_to_bit(col3), 1, 2, clob_to_char(col4);
--TEST: partition by clob
select col1, col2, blob_to_bit(col3), clob_to_char(col4), trunc(stddev_pop(all col5) over(partition by col4), 5) stddev_pop from stddev_pop_bbc order by clob_to_char(col4), 1, 2, blob_to_bit(col3), 5;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, trunc(stddev_pop(col5) over(order by col1), 5) stddev_pop1, trunc(stddev_pop(col5) over(), 5) stddev_pop2 from stddev_pop_bbc;
--TEST: order by 2 column names
select col2, blob_to_bit(col3), trunc(stddev_pop(all clob_to_char(col4)) over(order by col2, blob_to_bit(col3) asc), 5) stddev_pop1, trunc(stddev_pop(all clob_to_char(col4)) over(), 5) stddev_pop2 from stddev_pop_bbc;
--TEST: order by more than 2 column names
select col1, col2, blob_to_bit(col3), clob_to_char(col4), trunc(stddev_pop(unique col5) over(order by col1, col2 desc, blob_to_bit(col3), clob_to_char(col4) asc), 5) stddev_pop from stddev_pop_bbc;
--TEST: order by columns not selected
select blob_to_bit(col3), trunc(stddev_pop(distinct clob_to_char(col4)) over(order by clob_to_char(col4) desc, col2, col1 asc), 5) stddev_pop1, trunc(stddev_pop(distinct clob_to_char(col4)) over(), 5) stddev_pop2 from stddev_pop_bbc order by 1, 2, 3;
--TEST: order by 1 position
select clob_to_char(col4), trunc(stddev_pop(all col5) over(order by 1), 5) stddev_pop from stddev_pop_bbc;
--TEST: order by 3 positions
select blob_to_bit(col3), col2, trunc(stddev_pop(clob_to_char(col4)) over(order by blob_to_bit(col3), 2 desc, 3 asc), 5) stddev_pop from stddev_pop_bbc;
--TEST: order by more than 3 positions
select col1, col2, blob_to_bit(col3), clob_to_char(col4), trunc(stddev_pop(unique col5) over(order by blob_to_bit(col3), 2 asc, 1 desc, clob_to_char(col4)), 5) stddev_pop from stddev_pop_bbc;
--TEST: order by positions not existed
select col2, trunc(stddev_pop(distinct col5) over(order by 2), 5) stddev_pop from stddev_pop_bbc;
select col1, trunc(stddev_pop(all col5) over(order by 3, 4, 1 desc), 5) stddev_pop, col2, clob_to_char(col4) from stddev_pop_bbc;
select blob_to_bit(col3), clob_to_char(col4), trunc(stddev_pop(col5) over(order by 5), 5) stddev_pop from stddev_pop_bbc;
select blob_to_bit(col3), col1, trunc(stddev_pop(col5) over(order by 100), 5) stddev_pop from stddev_pop_bbc;
--TEST: order by column names and positions
select col1, col2, blob_to_bit(col3), clob_to_char(col4), trunc(stddev_pop(distinctrow col5) over(order by 1, col2 desc, 3, clob_to_char(col4) asc), 5) stddev_pop from stddev_pop_bbc;




--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by bit(n)
select col1, col2, blob_to_bit(col3), trunc(stddev_pop(distinct clob_to_char(col4)) over(partition by col1 order by 1, 2, blob_to_bit(col3)), 5) stddev_pop from stddev_pop_bbc;
--TEST: partition by bit varying
select col2, clob_to_char(col4), col1, trunc(stddev_pop(col5) over(partition by col2 order by col2, clob_to_char(col4), col1 desc), 5) stddev_pop from stddev_pop_bbc;
--TEST: partition by blob
select blob_to_bit(col3), trunc(stddev_pop(all clob_to_char(col4)) over(partition by 1 order by blob_to_bit(col3), clob_to_char(col4), 3), 5) stddev_pop1, trunc(stddev_pop(all clob_to_char(col4) over(partition by 1), 5) stddev_pop2, col2 from stddev_pop_bbc;
--TEST: partition by clob
select clob_to_char(col4), col1, trunc(stddev_pop(unique col5) over(partition by 1 order by clob_to_char(col4), 2 desc), 5) stddev_pop from stddev_pop_bbc;
--TEST: syntax error
select col1, col2, trunc(stddev_pop(distinct col5) over(order by col1, col2 partition by col2) from stddev_pop_bbc;


delete from stddev_pop_bbc;
drop table stddev_pop_bbc; 















