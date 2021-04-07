--TEST: test with tables with triggers
--+ holdcas on;

create table max_trigger(
	col1 bit(20),
	col2 bit varying, 
	col3 blob,
	col4 clob,
	col5 short
);


create table max_action(
        id int auto_increment,
        str char(20)
);


--create trigger
create trigger aft_ins after insert on max_trigger
execute insert into max_action(str) values ('INSERTED');


insert into max_trigger values(B'1011', X'abc', X'0', 'cubrid', 333);
insert into max_trigger values(B'1011', x'bcd', X'1', 'cubrid', 123);
insert into max_trigger values(B'1011', X'abc', X'2', 'cubrid', 888);
insert into max_trigger values(B'1011', x'bcd', X'3', 'cubrid', 666);
insert into max_trigger values(B'1011', X'abc', X'4', 'cubrid', 222);
insert into max_trigger values(B'1001', x'bcd', X'5', 'cubrid', 777);
insert into max_trigger values(B'1001', X'abc', X'6', 'cubrid', 999);
insert into max_trigger values(B'1001', X'abc', X'7', 'cubrid', 444);
insert into max_trigger values(B'1001', X'cde', X'8', 'cubrid', 321);
insert into max_trigger values(B'0011', X'abc', X'9', 'cubrid', 987);
insert into max_trigger values(B'0011', X'abc', X'10', 'mysql', 555);
insert into max_trigger values(B'0011', X'cde', X'11', 'mysql', 666);
insert into max_trigger values(B'1010', X'abc', X'12', 'mysql', 777);
insert into max_trigger values(B'1111', X'abc', X'13', 'mysql', 999);
insert into max_trigger values(B'1111', x'bcd', X'14', 'mysql', 123);
insert into max_trigger values(B'1111', X'abc', X'15', 'mysql', 555);
insert into max_trigger values(B'1111', X'abc', X'16', 'mysql', 444);
insert into max_trigger values(B'1111', X'cde', X'17', 'mysql', 888);
insert into max_trigger values(B'1111', X'abc', X'18', 'mysql', 923);
insert into max_trigger values(B'1111', X'abc', X'19', 'mysql', 234);



