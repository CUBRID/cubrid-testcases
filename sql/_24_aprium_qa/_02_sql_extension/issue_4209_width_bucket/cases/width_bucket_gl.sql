--combination with group by and limit clause


create table wb_gl(
	col1 int auto_increment primary key,
	col2 smallint,
	col3 char(30) default 'abc',
	col4 date default SYSDATE,
	col5 clob
);


insert into wb_gl(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10', 'aello@domainname.com');
insert into wb_gl(col2, col3, col4, col5) values(500, 'cubrid', '1990-11-10', 'bello@domainname.com');
insert into wb_gl(col2, col3, col4, col5) values(500, 'mysql', '1990-10-11', 'cello@domainname.com');
insert into wb_gl(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10', 'dello@domainname.com');
insert into wb_gl(col2, col3, col4, col5) values(500, 'cubrid', '1991-10-10', 'eello@domainname.com');
insert into wb_gl(col2, col3, col4, col5) values(501, 'oracle', '1990-10-10', 'fello@domainname.com');
insert into wb_gl(col2, col3, col4, col5) values(501, 'cubrid', '1992-10-10', 'gello@domainname.com');
insert into wb_gl(col2, col3, col4, col5) values(501, 'oracle', '1990-11-10', 'hello@domainname.com');
insert into wb_gl(col2, col3, col4, col5) values(501, 'mysql', '1990-10-10', 'iello@domainname.com');
insert into wb_gl(col2, col3, col4, col5) values(501, 'cubrid', '1990-10-10', 'jello@domainname.com');
insert into wb_gl(col2, col3, col4, col5) values(501, 'mysql', '1991-11-10', 'kello@domainname.com');
insert into wb_gl(col2, col3, col4, col5) values(502, 'cubrid', '1990-10-10', 'lello@domainname.com');
insert into wb_gl(col2, col3, col4, col5) values(502, 'mysql', '1990-10-10', 'mello@domainname.com');
insert into wb_gl(col2, col3, col4, col5) values(502, 'mysql', '1992-10-10', 'nello@domainname.com');
insert into wb_gl(col2, col3, col4, col5) values(503, 'mysql', '1992-10-10', 'oello@domainname.com');
insert into wb_gl(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10', 'pello@domainname.com');
insert into wb_gl(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10', 'qello@domainname.com');
insert into wb_gl(col2, col3, col4, col5) values(503, 'oracle', '1993-11-10', 'rello@domainname.com');
insert into wb_gl(col2, col3, col4, col5) values(503, 'oracle', '1993-10-10', 'sello@domainname.com');
insert into wb_gl(col2, col3, col4, col5) values(503, 'cubrid', '1993-11-10', 'tello@domainname.com');
insert into wb_gl(col2, col3, col4, col5) values(503, 'cubrid', '1992-10-10', 'uello@domainname.com');
insert into wb_gl(col2, col3, col4, col5) values(504, 'mysql', '1994-10-10', 'vello@domainname.com');
insert into wb_gl(col2, col3, col4, col5) values(504, 'mysql', '1990-10-10', null);
insert into wb_gl(col2, col3, col4, col5) values(504, 'cubrid', '1995-11-10', 'wello@domainname.com');
insert into wb_gl(col2, col3, col4, col5) values(505, 'cubrid', '1991-10-10', '');
insert into wb_gl(col2, col3, col4, col5) values(505, 'cubrid', '1996-10-10', 'xello@domainname.com');
insert into wb_gl(col2, col3, col4, col5) values(505, 'mysql', '1990-10-10', 'yello@domainname.com');
insert into wb_gl(col2, col3, col4, col5) values(505, 'cubrid', '1995-10-10', null);
insert into wb_gl(col2, col3, col4, col5) values(505, 'cubrid', '1990-10-10', 'zello@domainname.com');



--TEST: group by clause
select col1, width_bucket(col1, 1, 30, 5) b_num from wb_gl group by col1 order by 1;
select col1, col2, width_bucket(col1, 1, 30, 5) b_num from wb_gl group by col1, col2 order by 1;
select col2, width_bucket(col2, 500, 506, 5) b_num from wb_gl where col1 > 10 group by col2 order by 1;
select col1, col3, col2, width_bucket(col2, 500, 506, 5) b_num from wb_gl where col1 > 10 group by col3 order by 1;
select clob_to_char(new.col5), new.col4, width_bucket(new.col4, '1990-01-01', '2000-12-31', 10) b_num from ( select * from wb_gl order by 1,2,3,4 ) new  group by new.col4 order by 1, 2;
select clob_to_char(col5), col4, width_bucket(col4, '1990-01-01', '2000-12-31', 10) b_num from ( select * from wb_gl order by 1,2,3,4 ) group by clob_to_char(col5) order by 1, 2;


--TEST: group by ... having ...
select col2, col1, width_bucket(col1, -10, 50, 40) b_num from ( select * from wb_gl order by 1,2,3,4 ) group by col1 having col2 > 500;
select new.col3, new.col4, clob_to_char(new.col5), width_bucket(new.col4, '1990-01-01', '2000-12-31', 30) b_num from ( select * from wb_gl order by 1,2,3,4 ) new group by new.col3, new.col4 having new.col4 < '1995-12-31' order by new.col3, 2, 3, 4;


--TEST: with limit clause
select col1, width_bucket(col1, 5, 25, 33) b_num from wb_gl order by col1 limit 10;
select col1, col2, width_bucket(col2, 499, 510, 6) b_num from wb_gl where col1 < 20 order by 1, 2 limit 5;
select clob_to_char(col5), col4, width_bucket(col4, '1990-01-01', '2000-12-31', 10) b_num from wb_gl order by 1,2 limit 20; 


--TEST: group by + limit
select col1, width_bucket(col1, 1, 30, 5) b_num from wb_gl group by col1 order by 1 limit 20;
select col1, col3, col2, width_bucket(col2, 500, 506, 5) b_num from wb_gl where col1 > 10 group by col3 order by 1 limit 3;
select col4, width_bucket(col4, '1990-01-01', '2000-12-31', 10) b_num from wb_gl group by col4 order by 1, 2 limit 5;


--TEST: [er] use width_bucket function in group by clause
select group_concat(col1 order by col1), width_bucket(col1, 1, 30, 5) b_num from wb_gl group by width_bucket(col1, 1, 30, 5) order by 1,2; 
--TEST: [er] use width_bucket function in having clause
select col3, col4, width_bucket(col4, '1990-01-01', '2000-12-31', 30) b_num from wb_gl group by col3, col4 having width_bucket(col4, '1990-01-01', '2000-12-31', 30)>3 order by 1,2,3;
--TEST: use width_bucket function in order by clause
select col1, col3, col2, width_bucket(col2, 500, 506, 5) b_num from wb_gl where col1 > 10 order by b_num, col1;
select col1, col3, col2, width_bucket(col2, 500, 506, 5) b_num from wb_gl where col1 > 10 order by width_bucket(col1, 5, 25, 33), col3;
--TEST: use width_bucket function in where clause
select col1, col2, width_bucket(col1, 1, 30, 5) b_num from wb_gl where width_bucket(col1, 1, 30, 5) > 2 order by 1, 2;
select col1, col2, width_bucket(col1, 1, 30, 5) b_num from wb_gl where width_bucket(col2, 500, 510, 10) > 2 order by 1, 2;


delete from wb_gl;
drop table wb_gl;


