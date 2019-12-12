--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';

drop table if exists t;
create table t (a int, "nulls last" varchar);
insert into t values
(1,null),
(2,null),
(2,'cd'),
(3,'ab'),
(4,null),
(5,'ab'),
(6,null),
(7,'abcd'),
(8,null),
(9,'abcd'),
(10,null),
(11,ucase(null));



--right feature
--@queryplan
select * from t group by 2,1 order by 1,2;
--@queryplan
select * from t group by 2,1 order by 1,2 nulls first;

--error feature
--@queryplan
select * from t group by 2,1 order by 1,2 nulls last ;

drop table if exists t;

set system parameters 'dont_reuse_heap_file=no';
--+ holdcas off;
commit;
