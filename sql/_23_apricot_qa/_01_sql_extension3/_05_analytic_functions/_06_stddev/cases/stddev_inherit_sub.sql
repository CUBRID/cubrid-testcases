--TEST: test with a table with a superclass 

create table stddev_super(
	col1 bit(20),
	col2 bit varying,
	col3 blob
);


create table stddev_bbc under stddev_super(
	col4 clob,
	col5 int
);


insert into stddev_bbc values(B'1011', X'abc', X'0', char_to_clob('cubrid'), 12345);
insert into stddev_bbc values(B'1011', x'bcd', X'1', char_to_clob('cubrid'), 23456);
insert into stddev_bbc values(B'1011', X'abc', X'2', char_to_clob('cubrid'), 34567);
insert into stddev_bbc values(B'1011', x'bcd', X'3', char_to_clob('cubrid'), 45678);
insert into stddev_bbc values(B'1011', X'abc', X'4', char_to_clob('cubrid'), 56789);
insert into stddev_bbc values(B'1001', x'bcd', X'5', char_to_clob('cubrid'), 45678);
insert into stddev_bbc values(B'1001', X'abc', X'6', char_to_clob('cubrid'), 56789);
insert into stddev_bbc values(B'1001', X'abc', X'7', char_to_clob('cubrid'), 12345);
insert into stddev_bbc values(B'1001', X'cde', X'8', char_to_clob('cubrid'), 23456);
insert into stddev_bbc values(B'0011', X'abc', X'9', char_to_clob('cubrid'), 34567);
insert into stddev_bbc values(B'0011', X'abc', X'10', char_to_clob('mysql'), 45678);
insert into stddev_bbc values(B'0011', X'cde', X'11', char_to_clob('mysql'), 67891);
insert into stddev_bbc values(B'1010', X'abc', X'12', char_to_clob('mysql'), 45678);
insert into stddev_bbc values(B'1111', X'abc', X'13', char_to_clob('mysql'), 67891);
insert into stddev_bbc values(B'1111', x'bcd', X'14', char_to_clob('mysql'), 78901);
insert into stddev_bbc values(B'1111', X'abc', X'15', char_to_clob('mysql'), 23456);
insert into stddev_bbc values(B'1111', X'abc', X'16', char_to_clob('mysql'), 23456);
insert into stddev_bbc values(B'1111', X'cde', X'17', char_to_clob('mysql'), 34567);
insert into stddev_bbc values(B'1111', X'abc', X'18', char_to_clob('mysql'), 78901);
insert into stddev_bbc values(B'1111', X'abc', X'19', char_to_clob('mysql'), 45634);


