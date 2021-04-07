--TEST: test with a table with a superclass 
--+holdcas on;

create table avg_super(
	col1 bit(20),
	col2 bit varying
);


create table avg_bbc under avg_super(
	col3 blob,
	col4 clob,
	col5 int
);


insert into avg_bbc values(B'1011', X'abc', X'0', 'cubrid', 12345);
insert into avg_bbc values(B'1011', x'bcd', X'1', 'cubrid', 23456);
insert into avg_bbc values(B'1011', X'abc', X'2', 'cubrid', 34567);
insert into avg_bbc values(B'1011', x'bcd', X'3', 'cubrid', 45678);
insert into avg_bbc values(B'1011', X'abc', X'4', 'cubrid', 56789);
insert into avg_bbc values(B'1001', x'bcd', X'5', 'cubrid', 45678);
insert into avg_bbc values(B'1001', X'abc', X'6', 'cubrid', 56789);
insert into avg_bbc values(B'1001', X'abc', X'7', 'cubrid', 12345);
insert into avg_bbc values(B'1001', X'cde', X'8', 'cubrid', 23456);
insert into avg_bbc values(B'0011', X'abc', X'9', 'cubrid', 34567);
insert into avg_bbc values(B'0011', X'abc', X'10', 'mysql', 45678);
insert into avg_bbc values(B'0011', X'cde', X'11', 'mysql', 67891);
insert into avg_bbc values(B'1010', X'abc', X'12', 'mysql', 45678);
insert into avg_bbc values(B'1111', X'abc', X'13', 'mysql', 67891);
insert into avg_bbc values(B'1111', x'bcd', X'14', 'mysql', 78901);
insert into avg_bbc values(B'1111', X'abc', X'15', 'mysql', 23456);
insert into avg_bbc values(B'1111', X'abc', X'16', 'mysql', 23456);
insert into avg_bbc values(B'1111', X'cde', X'17', 'mysql', 34567);
insert into avg_bbc values(B'1111', X'abc', X'18', 'mysql', 78901);
insert into avg_bbc values(B'1111', X'abc', X'19', 'mysql', 45634);


--TEST: OVER() clause
--TEST: bit(n) 
select col1, col2, avg(col5) over() from avg_bbc order by 1, 2;
--TEST: bit varying, with alias+all
select col2, blob_to_bit(col3), avg(all col5) over() average from avg_bbc order by 1, blob_to_bit(col3);
--TEST: blob, with where clause
select blob_to_bit(col3), clob_to_char(col4), avg(col5) over() average from avg_bbc where col1 > B'1011' order by 1, 2, 3;
--TEST: clob, distinct
select clob_to_char(col4), col1, avg(distinct col5) over() average from avg_bbc order by clob_to_char(col4), 2;
--TEST: syntax error
select col5, avg(col5) over() average from avg_bbc order by 1, 2;
select col1, blob_to_bit(col3), clob_to_char(col4), avg(col5) over average from avg_bbc;
select col1, blob_to_bit(col3), col2, avg(col5) over(1) average from avg_bbc;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by bit(n)
select col1, col2, blob_to_bit(col3), clob_to_char(col4), avg(unique col5) over(partition by col1) average from avg_bbc order by 1, 2, blob_to_bit(col3), clob_to_char(col4);
--TEST: partition by bit varying
select col1, col2, blob_to_bit(col3), clob_to_char(col4), avg(distinctrow col5) over(partition by col2) average from avg_bbc order by 2, 1, blob_to_bit(col3), clob_to_char(col4);
--TEST: partition by blob
select col1, col2, blob_to_bit(col3), clob_to_char(col4), avg(col5) over(partition by 3) average from avg_bbc order by blob_to_bit(col3), 1, 2, clob_to_char(col4);
--TEST: partition by clob
select col1, col2, blob_to_bit(col3), clob_to_char(col4), avg(all col5) over(partition by 4) average from avg_bbc order by clob_to_char(col4), 1, 2, blob_to_bit(col3), 5;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, avg(col5) over(order by col1) average from avg_bbc;
--TEST: order by 2 column names
select col2, blob_to_bit(col3), avg(all col5) over(order by col2, blob_to_bit(col3) asc) average from avg_bbc;
--TEST: order by more than 2 column names
select col1, col2, blob_to_bit(col3), clob_to_char(col4), avg(unique col5) over(order by col1, col2 desc, blob_to_bit(col3), clob_to_char(col4) asc) average from avg_bbc;
--TEST: order by columns not selected
select blob_to_bit(col3), avg(distinct col5) over(order by clob_to_char(col4) desc, col2, col1 asc) average from avg_bbc order by 1, 2;
--TEST: order by 1 position
select clob_to_char(col4), avg(all col5) over(order by 1) average from avg_bbc;
--TEST: order by 3 positions
select blob_to_bit(col3), col2, avg(distinctrow col5) over(order by blob_to_bit(col3), 2 desc, 3 asc) average from avg_bbc;
--TEST: order by more than 3 positions
select col1, col2, blob_to_bit(col3), clob_to_char(col4), avg(col5) over(order by blob_to_bit(col3), 2 asc, 1 desc, clob_to_char(col4)) average from avg_bbc;
--TEST: order by positions not existed
select col2, avg(distinct col5) over(order by 2) average from avg_bbc;
select col1, avg(all col5) over(order by 3, 4, 1 desc) average, col2, clob_to_char(col4) from avg_bbc;
select blob_to_bit(col3), clob_to_char(col4), avg(col5) over(order by 5) average from avg_bbc;
select blob_to_bit(col3), col1, avg(col5) over(order by 100) average from avg_bbc;
--TEST: order by column names and positions
select col1, col2, blob_to_bit(col3), clob_to_char(col4), avg(col5) over(order by 1, col2 desc, 3, clob_to_char(col4) asc) average from avg_bbc;




--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by bit(n)
select col1, col2, blob_to_bit(col3), avg(distinct col5) over(partition by col1 order by 1, 2, blob_to_bit(col3)) from avg_bbc;
--TEST: partition by bit varying
select col2, clob_to_char(col4), col1, avg(col5) over(partition by col2 order by col2, clob_to_char(col4), col1 desc) from avg_bbc;
--TEST: partition by blob
select blob_to_bit(col3), avg(all col5) over(partition by 1 order by blob_to_bit(col3), clob_to_char(col4), 3) average, col2 from avg_bbc order by 1, 2;
--TEST: partition by clob
select clob_to_char(col4), col1, avg(unique col5) over(partition by 1 order by clob_to_char(col4), 2 desc) average from avg_bbc;
--TEST: syntax error
select col1, col2, avg(distinctrow col5) over(order by col1, col2 partition by col2) from avg_bbc;


delete from avg_bbc;
drop table avg_super;
drop table avg_bbc; 
--+ holdcas off;














