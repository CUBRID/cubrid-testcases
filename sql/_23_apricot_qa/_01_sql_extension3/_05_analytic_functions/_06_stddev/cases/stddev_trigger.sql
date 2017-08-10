--TEST: test with tables with triggers


create table stddev_trigger(
	col1 bit(20),
	col2 bit varying, 
	col3 blob,
	col4 clob,
	col5 short
);


create table stddev_action(
        id int auto_increment,
        str char(20)
);


--create trigger
create trigger aft_ins after insert on stddev_trigger
execute insert into stddev_action(str) values ('INSERTED');


insert into stddev_trigger values(B'1011', X'abc', X'0', char_to_clob('cubrid'), 333);
insert into stddev_trigger values(B'1011', x'bcd', X'1', char_to_clob('cubrid'), 123);
insert into stddev_trigger values(B'1011', X'abc', X'2', char_to_clob('cubrid'), 888);
insert into stddev_trigger values(B'1011', x'bcd', X'3', char_to_clob('cubrid'), 666);
insert into stddev_trigger values(B'1011', X'abc', X'4', char_to_clob('cubrid'), 222);
insert into stddev_trigger values(B'1001', x'bcd', X'5', char_to_clob('cubrid'), 777);
insert into stddev_trigger values(B'1001', X'abc', X'6', char_to_clob('cubrid'), 999);
insert into stddev_trigger values(B'1001', X'abc', X'7', char_to_clob('cubrid'), 444);
insert into stddev_trigger values(B'1001', X'cde', X'8', char_to_clob('cubrid'), 321);
insert into stddev_trigger values(B'0011', X'abc', X'9', char_to_clob('cubrid'), 987);
insert into stddev_trigger values(B'0011', X'abc', X'10', char_to_clob('mysql'), 555);
insert into stddev_trigger values(B'0011', X'cde', X'11', char_to_clob('mysql'), 666);
insert into stddev_trigger values(B'1010', X'abc', X'12', char_to_clob('mysql'), 777);
insert into stddev_trigger values(B'1111', X'abc', X'13', char_to_clob('mysql'), 999);
insert into stddev_trigger values(B'1111', x'bcd', X'14', char_to_clob('mysql'), 123);
insert into stddev_trigger values(B'1111', X'abc', X'15', char_to_clob('mysql'), 555);
insert into stddev_trigger values(B'1111', X'abc', X'16', char_to_clob('mysql'), 444);
insert into stddev_trigger values(B'1111', X'cde', X'17', char_to_clob('mysql'), 888);
insert into stddev_trigger values(B'1111', X'abc', X'18', char_to_clob('mysql'), 923);
insert into stddev_trigger values(B'1111', X'abc', X'19', char_to_clob('mysql'), 234);



