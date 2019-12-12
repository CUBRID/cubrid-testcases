--TEST: pass string type values to the first param

drop table if exists p_disc;
create table p_disc(
	col1 char(20),
	col2 varchar(100), 
	col3 char(10),
	col4 string,
	col5 enum('character', 'string'),
	col6 string
);


insert into p_disc values('aaaaa', 'This is a dog.', '0.5', '0.7', 'character', 35);
insert into p_disc values('aaaaa', 'This is a cat.', '0.5', '0.7', 'character', 19);
insert into p_disc values('aaaaa', 'This is a dog.', '0.5', '0.7', 'character', 22);
insert into p_disc values('aaaaa', 'This is a cat.', '0.5', '0.7', 'character', 19);
insert into p_disc values('aaaaa', 'This is a dog.', '0.5', '0.7', 'character', 35);
insert into p_disc values('eeeee', 'This is a cat.', '0.5', '0.7', 'character', 19);
insert into p_disc values('eeeee', 'This is a dog.', '0.5', '0.7', 'character', 22);
insert into p_disc values('eeeee', 'This is a dog.', '0.5', '0.7', 'character', 19);
insert into p_disc values('eeeee', 'This is a rabbit.', '0.5', '0.7', 'character', 35);
insert into p_disc values('ccccc', 'This is a dog.', '0.5', '0.7', 'character', 19);
insert into p_disc values('ccccc', 'This is a dog.', '0.5', '0.7', 'string', 19);
insert into p_disc values('ccccc', 'This is a rabbit.', '0.5', '0.7', 'string', 22);
insert into p_disc values('zzzzz', 'This is a dog.', '0.5', '0.7', 'string', 19);
insert into p_disc values('bbbbb', 'This is a dog.', '0.5', '0.7', 'string', 19);
insert into p_disc values('bbbbb', 'This is a cat.', '0.5', '0.7', 'string', 19);
insert into p_disc values('bbbbb', 'This is a dog.', '0.5', '0.7', 'string', 22);
insert into p_disc values('bbbbb', 'This is a dog.', '0.5', '0.7', 'string', 19);
insert into p_disc values('bbbbb', 'This is a rabbit.', '0.5', '0.7', 'string', 19);
insert into p_disc values('bbbbb', 'This is a dog.', '0.5', '0.7', 'string', 19);
insert into p_disc values('bbbbb', 'This is a dog.', '0.5', '0.7', 'string', 35);


--test: pass constant numeric string values to the first param
select col2, percentile_disc('0') within group(order by col6) p_disc from p_disc group by col2 order by 1, 2; 
select col2, percentile_disc('1') within group(order by col6) p_disc from p_disc group by col2 order by 1, 2; 
select col2, percentile_disc('0.5') within group(order by col6) p_disc from p_disc group by col2 order by 1, 2; 
select col2, percentile_disc('0.88') within group(order by col6) p_disc from p_disc group by col2 order by 1, 2; 
select col2, percentile_disc('20') within group(order by col6) p_disc from p_disc group by col2 order by 1, 2; 
select col2, percentile_disc('-100') within group(order by col6) p_disc from p_disc group by col2 order by 1, 2; 

--test: pass constant character string values to the first param
select col2, percentile_disc('abc') within group(order by col6) p_disc from p_disc group by col2 order by 1, 2;
select col2, percentile_disc('aaa_bbb_ccc') within group(order by col6) p_disc from p_disc group by col2 order by 1, 2;

--test: pass character string type columns to the first param
select col2, percentile_disc(col1) within group(order by col6) p_disc from p_disc group by col2 order by 1, 2;
select col2, percentile_disc(col2) within group(order by col6) p_disc from p_disc group by col2 order by 1, 2;
select col2, percentile_disc(col3) within group(order by col6) p_disc from (select col2, col3, col6 from p_disc order by 1, 2, 3) group by col2 order by 1, 2;
select col2, percentile_disc(col4) within group(order by col6) p_disc from (select col2, col4, col6 from p_disc order by 1, 2, 3) group by col2 order by 1, 2;
select col2, percentile_disc(col5) within group(order by col6) p_disc from p_disc group by col2 order by 1, 2;
select col2, percentile_disc(col6) within group(order by col5) p_disc from p_disc group by col2 order by 1, 2;


drop table p_disc;






