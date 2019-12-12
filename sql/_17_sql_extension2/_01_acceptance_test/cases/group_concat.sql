--GROUP_CONCAT FUNCTION
create table t (test_no int, std_id int, score1 int, score2 int, score3 int);
insert into t values(1, 1, 50, 70, 80); 
insert into t values(1, 2, 40, 30, 50); 
insert into t values(1, 3, 90, 90, 100); 
insert into t values(1, 4, 80, 70, 90); 
insert into t values(2, 1, 60, 60, 80); 
insert into t values(2, 2, 30, 60, 70); 
insert into t values(2, 3, 80, 90, 95); 
insert into t values(2, 4, 60, 70, 100); 
insert into t values(3, 1, 80, 80, 90); 
insert into t values(3, 2, 70, 60, 95); 
insert into t values(3, 3, 90, 70, 85); 
insert into t values(3, 4, 70, 80, 90); 

select test_no, group_concat(score1 order by score1) from t group by test_no order by test_no;
select std_id, group_concat(score2 order by score2) from t group by std_id;
select std_id, group_concat((score1 + 100) order by (score1 + 100)), group_concat((score2 - 100) order by (score2 - 100) desc separator '*') from t group by std_id;
select std_id, group_concat((score1 * 10) order by (score1 * 10) asc), group_concat((score3 / 10) order by (score3 / 10) separator '::' ) from t group by std_id;

drop table t;

