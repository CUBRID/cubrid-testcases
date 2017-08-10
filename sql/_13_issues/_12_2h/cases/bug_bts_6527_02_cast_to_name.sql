create table t (decoy int);

select cast (1 as xyz);
select cast (1 as t);
select cast (1 as t) from t;

select cast (cast (decoy as varchar) as xyz) from t;
select cast (cast (decoy as xyz) as varchar) from t;

drop table t;
