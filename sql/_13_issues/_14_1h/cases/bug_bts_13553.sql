
--+ holdcas on;

drop table if exists t;
create table t (test_no int, std_id int, score1 int, score2 int, score3 int);

insert into t values(2, 1, 60, 60, 80);
insert into t values(1, 1, 50, 70, 80); 
--error
select std_id, group_concat(distinct score1 order by 1 separator X'31') from t group by std_id;
select std_id, group_concat(distinct score1 order by 1 separator B'00110001') from t group by std_id;
select std_id, group_concat(score1 order by 1 separator X'31') from t group by std_id;
select std_id, group_concat(score1 order by 1 separator B'00110001') from t group by std_id;

drop table if exists t;

--+ holdcas off;
commit;
