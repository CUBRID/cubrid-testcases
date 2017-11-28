drop table if exists t1;              
create table t1(i int, j json);
insert into t1 values (1, true);
insert into t1 values (2, false);
insert into t1 values (3, null);
insert into t1 values (4, TRUE);
insert into t1 values (5, FALSE);
insert into t1 values (6, NULL);
insert into t1 values (7, 'true');
insert into t1 values (8, 'false');
insert into t1 values (9, 'TRUE');
insert into t1 values (10, 'FALSE');
-- CBRD-21660 
--select i,j,json_type(j) from t1 order by i,j;
-- CBRD-21661
select i,j from t1 order by i,j;
drop table if exists t1;
