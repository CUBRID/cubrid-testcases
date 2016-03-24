drop table if exists t;
create table t1 (a enum('aaa'));
insert into t1 values('aaa');
select ifnull(a,a) from t1;

select ifnull(a,a),ifnull(a,a),ifnull(a,a),ifnull(a,a),ifnull(a,a),ifnull(a,a),ifnull(a,a),ifnull(a,a) from t1;
select ifnull(1,1),ifnull(1,1),ifnull(1,1),ifnull(1,1),ifnull(1,1),ifnull(1,1),ifnull(1,1),ifnull(1,1) from t1;
select ifnull(0,0),ifnull(0,0),ifnull(0,0),ifnull(0,0),ifnull(0,0),ifnull(0,0),ifnull(0,0),ifnull(0,0) from t1;
select ifnull(000,000),ifnull(000,000),ifnull(000,000),ifnull(000,000),ifnull(000,000),ifnull(000,000),ifnull(000,000),ifnull(000,000) from t1;

drop table t1;
