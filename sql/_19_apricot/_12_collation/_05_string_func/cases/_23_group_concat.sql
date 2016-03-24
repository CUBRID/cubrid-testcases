create table t1 (s1 string collate utf8_en_ci, i integer);
create table t2 (s1 string collate utf8_en_cs, i integer);

insert into t1 values ('Aby', 1), ('aay',1);
insert into t1 values ('Aby', 2), ('aay',2);

insert into t2 values ('Aby', 1), ('aay',1);
insert into t2 values ('Aby', 2), ('aay',2);

select if(group_concat (s1) in ('aay,Aby', 'Aby,aay'), 'ok', 'nok' )  from (select * from t1 order by 1,2) group by i order by 1;
select if(group_concat (s1) in ('aay,Aby', 'Aby,aay'), 'ok', 'nok' ) from (select * from t2 order by 1,2) group by i order by 1;

select group_concat (s1) from t1 group by s1 order by 1;
select group_concat (s1) from t2 group by s1 order by 1;

select group_concat (s1 order by 1) from t1 group by i order by 1;
select group_concat (s1 order by 1) from t2 group by i order by 1;

select group_concat (s1 order by 1) from t1 group by i order by 1;
select group_concat (s1 order by 1) from t2 group by i order by 1;


select group_concat (s1 order by 1 separator '+') from t1 group by i order by 1;
select group_concat (s1 order by 1 separator '+') from t2 group by i order by 1;

drop table t1;
drop table t2;
