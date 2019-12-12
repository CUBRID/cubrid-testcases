--TEST: test with tables with list partitions

drop table if exists p_disc;
create table p_disc(
        col1 char(20),
        col2 varchar(100),
        col3 char(10),
        col4 string,
        col5 enum('character', 'string'),
        col6 char(20)
)
partition by list (col2) (
partition p1 values in ('This is a dog.'),
partition p2 values in ('This is a rabbit.'),
partition p3 values in ('This is a cat.')
);


insert into p_disc values('aaaaa', 'This is a dog.', '0.5', '0.22', 'character', 198);
insert into p_disc values('aaaaa', 'This is a cat.', '0.5', '0.22', 'character', 1900);
insert into p_disc values('aaaaa', 'This is a dog.', '0.5', '0.22', 'character', 66);
insert into p_disc values('aaaaa', 'This is a cat.', '0.5', '0.22', 'character', 1900);
insert into p_disc values('aaaaa', 'This is a dog.', '0.5', '0.22', 'character', 198);
insert into p_disc values('eeeee', 'This is a cat.', '0.5', '0.22', 'character', 1900);
insert into p_disc values('eeeee', 'This is a dog.', '0.5', '0.22', 'character', 66);
insert into p_disc values('eeeee', 'This is a dog.', '0.5', '0.22', 'character', 1900);
insert into p_disc values('eeeee', 'This is a rabbit.', '0.5', '0.22', 'character', 198);
insert into p_disc values('ccccc', 'This is a dog.', '0.5', '0.22', 'character', 1900);
insert into p_disc values('ccccc', 'This is a dog.', '0.5', '0.7', 'string', 1900);
insert into p_disc values('ccccc', 'This is a rabbit.', '0.32', '0.7', 'string', 66);
insert into p_disc values('zzzzz', 'This is a dog.', '0.32', '0.7', 'string', 1900);
insert into p_disc values('bbbbb', 'This is a dog.', '0.32', '0.7', 'string', 1900);
insert into p_disc values('bbbbb', 'This is a cat.', '0.32', '0.7', 'string', 1900);
insert into p_disc values('bbbbb', 'This is a dog.', '0.32', '0.7', 'string', 66);
insert into p_disc values('bbbbb', 'This is a dog.', '0.32', '0.7', 'string', 1900);
insert into p_disc values('bbbbb', 'This is a rabbit.', '0.32', '0.7', 'string', 1900);
insert into p_disc values('bbbbb', 'This is a dog.', '0.5', '0.7', 'string', 1900);
insert into p_disc values('bbbbb', 'This is a dog.', '0.5', '0.7', 'string', 198);


--TEST: OVER() clause
--TEST: char(n) 
select col1, col2, percentile_disc(0) within group (order by col1) over() from (select * from p_disc order by 1,2,3,4,5) order by 1, 2;
--TEST: varchar(n)
select col2, col3, percentile_disc(0.1) within group (order by col2) over() p_disc from (select * from p_disc order by 1,2,3,4,5) order by 1, 2;
--TEST: char(n)
select col3, col4, percentile_disc(0.4) within group (order by col3) over() p_disc from (select * from p_disc order by 1,2,3,4,5) where col1 > 'aaaaa' order by col3, col4;
--TEST: string
select col4, col1, percentile_disc(0.8) within group (order by col4) over() p_disc from (select * from p_disc order by 1,2,3,4,5) order by 1, 2;
--TEST: enum
select col5, col3, percentile_disc(0.7) within group (order by col5 desc) over() p_disc from (select * from p_disc order by 1,2,3,4,5) order by 1, 2;
select col5, col3, col6, percentile_disc(0.7) within group (order by col6) over() p_disc from (select * from p_disc order by 1,2,3,4,5) order by 1, 2;

--TEST: different types of argument to the first param
select col1, percentile_disc(col1) within group (order by col6) over() p_disc from (select * from p_disc order by 1,2,3,4,5) order by 1, 2;
select col2, percentile_disc(col2) within group (order by col6) over() p_disc from (select * from p_disc order by 1,2,3,4,5) order by 1, 2;
select col3, percentile_disc(col3) within group (order by col6) over() p_disc from (select * from p_disc order by 1,2,3,4,5) order by 1, 2;
select col4, percentile_disc(col4) within group (order by col6) over() p_disc from (select * from p_disc order by 1,2,3,4,5) order by 1, 2;
select col5, percentile_disc(col5) within group (order by col6) over() p_disc from (select * from p_disc order by 1,2,3,4,5) order by 1, 2;
select col6, percentile_disc(col6) within group (order by col6) over() p_disc from (select * from p_disc order by 1,2,3,4,5) order by 1, 2;


--TEST: OVER(PARTITION BY) clause
select col1, col5, percentile_disc(0.2) within group (order by col3) over(partition by col1, col5) p_disc from (select * from p_disc order by 1,2,3,4,5) order by 1, 2, 3;
select col1, col2, col3, percentile_disc(0.3) within group (order by col3) over(partition by col1, col2, col3) p_disc from (select * from p_disc order by 1,2,3,4,5) order by 1, 2, 3;
select col3, col5, percentile_disc(0.6) within group (order by col6) over(partition by col3, col5) p_disc from (select * from p_disc order by 1,2,3,4,5) order by 1, 2, 3;
select col2, col4, percentile_disc(0.8) within group (order by col3) over(partition by col2, col4) p_disc from (select * from p_disc order by 1,2,3,4,5) order by 1, 2, 3;
select col5, percentile_disc(0.9) within group (order by col3) over(partition by col5) p_disc from (select * from p_disc order by 1,2,3,4,5) order by 1, 2;
select col1, col2, col3, col4, col5, percentile_disc(0.9) within group (order by col6) over(partition by 5, 3, 2, 1) p_disc from (select * from p_disc order by 1,2,3,4,5) order by 1, 2, 3;


--TEST: [er] OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, percentile_disc(0.99) within group (order by col4) over(order by col1) p_disc1 from (select * from p_disc order by 1,2,3,4,5) order by 1, 2;
--TEST: order by 3 positions
select col3, col2, percentile_disc(0.4) within group (order by col4) over(order by 1, 2 desc, 3 asc) p_disc from (select * from p_disc order by 1,2,3,4,5) order by 1, 2, 3;


--TEST: [er] OVER(PARTITION BY ORDER BY) clause
select col1, col2, col3, percentile_disc(1) within group (order by col6) over(partition by col1 order by 1, 2, 3) from (select * from p_disc order by 1,2,3,4,5) order by 1, 2, 3, 4;


drop table p_disc; 















