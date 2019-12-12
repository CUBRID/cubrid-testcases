--TEST: test with tables with triggers
--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';

create table count_trigger(
	col1 bit(20),
	col2 bit varying, 
	col3 blob,
	col4 clob
);


create table count_action(
        id int auto_increment,
        str char(20)
);


--create trigger
create trigger aft_ins after insert on count_trigger
execute insert into count_action(str) values ('INSERTED');


insert into count_trigger values(B'1011', X'abc', X'0', char_to_clob('cubrid'));
insert into count_trigger values(B'1011', x'bcd', X'1', char_to_clob('cubrid'));
insert into count_trigger values(B'1011', X'abc', X'2', char_to_clob('cubrid'));
insert into count_trigger values(B'1011', x'bcd', X'3', char_to_clob('cubrid'));
insert into count_trigger values(B'1011', X'abc', X'4', char_to_clob('cubrid'));
insert into count_trigger values(B'1001', x'bcd', X'5', char_to_clob('cubrid'));
insert into count_trigger values(B'1001', X'abc', X'6', char_to_clob('cubrid'));
insert into count_trigger values(B'1001', X'abc', X'7', char_to_clob('cubrid'));
insert into count_trigger values(B'1001', X'cde', X'8', char_to_clob('cubrid'));
insert into count_trigger values(B'0011', X'abc', X'9', char_to_clob('cubrid'));
insert into count_trigger values(B'0011', X'abc', X'10', char_to_clob('mysql'));
insert into count_trigger values(B'0011', X'cde', X'11', char_to_clob('mysql'));
insert into count_trigger values(B'1010', X'abc', X'12', char_to_clob('mysql'));
insert into count_trigger values(B'1111', X'abc', X'13', char_to_clob('mysql'));
insert into count_trigger values(B'1111', x'bcd', X'14', char_to_clob('mysql'));
insert into count_trigger values(B'1111', X'abc', X'15', char_to_clob('mysql'));
insert into count_trigger values(B'1111', X'abc', X'16', char_to_clob('mysql'));
insert into count_trigger values(B'1111', X'cde', X'17', char_to_clob('mysql'));
insert into count_trigger values(B'1111', X'abc', X'18', char_to_clob('mysql'));
insert into count_trigger values(B'1111', X'abc', X'19', char_to_clob('mysql'));



--TEST: OVER() clause
--TEST: bit(n) 
select col1, col2, count(col1) over() from count_trigger order by 1, 2;
--TEST: bit varying, with alias+all
select col2, blob_to_bit(col3), count(all col2) over() cnt from count_trigger order by 1, blob_to_bit(col3);
--TEST: blob, with where clause
select blob_to_bit(col3), clob_to_char(col4), count(col3) over() cnt from count_trigger where col1 > B'1011' order by blob_to_bit(col3), clob_to_char(col4);
--TEST: clob, distinct
select clob_to_char(col4), col1, count(distinct col4) over() cnt from count_trigger order by clob_to_char(col4), 2;
--TEST: syntax error
select col1, blob_to_bit(col3), clob_to_char(col4), count(*) over cnt from count_trigger;
select col1, blob_to_bit(col3), col2, count(*) over(1) cnt from count_trigger;
--TEST: trigger action table
select id, str, count(*) over() cnt from count_action order by id;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by bit(n)
select col1, col2, blob_to_bit(col3), clob_to_char(col4), count(*) over(partition by col1) cnt from count_trigger order by 1, 2, blob_to_bit(col3), clob_to_char(col4);
--TEST: partition by bit varying
select col1, col2, blob_to_bit(col3), clob_to_char(col4), count(distinct col4) over(partition by col2) cnt from count_trigger order by 2, 1, blob_to_bit(col3), clob_to_char(col4);
--TEST: partition by blob
select col1, col2, blob_to_bit(col3), clob_to_char(col4), count(*) over(partition by 3) cnt from count_trigger order by blob_to_bit(col3), 1, 2, clob_to_char(col4);
--TEST: partition by clob
select col1, col2, blob_to_bit(col3), clob_to_char(col4), count(all col2) over(partition by 4) cnt from count_trigger order by clob_to_char(col4), 1, 2, blob_to_bit(col3), 5;
--TEST: trigger action table, partition by int
select id, str, count(str) over(partition by id) cnt from count_action order by id;
--TEST: trigger action table, partition by string
select id, str, count(id) over(partition by str) cnt from count_action order by 1;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, count(col2) over(order by col1) cnt from count_trigger;
--TEST: order by 2 column names
select col2, blob_to_bit(col3), count(all col4) over(order by col2, blob_to_bit(col3) asc) cnt from count_trigger;
--TEST: order by more than 2 column names
select col1, col2, blob_to_bit(col3), clob_to_char(col4), count(*) over(order by col1, col2 desc, blob_to_bit(col3), clob_to_char(col4) asc) cnt from count_trigger;
--TEST: order by columns not selected
select blob_to_bit(col3), count(distinct col2) over(order by clob_to_char(col4) desc, col2, col1 asc) cnt from count_trigger order by 1, 2;
--TEST: order by 1 position
select clob_to_char(col4), count(all col2) over(order by 1) cnt from count_trigger;
--TEST: order by 3 positions
select blob_to_bit(col3), col2, count(*) over(order by blob_to_bit(col3), 2 desc, 3 asc) cnt from count_trigger;
--TEST: order by more than 3 positions
select col1, col2, blob_to_bit(col3), clob_to_char(col4), count(*) over(order by blob_to_bit(col3), 2 asc, 1 desc, clob_to_char(col4)) cnt from count_trigger;
--TEST: order by positions not existed
select col2, count(distinct col1) over(order by 2) cnt from count_trigger;
select col1, count(all col3) over(order by 3, 4, 1 desc) cnt, col2, clob_to_char(col4) from count_trigger;
select blob_to_bit(col3), clob_to_char(col4), count(*) over(order by 5) cnt from count_trigger;
select blob_to_bit(col3), col1, count(*) over(order by 100) cnt from count_trigger;
--TEST: order by column names and positions
select col1, col2, blob_to_bit(col3), clob_to_char(col4), count(*) over(order by 1, col2 desc, 3, clob_to_char(col4) asc) cnt from count_trigger;
--TEST: trigger action table
select id, str, count(str) over(order by id) cnt from count_action order by 1;



--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by bit(n)
select col1, col2, blob_to_bit(col3), count(distinct col4) over(partition by col1 order by 1, 2, blob_to_bit(col3)) from count_trigger;
--TEST: partition by bit varying
select col2, clob_to_char(col4), col1, count(col2) over(partition by col2 order by col2, clob_to_char(col4), col1 desc) from count_trigger;
--TEST: partition by blob
select blob_to_bit(col3), count(all col4) over(partition by 1 order by blob_to_bit(col3), clob_to_char(col4), 3) cnt, col2 from count_trigger;
--TEST: partition by clob
select clob_to_char(col4), col1, count(*) over(partition by 1 order by clob_to_char(col4), 2 desc) cnt from count_trigger;
--TEST: syntax error
select col1, col2, count(distinct col3) over(order by col1, col2 partition by col2) from count_trigger;
--TEST: trigger action table, partition by int
select str, count(id) over(partition by id order by id), id from count_action order by 3;
--TEST: trigger action table, partition by str
select id, str, count(str) over(partition by str order by id) from count_action order by id;


delete from count_trigger;
drop trigger aft_ins;
drop table count_trigger, count_action; 

set system parameters 'dont_reuse_heap_file=no';
--+ holdcas off;














