--+ holdcas on;
--sort priority
drop table if exists t;
create table t (a int, b varchar);

insert into t values
(1,null),
(2,null),
(3,'ab'),
(4,null),
(5,'ab'),
(6,null),
(7,'abcd'),
(8,null),
(9,'abcd'),
(10,null);

select * from t order by (case when b is null then 2 else 1 end) nulls first,a desc;
select * from t order by (case when b is null then 2 else 1 end) nulls last,a desc;

drop table if exists t;

commit;
--+ holdcas off;
