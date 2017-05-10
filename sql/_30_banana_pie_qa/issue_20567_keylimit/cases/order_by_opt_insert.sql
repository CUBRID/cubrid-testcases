drop if exists t;
CREATE TABLE t (col1 INT, col2 INT, col3 INT);
CREATE INDEX i_t_col1_col2_col3 ON t (col1,col2,col3);
INSERT INTO t VALUES (1,2,3),(4,5,6),(10,8,9);
drop if exists x;
CREATE TABLE x (col1 INT, col2 INT, col3 INT);

insert into x select * FROM t WHERE col1 < 6 limit 1-1-1-1-1-1-1-1-1-1-1+100000000;
select * from x order by 1,2,3;
insert into x select * FROM t WHERE col1 < 6 using index i_t_col1_col2_col3  keylimit 1-1-1-1-1-1-1-1-1-1-1+100000000;
select * from x order by 1,2,3;
insert into x select * FROM t WHERE col1 < 6 using index i_t_col1_col2_col3  keylimit 0,1-1-1-1-1-1-1-1-1-1-1+100000000;
select * from x order by 1,2,3;
insert into x select * FROM t WHERE col1 < 6 using index i_t_col1_col2_col3  keylimit 1,1-1-1-1-1-1-1-1-1-1-1+100000000; 
select * from x order by 1,2,3;

CREATE INDEX i_t_col1_col2 ON t (col1,col2);
insert into x select * FROM t WHERE col1< 6 order by col1,col2 limit 1-1-1-1-1-1-1-1-1-1-1+100000000;
select * from x order by 1,2,3;
insert into x select * FROM t WHERE col1< 6 order by col1,col2;
select * from x order by 1,2,3;
insert into x select * FROM t WHERE col1< 6 order by col1,col2 limit 0,2;
select * from x order by 1,2,3;

drop if exists t,x;
