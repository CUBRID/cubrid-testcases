--TEST: pass string type values to the second param

drop table if exists p_disc;
create table p_disc(
	col1 char(20),
	col2 varchar(100), 
	col3 char(10),
	col4 string,
	col5 enum('character', 'string'),
	col6 varchar(10)
);


insert into p_disc values('aaaaa', 'This is a dog.', '0.5', '0.7', 'character', 3.5);
insert into p_disc values('aaaaa', 'This is a cat.', '0.5', '0.7', 'character', 1.9);
insert into p_disc values('aaaaa', 'This is a dog.', '0.5', '0.7', 'character', 2.2);
insert into p_disc values('aaaaa', 'This is a cat.', '0.5', '0.7', 'character', 1.9);
insert into p_disc values('aaaaa', 'This is a dog.', '0.5', '0.7', 'character', 3.5);
insert into p_disc values('eeeee', 'This is a cat.', '0.5', '0.7', 'character', 1.9);
insert into p_disc values('eeeee', 'This is a dog.', '0.5', '0.7', 'character', 2.2);
insert into p_disc values('eeeee', 'This is a dog.', '0.5', '0.7', 'character', 1.9);
insert into p_disc values('eeeee', 'This is a rabbit.', '0.5', '0.7', 'character', 3.5);
insert into p_disc values('ccccc', 'This is a dog.', '0.5', '0.7', 'character', 1.9);
insert into p_disc values('ccccc', 'This is a dog.', '0.5', '0.7', 'string', 1.9);
insert into p_disc values('ccccc', 'This is a rabbit.', '0.5', '0.7', 'string', 2.2);
insert into p_disc values('zzzzz', 'This is a dog.', '0.5', '0.7', 'string', 1.9);
insert into p_disc values('bbbbb', 'This is a dog.', '0.5', '0.7', 'string', 1.9);
insert into p_disc values('bbbbb', 'This is a cat.', '0.5', '0.7', 'string', 1.9);
insert into p_disc values('bbbbb', 'This is a dog.', '0.5', '0.7', 'string', 2.2);
insert into p_disc values('bbbbb', 'This is a dog.', '0.5', '0.7', 'string', 1.9);
insert into p_disc values('bbbbb', 'This is a rabbit.', '0.5', '0.7', 'string', 1.9);
insert into p_disc values('bbbbb', 'This is a dog.', '0.5', '0.7', 'string', 1.9);
insert into p_disc values('bbbbb', 'This is a dog.', '0.5', '0.7', 'string', 3.5);


--test: pass constant numeric string values to the second param
select col2, percentile_disc(0.5) within group(order by '1') p_disc from p_disc group by col2 order by 1, 2; 
select col2, col3, percentile_disc(0.8) within group(order by '2') p_disc from p_disc group by col2 order by 1, 2; 
select col2, percentile_disc('0.5') within group(order by '3') p_disc from p_disc group by col2 order by 1, 2; 
select col2, percentile_disc('0.5') within group(order by '0.8') p_disc from p_disc group by col2 order by 1, 2; 
select col2, percentile_disc(0.8) within group(order by '100') p_disc from p_disc group by col2 order by 1, 2; 
select col2, percentile_disc(0.4) within group(order by '-2') p_disc from p_disc group by col2 order by 1, 2; 

--test: pass constant character string values to the second param
select col2, percentile_disc(0.1) within group(order by 'abc') p_disc from p_disc group by col2 order by 1, 2;
select col2, percentile_disc(0.9) within group(order by 'This is a dog') p_disc from p_disc group by col2 order by 1, 2;

--test: pass character string type columns to the second param
select col2, percentile_disc(0.1) within group(order by col1) p_disc from p_disc group by col2 order by 1, 2;
select col2, percentile_disc(0.2) within group(order by col2) p_disc from p_disc group by col2 order by 1, 2;
select col2, percentile_disc(0.3) within group(order by col3) p_disc from p_disc group by col2 order by 1, 2;
select col2, percentile_disc(0.4) within group(order by col4) p_disc from p_disc group by col2 order by 1, 2;
select col2, percentile_disc(0.5) within group(order by col5) p_disc from p_disc group by col2 order by 1, 2;
select col2, percentile_disc(0.6) within group(order by col6) p_disc from p_disc group by col2 order by 1, 2;

--test: [er] pass more than 1 columns to the second param
select col2, percentile_disc(0.1) within group(order by col1, col3) from p_disc group by col2 order by 1, 2;
select col2, percentile_disc(0.1) within group(order by col5, col4, col3) from p_disc group by col2 order by 1, 2;
select col2, col3, col4, col5, percentile_disc(0.5) within group(order by 4, 3, 2, 1) from p_disc group by col2, col3, col4, col5 order by 1, 2;


drop table p_disc;






