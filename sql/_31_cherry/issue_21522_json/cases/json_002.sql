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
insert into t1 values (11, 1);
insert into t1 values (11, 0);
insert into t1 values (11, 2);

select i,j,json_type(j) from t1 order by i,j;
select i,j,json_type(j) from t1 order by j,i;
drop table if exists t1;
