--TEST: test with character string data types and normal syntax 

drop table if exists p_cont;
create table p_cont_string(
        col1 char(20),
        col2 varchar(100),
        col3 char(10),
        col4 string,
        col5 enum('character', 'string'),
        col6 float
);


insert into p_cont_string values('aaaaa', 'This is a dog.', '1111', '0.75', 'character', 0.8);
insert into p_cont_string values('aaaaa', 'This is a cat.', '2222', '0.7', 'character', 0.2);
insert into p_cont_string values('aaaaa', 'This is a dog.', '5555', '0.78', 'character', 0.5);
insert into p_cont_string values('aaaaa', 'This is a cat.', '9999', '0.7', 'character', 0.2);
insert into p_cont_string values('aaaaa', 'This is a dog.', '3456', '0.75', 'character', 0.8);
insert into p_cont_string values('eeeee', 'This is a cat.', '1111', '0.7', 'character', 0.2);
insert into p_cont_string values('eeeee', 'This is a dog.', '5555', '0.78', 'character', 0.5);
insert into p_cont_string values('eeeee', 'This is a dog.', '8765', '0.7', 'character', 0.2);
insert into p_cont_string values('eeeee', 'This is a rabbit.', '1111', '0.75', 'character', 0.8);
insert into p_cont_string values('ccccc', 'This is a dog.', '8765', '0.7', 'character', 0.2);
insert into p_cont_string values('ccccc', 'This is a dog.', '3456', '0.7', 'string', 0.2);
insert into p_cont_string values('ccccc', 'This is a rabbit.', '3456', '0.7', 'string', 0.5);
insert into p_cont_string values('zzzzz', 'This is a dog.', '2222', '0.75', 'string', 0.2);
insert into p_cont_string values('bbbbb', 'This is a dog.', '9999', '0.78', 'string', 0.2);
insert into p_cont_string values('bbbbb', 'This is a cat.', '0.5', '0.7', 'string', 0.2);
insert into p_cont_string values('bbbbb', 'This is a dog.', '2222', '0.75', 'string', 0.5);
insert into p_cont_string values('bbbbb', 'This is a dog.', '0.5', '0.7', 'string', 0.2);
insert into p_cont_string values('bbbbb', 'This is a rabbit.', '9999', '0.7', 'string', 0.2);
insert into p_cont_string values('bbbbb', 'This is a dog.', '0.5', '0.7', 'string', 0.2);
insert into p_cont_string values('bbbbb', 'This is a dog.', '9999', '0.75', 'string', 0.8);


--TEST: OVER() clause
--TEST: char(n) 
select col1, col2, percentile_cont(0) within group (order by col1) over() from p_cont_string order by 1, 2;
--TEST: varchar(n), with alias+all
select col2, col3, percentile_cont(0.1) within group (order by col2) over() p_cont from p_cont_string order by 1, 2;
--TEST: char(n), with where clause
select col3, col4, percentile_cont(0.4) within group (order by col3) over() p_cont from p_cont_string where col1 > 'aaaaa' order by col3, col4;
--TEST: string,
select col4, col1, percentile_cont(0.8) within group (order by col4) over() p_cont from p_cont_string order by 1, 2;
--TEST: enum
select col5, col3, percentile_cont(0.7) within group (order by col5 desc) over() p_cont from p_cont_string order by 1, 2;
select col5, col3, col6, percentile_cont(0.7) within group (order by col6) over() p_cont from p_cont_string order by 1, 2;

--TEST: different types of argument to the first param
select col1, percentile_cont(col1) within group (order by col6) over() from p_cont_string order by 1, 2;
select col2, percentile_cont(col2) within group (order by col6) over() from p_cont_string order by 1, 2;
select col3, percentile_cont(col3) within group (order by col6) over(partition by col3) from p_cont_string order by 1, 2;
select col4, percentile_cont(col4) within group (order by col6) over() from p_cont_string order by 1, 2;
select col5, percentile_cont(col5) within group (order by col6) over(partition by col5) from p_cont_string order by 1, 2;
select col6, percentile_cont(col6) within group (order by col6) over() from p_cont_string order by 1, 2;


--TEST: OVER(PARTITION BY) clause
select col1, col2, col3, col4, col5, percentile_cont(0.2) within group (order by col3) over(partition by col1) p_cont from p_cont_string order by 1, 2, 3, 4, 5;
select col1, col2, col3, col4, col5, percentile_cont(0.3) within group (order by col3) over(partition by col2) p_cont from p_cont_string order by 2, 1, 3, 4, 5;
select col1, col2, col3, col4, col5, percentile_cont(0.6) within group (order by col3) over(partition by col3) p_cont from p_cont_string order by 3, 1, 2, 4, 5;
select col1, col2, col3, col4, col5, percentile_cont(0.8) within group (order by col3) over(partition by col4) p_cont from p_cont_string order by 4, 1, 2, 3, 5;
select col1, col2, col3, col4, col5, percentile_cont(0.9) within group (order by col3) over(partition by col5) p_cont from p_cont_string order by 4, 1, 2, 3, 5;
select col1, col2, col3, col4, col5, percentile_cont(0.9) within group (order by col3) over(partition by col6) p_cont from p_cont_string order by 4, 1, 2, 3, 5;


--TEST: [er] OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, percentile_cont(0.99) within group (order by col4) over(order by col1) p_cont1 from p_cont_string order by 1, 2;
--TEST: order by 3 positions
select col3, col2, percentile_cont(0.4) within group (order by col4) over(order by 1, 2 desc, 3 asc) p_cont from p_cont_string order by 1, 2, 3;


--TEST: [er] OVER(PARTITION BY ORDER BY) clause
select col1, col2, col3, percentile_cont(1) within group (order by col6) over(partition by col1 order by 1, 2, 3) from p_cont_string order by 1, 2, 3, 4;


drop table p_cont_string; 















