--TEST: test with tables with triggers 


create table rownum_trigger(
	col1 bit(20),
	col2 bit varying, 
	col3 blob,
	col4 clob
);


create table rownum_action(
	id int auto_increment,
	str varchar
);


--create trigger
create trigger bef_ins before insert on rownum_trigger
execute insert into rownum_action(str) values('BEFORE INSERT');


insert into rownum_trigger values(B'1011', X'abc', X'0', char_to_clob('cubrid'));
insert into rownum_trigger values(B'1011', x'bcd', X'1', char_to_clob('cubrid'));
insert into rownum_trigger values(B'1011', X'abc', X'2', char_to_clob('cubrid'));
insert into rownum_trigger values(B'1011', x'bcd', X'3', char_to_clob('cubrid'));
insert into rownum_trigger values(B'1011', X'abc', X'4', char_to_clob('cubrid'));
insert into rownum_trigger values(B'1001', x'bcd', X'5', char_to_clob('cubrid'));
insert into rownum_trigger values(B'1001', X'abc', X'6', char_to_clob('cubrid'));
insert into rownum_trigger values(B'1001', X'abc', X'7', char_to_clob('cubrid'));
insert into rownum_trigger values(B'1001', X'cde', X'8', char_to_clob('cubrid'));
insert into rownum_trigger values(B'0011', X'abc', X'9', char_to_clob('cubrid'));
insert into rownum_trigger values(B'0011', X'abc', X'10', char_to_clob('mysql'));
insert into rownum_trigger values(B'0011', X'cde', X'11', char_to_clob('mysql'));
insert into rownum_trigger values(B'1010', X'abc', X'12', char_to_clob('mysql'));
insert into rownum_trigger values(B'1111', X'abc', X'13', char_to_clob('mysql'));
insert into rownum_trigger values(B'1111', x'bcd', X'14', char_to_clob('mysql'));
insert into rownum_trigger values(B'1111', X'abc', X'15', char_to_clob('mysql'));
insert into rownum_trigger values(B'1111', X'abc', X'16', char_to_clob('mysql'));
insert into rownum_trigger values(B'1111', X'cde', X'17', char_to_clob('mysql'));
insert into rownum_trigger values(B'1111', X'abc', X'18', char_to_clob('mysql'));
insert into rownum_trigger values(B'1111', X'abc', X'19', char_to_clob('mysql'));


--TEST: OVER() clause
--TEST: no alias 
select row_num from (select  col1, col2, row_number() over() row_num from rownum_trigger) order by 1;
--TEST: with alias
select row_num from (select  col2, blob_to_bit(col3), row_number() over() row_num from rownum_trigger) order by 1;
--TEST: blob
select row_num from (select  blob_to_bit(col3), clob_to_char(col4), row_number() over() row_num from rownum_trigger where col1 > B'1011') order by 1;
--TEST: clob
select row_num from (select  clob_to_char(col4), col1, row_number() over() row_num from rownum_trigger) order by 1;
--TEST: syntax error
select col1, blob_to_bit(col3), clob_to_char(col4), row_number() over row_num from rownum_trigger;
select col1, blob_to_bit(col3), col2, row_number() over(1) row_num from rownum_trigger;
--TEST: trigger action table
select id, str, row_number() over() row_num from rownum_action order by 1, 2, 3;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by bit(n)
select row_num from (select  col1, col2, blob_to_bit(col3), clob_to_char(col4), row_number() over(partition by col1) row_num from rownum_trigger) order by 1;
--TEST: partition by bit varying
select row_num from (select  col1, col2, blob_to_bit(col3), clob_to_char(col4), row_number() over(partition by col2) row_num from rownum_trigger) order by 1;
--TEST: partition by blob
select row_num from (select  col1, col2, blob_to_bit(col3), clob_to_char(col4), row_number() over(partition by 3) row_num from rownum_trigger) order by 1;
--TEST: partition by clob
select row_num from (select  col1, col2, blob_to_bit(col3), clob_to_char(col4), row_number() over(partition by 4) row_num from rownum_trigger) order by 1;
--TEST: trigger action table, partition by int
select id, str, row_number() over(partition by id) from rownum_action order by 1, 2, 3;
--TEST: trigger action table, partition by string
select id, str, row_number() over(partition by str) from rownum_action order by 1, 2, 3;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, row_number() over(order by col1) row_num from rownum_trigger;
--TEST: order by 2 column names
select col2, blob_to_bit(col3), row_number() over(order by col2, blob_to_bit(col3) asc) row_num from rownum_trigger;
--TEST: order by more than 2 column names
select col1, col2, blob_to_bit(col3), clob_to_char(col4), row_number() over(order by col1, col2 desc, blob_to_bit(col3), clob_to_char(col4) asc) row_num from rownum_trigger;
--TEST: order by columns not selected
select row_num from (select blob_to_bit(col3), row_number() over(order by clob_to_char(col4) desc, col2, col1 asc) row_num from rownum_trigger) order by 1;
--TEST: order by 1 position
select clob_to_char(col4), row_number() over(order by 1) row_num from rownum_trigger;
--TEST: order by 3 positions
select blob_to_bit(col3), col2, row_number() over(order by blob_to_bit(col3), 2 desc, 3 asc) row_num from rownum_trigger;
--TEST: order by more than 3 positions
select col1, col2, blob_to_bit(col3), clob_to_char(col4), row_number() over(order by blob_to_bit(col3), 2 asc, 1 desc, clob_to_char(col4)) row_num from rownum_trigger;
--TEST: order by positions not existed
select col2, row_number() over(order by 2) row_num from rownum_trigger;
select col1, row_number() over(order by 3, 4, 1 desc) row_num, col2, clob_to_char(col4) from rownum_trigger;
select blob_to_bit(col3), clob_to_char(col4), row_number() over(order by 5) row_num from rownum_trigger;
select blob_to_bit(col3), col1, row_number() over(order by 100) row_num from rownum_trigger;
--TEST: order by column names and positions
select col1, col2, blob_to_bit(col3), clob_to_char(col4), row_number() over(order by 1, col2 desc, 3, clob_to_char(col4) asc) row_num from rownum_trigger;
--TEST: trigger action table
select id, str, row_number() over(order by id) row_num from rownum_action order by 1;




--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by bit(n)
select col1, col2, blob_to_bit(col3), row_number() over(partition by col1 order by col1, blob_to_bit(col3)) from rownum_trigger;
--TEST: partition by bit varying
select col2, clob_to_char(col4), col1, row_number() over(partition by col2 order by col2, clob_to_char(col4), col1 desc) from rownum_trigger;
--TEST: partition by blob
select blob_to_bit(col3), row_number() over(partition by 1 order by blob_to_bit(col3), clob_to_char(col4)) row_num, col2 from rownum_trigger;
--TEST: partition by clob
select clob_to_char(col4), col1, row_number() over(partition by 1 order by clob_to_char(col4), 2 desc) row_num from rownum_trigger;
--TEST: syntax error
select col1, col2, row_number() over(order by col1, col2 partition by col2) from rownum_trigger;
--TEST: trigger action table, partition by int
select str, row_number() over(partition by id order by id), id from rownum_action order by 3;
--TEST: trigger action table, partition by str
select id, str, row_number() over(partition by str order by id) from rownum_action order by id;


delete from rownum_trigger;

drop trigger bef_ins;
drop table rownum_trigger; 
drop table rownum_action;