--TEST: OVER() clause
--TEST: bit(n) 
select col1, col2, stddev(col5) over() from stddev_bbc order by 1, 2;
--TEST: bit varying, with alias+all
select col2, blob_to_bit(col3), stddev(all col5) over() stddev from stddev_bbc order by 1, blob_to_bit(col3);
--TEST: blob, with where clause
select blob_to_bit(col3), clob_to_char(col4), stddev(col5) over() stddev from stddev_bbc where col1 > B'1011' order by blob_to_bit(col3), clob_to_char(col4);
--TEST: clob, distinct
select clob_to_char(col4), col1, stddev(distinct col5) over() stddev from stddev_bbc order by clob_to_char(col4), 2;
--TEST: syntax error
select col1, blob_to_bit(col3), clob_to_char(col4), stddev(col5) over stddev from stddev_bbc;
select col1, blob_to_bit(col3), col2, stddev(col5) over(1) stddev from stddev_bbc;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by bit(n)
select col1, col2, blob_to_bit(col3), clob_to_char(col4), stddev(unique col5) over(partition by col1) stddev from stddev_bbc order by 1, 2, blob_to_bit(col3), clob_to_char(col4);
--TEST: partition by bit varying
select col1, col2, blob_to_bit(col3), clob_to_char(col4), stddev(distinctrow col5) over(partition by col2) stddev from stddev_bbc order by 2, 1, blob_to_bit(col3), clob_to_char(col4);
--TEST: partition by blob
select col1, col2, blob_to_bit(col3), clob_to_char(col4), stddev(col5) over(partition by col3) stddev from stddev_bbc order by blob_to_bit(col3), 1, 2, clob_to_char(col4);
select col1, col2, blob_to_bit(col3), clob_to_char(col4), stddev(col5) over(partition by blob_to_bit(col3)) stddev from stddev_bbc order by blob_to_bit(col3), 1, 2, clob_to_char(col4);
--TEST: partition by clob
select col1, col2, blob_to_bit(col3), clob_to_char(col4), stddev(all col5) over(partition by col4) stddev from stddev_bbc order by clob_to_char(col4), 1, 2, blob_to_bit(col3), 5;
select col1, col2, blob_to_bit(col3), clob_to_char(col4), stddev(all col5) over(partition by clob_to_char(col4)) stddev from stddev_bbc order by clob_to_char(col4), 1, 2, blob_to_bit(col3), 5;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, stddev(col5) over(order by col1) stddev1, stddev(col5) over() stddev2 from stddev_bbc;
--TEST: order by 2 column names
select col2, blob_to_bit(col3), stddev(all col5) over(order by col2, blob_to_bit(col3) asc) stddev1, stddev(all col5) over() stddev2 from stddev_bbc;
--TEST: order by more than 2 column names
select col1, col2, blob_to_bit(col3), clob_to_char(col4), stddev(unique col5) over(order by col1, col2 desc, blob_to_bit(col3), clob_to_char(col4) asc) stddev1, stddev(unique col5) over() stddev2 from stddev_bbc;
--TEST: order by columns not selected
select stddev1, stddev2 from (select blob_to_bit(col3), stddev(distinct col5) over(order by clob_to_char(col4) desc, col2, col1 asc) stddev1, stddev(distinct col5) over() stddev2 from stddev_bbc) order by 1, 2;
--TEST: order by 1 position
select clob_to_char(col4), stddev(all col5) over(order by 1) stddev from stddev_bbc;
--TEST: order by 3 positions
select blob_to_bit(col3), col2, stddev(distinctrow col5) over(order by blob_to_bit(col3), 2 desc, 3 asc) stddev from stddev_bbc;
--TEST: order by more than 3 positions
select col1, col2, blob_to_bit(col3), clob_to_char(col4), stddev(col5) over(order by blob_to_bit(col3), 2 asc, 1 desc, clob_to_char(col4)) stddev from stddev_bbc;
--TEST: order by positions not existed
select col2, stddev(distinct col5) over(order by 2) stddev from stddev_bbc;
select col1, stddev(all col5) over(order by 3, 4, 1 desc) stddev, col2, clob_to_char(col4) from stddev_bbc;
select blob_to_bit(col3), clob_to_char(col4), stddev(col5) over(order by 5) stddev from stddev_bbc;
select blob_to_bit(col3), col1, stddev(col5) over(order by 100) stddev from stddev_bbc;
--TEST: order by column names and positions
select col1, col2, blob_to_bit(col3), clob_to_char(col4), stddev(col5) over(order by 1, col2 desc, 3, clob_to_char(col4) asc) stddev from stddev_bbc;




--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by bit(n)
select col1, col2, blob_to_bit(col3), stddev(distinct col5) over(partition by col1 order by col2, blob_to_bit(col3)) stddev1, stddev(distinct col5) over(partition by col1) stddev2 from stddev_bbc;
--TEST: partition by bit varying
select col2, clob_to_char(col4), col1, stddev(col5) over(partition by col2 order by col2, clob_to_char(col4), col1 desc) stddev1,  stddev(col5) over(partition by col2) stddev2 from stddev_bbc;
--TEST: partition by blob
select stddev1, stddev2 from (blob_to_bit(col3), stddev(all col5) over(partition by 1 order by blob_to_bit(col3), clob_to_char(col4), 3) stddev1, col2, stddev(all col5) over(partition by col3) stddev2 from stddev_bbc) order by 1, 2;
--TEST: partition by clob
select clob_to_char(col4), col1, stddev(unique col5) over(partition by clob_to_char(col4) order by clob_to_char(col4), col2 desc) stddev1, stddev(unique col5) over(partition by clob_to_char(col4)) stddev2 from stddev_bbc order by 1, 2, 3, 4;
--TEST: syntax error
select col1, col2, stddev(distinctrow col5) over(order by col1, col2 partition by col2) from stddev_bbc;



delete from stddev_bbc;
drop table stddev_super;
drop table stddev_bbc; 















