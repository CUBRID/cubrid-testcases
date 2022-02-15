
create table t1 (i1 int, i2 int, i3 int);
create index i_t1_i1_i2_d on t1(i1, i2 desc);
create index i_t1_i1_i2_d_i3 on t1(i1, i2 desc, i3);

insert into t1 values (0, 0, 00), (0, 1, 01), (0, 2, 02), (0, 3, 03), (0, 4, 04);
insert into t1 values (1, 0, 10), (1, 1, 11), (1, 2, 12), (1, 3, 13), (1, 4, 14);
insert into t1 values (2, 0, 20), (2, 1, 21), (2, 2, 22), (2, 3, 23), (2, 4, 24);
insert into t1 values (3, 0, 30), (3, 1, 31), (3, 2, 32), (3, 3, 33), (3, 4, 34);
insert into t1 values (4, 0, 40), (4, 1, 41), (4, 2, 42), (4, 3, 43), (4, 4, 44);

select /*+ recompile */ * from t1 where i1 in (1,3) order by i2 desc limit 3;
select /*+ recompile */ * from t1 where i1 = 1 or i1 = 3 order by i2 desc limit 3;

-- key filter predicate on second column
select /*+ recompile */ * from t1 where i1 in (1,3) and i2 != 4 order by i2 desc limit 3;

-- more complex predicate
select /*+ recompile */ * from t1 where i1 in (1,3) and i1+i2 != 4 order by i2 desc limit 3;
select /*+ recompile */ * from t1 where i1 in (1,3) and i1+i2 = 4 order by i2 desc limit 3;
select /*+ recompile */ t1.*, concat_ws('.',i1,i2) from t1 where i1 in (1,3) and concat_ws('.',i1,i2) < '3.3' order by i2 desc limit 3;
select /*+ recompile */ t1.*, concat_ws('.',i1,i2) from t1 where i1 in (1,3) and concat_ws('.',i1,i2) between '1.2' and '3.4' order by i2 desc limit 5;

-- limit with host variables, more complex upper limit
prepare stmt from 'select /*+ recompile */ * from t1 where i1 in (1,3) and i2 < 4 order by i2 desc limit ?'; execute stmt using 3; execute stmt using 5; deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ * from t1 where i1 in (1,3) and i2 < 4 order by i2 desc for orderby_num()<? and orderby_num()<? and orderby_num()<?'; execute stmt using 6,8,4; execute stmt using 7,3,5; execute stmt using 5,6,7; deallocate prepare stmt;

-- key filter predicate on i2 and i3
select /*+ recompile */ t1.*, i3 div 10 from t1 where i1 in (1,2,3) and i2 < 4 and i3 div 10 > 1 order by i2 desc limit 5;

-- key filter predicate on i3 only
select /*+ recompile */ t1.*, i3 div 10 from t1 where i1 in (1,2,3) and i3 div 10 > 1 order by i2 desc limit 5;

drop table t1;

create table tab1(id int, num int);
insert into tab1 values (0,0);
insert into tab1 values (0,1);
insert into tab1 values (0,2);
insert into tab1 values (0,3);
insert into tab1 values (0,4);
insert into tab1 values (1,0);
insert into tab1 values (1,1);
insert into tab1 values (1,2);
insert into tab1 values (1,3);
insert into tab1 values (1,4);
insert into tab1 values (2,0);
insert into tab1 values (2,1);
insert into tab1 values (2,2);
insert into tab1 values (2,3);
insert into tab1 values (2,4);
insert into tab1 values (3,0);
insert into tab1 values (3,1);
insert into tab1 values (3,2);
insert into tab1 values (3,3);
insert into tab1 values (3,4);
insert into tab1 values (4,0);
insert into tab1 values (4,1);
insert into tab1 values (4,2);
insert into tab1 values (4,3);
insert into tab1 values (4,4);
insert into tab1 values (5,0);
insert into tab1 values (5,1);
insert into tab1 values (5,2);
insert into tab1 values (5,3);
insert into tab1 values (5,4);
create index  i_tab1_id_num on  tab1(id, num);

select /*+ recompile */ * from tab1 where id in (1,3,4,5) and num between 1 and 3 order by num limit 9;
select /*+ recompile */ * from tab1 where (id = 0 or id = 5) and num != 0 order by num limit 5;

drop table tab1;