--TEST: OVER() clause
--TEST: bit(n) 
select col1, col2, stddev(col5) over() from stddev_trigger order by 1, 2;
--TEST: bit varying, with alias+all
select col2, blob_to_bit(col3), stddev(all col5) over() stddev from stddev_trigger order by 1, blob_to_bit(col3);
--TEST: blob, with where clause
select blob_to_bit(col3), clob_to_char(col4), stddev(col5) over() stddev from stddev_trigger where col1 > B'1011' order by blob_to_bit(col3), clob_to_char(col4);
--TEST: clob, distinct
select clob_to_char(col4), col1, stddev(distinct col5) over() stddev from stddev_trigger order by clob_to_char(col4), 2;
--TEST: syntax error
select col1, blob_to_bit(col3), clob_to_char(distinct col5), stddev(*) over stddev from stddev_trigger;
select col1, blob_to_bit(col3), col2, stddev(col5) over(1) stddev from stddev_trigger;
--TEST: trigger action table
select id, str, stddev(id) over() stddev from stddev_action order by id;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by bit(n)
select col1, col2, blob_to_bit(col3), clob_to_char(col4), stddev(unique col5) over(partition by col1) stddev from stddev_trigger order by 1, 2, blob_to_bit(col3), clob_to_char(col4);
--TEST: partition by bit varying
select col1, col2, blob_to_bit(col3), clob_to_char(col4), stddev(distinct col5) over(partition by col2) stddev from stddev_trigger order by 2, 1, blob_to_bit(col3), clob_to_char(col4);
--TEST: partition by blob
select col1, col2, blob_to_bit(col3), clob_to_char(col4), stddev(distinctrow col5) over(partition by col3) stddev from stddev_trigger order by blob_to_bit(col3), 1, 2, clob_to_char(col4);
select col1, col2, blob_to_bit(col3), clob_to_char(col4), stddev(distinctrow col5) over(partition by blob_to_bit(col3)) stddev from stddev_trigger order by blob_to_bit(col3), 1, 2, clob_to_char(col4);
--TEST: partition by clob
select col1, col2, blob_to_bit(col3), clob_to_char(col4), stddev(all col5) over(partition by col4) stddev from stddev_trigger order by clob_to_char(col4), 1, 2, blob_to_bit(col3), 5;
select col1, col2, blob_to_bit(col3), clob_to_char(col4), stddev(all col5) over(partition by clob_to_char(col4)) stddev from stddev_trigger order by clob_to_char(col4), 1, 2, blob_to_bit(col3), 5;
--TEST: trigger action table, partition by int
select id, str, stddev(id) over(partition by id) stddev from stddev_action order by id;
--TEST: trigger action table, partition by string
select id, str, stddev(id) over(partition by str) stddev from stddev_action order by 1;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, stddev(col5) over(order by col1) stddev1, stddev(col5) over() stddev2 from stddev_trigger;
--TEST: order by 2 column names
select col2, blob_to_bit(col3), stddev(all col5) over(order by col2, blob_to_bit(col3) asc) stddev1, stddev(all col5) over() stddev2 from stddev_trigger;
--TEST: order by more than 2 column names
select col1, col2, blob_to_bit(col3), clob_to_char(col4), stddev(unique col5) over(order by col1, col2 desc, blob_to_bit(col3), clob_to_char(col4) asc) stddev1, stddev(unique col5) over() stddev2 from stddev_trigger;
--TEST: order by columns not selected
select blob_to_bit(col3), stddev(distinct col5) over(order by clob_to_char(col4) desc, col2, col1 asc) stddev1, stddev(distinct col5) over() stddev2 from stddev_trigger order by 1, 2, 3;
--TEST: order by 1 position
select clob_to_char(col4), stddev(all col5) over(order by 1) stddev from stddev_trigger;
--TEST: order by 3 positions
select blob_to_bit(col3), col2, stddev(col5) over(order by blob_to_bit(col3), 2 desc, 3 asc) stddev from stddev_trigger;
--TEST: order by more than 3 positions
select col1, col2, blob_to_bit(col3), clob_to_char(col4), stddev(col5) over(order by blob_to_bit(col3), 2 asc, 1 desc, clob_to_char(col4)) stddev from stddev_trigger;
--TEST: order by positions not existed
select col2, stddev(distinct col5) over(order by 2) stddev from stddev_trigger;
select col1, stddev(all col5) over(order by 3, 4, 1 desc) stddev, col2, clob_to_char(col4) from stddev_trigger;
select blob_to_bit(col3), clob_to_char(col4), stddev(col5) over(order by 5) stddev from stddev_trigger;
select blob_to_bit(col3), col1, stddev(col5) over(order by 100) stddev from stddev_trigger;
--TEST: order by column names and positions
select col1, col2, blob_to_bit(col3), clob_to_char(col4), stddev(col5) over(order by 1, col2 desc, 3, clob_to_char(col4) asc) stddev from stddev_trigger;
--TEST: trigger action table
select id, str, stddev(id) over(order by id) stddev1, stddev(id) over() stddev2 from stddev_action order by 1;



--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by bit(n)
select col1, col2, blob_to_bit(col3), stddev(distinct col5) over(partition by col1 order by 1, 2, blob_to_bit(col3)) stddev1, stddev(distinct col5) over(partition by col1) stddev2 from stddev_trigger;
--TEST: partition by bit varying
select col2, clob_to_char(col4), col1, stddev(col5) over(partition by col2 order by col2, clob_to_char(col4), col1 desc) stddev1, stddev(col5) over(partition by col2) stddev2 from stddev_trigger;
--TEST: partition by blob
select blob_to_bit(col3), stddev(all col5) over(partition by 1 order by blob_to_bit(col3), clob_to_char(col4), 3) stddev, col2 from stddev_trigger;
--TEST: partition by clob
select clob_to_char(col4), col1, stddev(unique col5) over(partition by 1 order by clob_to_char(col4), 2 desc) stddev from stddev_trigger;
--TEST: syntax error
select col1, col2, stddev(distinct col5) over(order by col1, col2 partition by col2) from stddev_trigger;
--TEST: trigger action table, partition by int
select str, stddev(id) over(partition by id order by id), id from stddev_action order by 3;
--TEST: trigger action table, partition by str
select id, str, stddev(id) over(partition by str order by id) from stddev_action order by id;


delete from stddev_trigger;
drop trigger aft_ins;
drop table stddev_trigger, stddev_action; 