--TEST: OVER() clause
--TEST: bit(n) 
select col1, col2, max(col5) over() from max_trigger order by 1, 2;
--TEST: bit varying, with alias+all
select col2, blob_to_bit(col3), max(all col1) over() maximum from max_trigger order by 1, blob_to_bit(col3);
--TEST: blob, with where clause
select blob_to_bit(col3), clob_to_char(col4), max(col2) over() maximum from max_trigger where col1 > B'1011' order by blob_to_bit(col3), clob_to_char(col4);
--TEST: clob, distinct
select clob_to_char(col4), col1, max(distinct clob_to_char(col4)) over() maximum from max_trigger order by clob_to_char(col4), 2;
--TEST: syntax error
select col1, blob_to_bit(col3), clob_to_char(distinct col5), max(*) over maximum from max_trigger;
select col1, blob_to_bit(col3), col2, max(col5) over(1) maximum from max_trigger;
--TEST: trigger action table
select id, str, max(id) over() maximum from max_action order by id;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by bit(n)
select col1, col2, blob_to_bit(col3), clob_to_char(col4), max(unique blob_to_bit(col3)) over(partition by col1) maximum from max_trigger order by 1, 2, blob_to_bit(col3), clob_to_char(col4);
--TEST: partition by bit varying
select col1, col2, blob_to_bit(col3), clob_to_char(col4), max(distinct col5) over(partition by col2) maximum from max_trigger order by 2, 1, blob_to_bit(col3), clob_to_char(col4);
--TEST: partition by blob
select col1, col2, blob_to_bit(col3), clob_to_char(col4), max(unique col1) over(partition by col3) maximum from max_trigger order by blob_to_bit(col3), 1, 2, clob_to_char(col4);
select col1, col2, blob_to_bit(col3), clob_to_char(col4), max(unique col1) over(partition by blob_to_bit(col3)) maximum from max_trigger order by blob_to_bit(col3), 1, 2, clob_to_char(col4);
--TEST: partition by clob
select col1, col2, blob_to_bit(col3), clob_to_char(col4), max(all col2) over(partition by col4) maximum from max_trigger order by clob_to_char(col4), 1, 2, blob_to_bit(col3), 5;
select col1, col2, blob_to_bit(col3), clob_to_char(col4), max(all col2) over(partition by clob_to_char(col4)) maximum from max_trigger order by clob_to_char(col4), 1, 2, blob_to_bit(col3), 5;
--TEST: trigger action table, partition by int
select id, str, max(str) over(partition by id) maximum from max_action order by id;
--TEST: trigger action table, partition by string
select id, str, max(id) over(partition by str) maximum from max_action order by 1;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, max(clob_to_char(col4)) over(order by col1) maximum from max_trigger;
--TEST: order by 2 column names
select col2, blob_to_bit(col3), max(all blob_to_bit(col3)) over(order by col2, blob_to_bit(col3) asc) maximum from max_trigger;
--TEST: order by more than 2 column names
select col1, col2, blob_to_bit(col3), clob_to_char(col4), max(unique col5) over(order by col1, col2 desc, blob_to_bit(col3), clob_to_char(col4) asc) maximum from max_trigger;
--TEST: order by columns not selected
select blob_to_bit(col3), max(distinct col1) over(order by clob_to_char(col4) desc, col2, col1 asc) maximum from max_trigger order by 1, 2;
--TEST: order by 1 position
select clob_to_char(col4), max(all col2) over(order by 1) maximum from max_trigger;
--TEST: order by 3 positions
select blob_to_bit(col3), col2, max(col5) over(order by blob_to_bit(col3), 2 desc, 3 asc) maximum from max_trigger;
--TEST: order by more than 3 positions
select col1, col2, blob_to_bit(col3), clob_to_char(col4), max(col5) over(order by blob_to_bit(col3), 2 asc, 1 desc, clob_to_char(col4)) maximum from max_trigger;
--TEST: order by positions not existed
select col2, max(distinct col5) over(order by 2) maximum from max_trigger;
select col1, max(all col5) over(order by 3, 4, 1 desc) maximum, col2, clob_to_char(col4) from max_trigger;
select blob_to_bit(col3), clob_to_char(col4), max(col5) over(order by 5) maximum from max_trigger;
select blob_to_bit(col3), col1, max(col5) over(order by 100) maximum from max_trigger;
--TEST: order by column names and positions
select col1, col2, blob_to_bit(col3), clob_to_char(col4), max(col5) over(order by 1, col2 desc, 3, clob_to_char(col4) asc) maximum from max_trigger;
--TEST: trigger action table
select id, str, max(id) over(order by id) maximum from max_action order by 1;



--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by bit(n)
select col1, col2, blob_to_bit(col3), max(distinct col1) over(partition by col1 order by 1, 2, blob_to_bit(col3)) from max_trigger;
--TEST: partition by bit varying
select col2, clob_to_char(col4), col1, max(col2) over(partition by col2 order by col2, clob_to_char(col4), col1 desc) from max_trigger;
--TEST: partition by blob
select blob_to_bit(col3), max(all col5) over(partition by 1 order by blob_to_bit(col3), clob_to_char(col4), 3) maximum, col2 from max_trigger order by 1, 2;
--TEST: partition by clob
select clob_to_char(col4), col1, max(unique clob_to_char(col4)) over(partition by 1 order by clob_to_char(col4), 2 desc) maximum from max_trigger;
--TEST: syntax error
select col1, col2, max(distinct blob_to_bit(col3)) over(order by col1, col2 partition by col2) from max_trigger;
--TEST: trigger action table, partition by int
select str, max(id) over(partition by id order by id), id from max_action order by 3;
--TEST: trigger action table, partition by str
select id, str, max(str) over(partition by id order by id) from max_action order by id;



delete from max_trigger;
drop trigger aft_ins;
drop table max_trigger, max_action; 
--+ holdcas off;














