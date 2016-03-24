drop  table if exists  t1;

CREATE TABLE t1 (i int, code VARCHAR(10));
insert into t1(i, code) values (1, 'BE');
insert into t1(i, code) values (2, 'Be');
insert into t1(i, code) values (3, 'b');
insert into t1(i, code) values (4, 'B');
insert into t1(i, code) values (5, 'b ');
insert into t1(i, code) values (6, chr(9));    -- \t
insert into t1(i, code) values (7, chr(13));   -- \r
insert into t1(i, code) values (8, chr(10));   -- \n
 
select i, code from t1 order by i;

drop table t1;
