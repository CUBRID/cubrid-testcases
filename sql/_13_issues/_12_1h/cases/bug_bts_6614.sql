autocommit off;
drop table if exists t;
create table t( col1 integer unique,	col2  varchar(255),col3	  varchar(4096));
insert into t(col1, col2, col3)
    values
	(10, 'aab', 'the textbook'),
	(11, 'xab', 'book col3'),
	(12, 'xxy', 'book chapters'),
	(13, 'xa0', 'author names'),
	(14, 'xa1', 'xa1'),
	(15, 'xab', 'xab'),
	(16, 'aff', 'syntax col3'),
	(17, 'afg', 'operators list');

create index i_t_col1_col2 on t(col1, col2) where col1 < 15;

commit;


select /*+ recompile */ * from t order by col1;

select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) order by col1;

select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) difference select /*+ recompile */ * from t where col1 < 15;


insert into t(col1, col2) values (18, '   ');
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) order by col1;

select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) difference select /*+ recompile */ * from t where col1 < 15;


update t set col1 = col1 + 20 where col1 < 12;
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) order by col1;

select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) difference select /*+ recompile */ * from t where col1 < 15;


savepoint sp1;
update t set col1 = col1 - 10 where col1 > 15 and col1 < 18;
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) order by col1;

select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) difference select /*+ recompile */ * from t where col1 < 15;


savepoint sp2;
replace t(col1, col3) values (17, 'personnel list');
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) order by col1;

select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) difference select /*+ recompile */ * from t where col1 < 15;


savepoint sp3;
delete from t where col1 > 12 and col1 < 17;
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) order by col1;

select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) difference select /*+ recompile */ * from t where col1 < 15;


savepoint sp4;
truncate t;
select /*+ recompile */ * from t;

select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+);

select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) difference select /*+ recompile */ * from t;

rollback to savepoint sp4;
 after delete --
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) order by col1;

select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) difference select /*+ recompile */ * from t where col1 < 15;


rollback to savepoint sp3;
-- after replace --
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) order by col1;

select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) difference select /*+ recompile */ * from t where col1 < 15;


rollback to savepoint sp2;
 after update --
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) order by col1;

select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) difference select /*+ recompile */ * from t where col1 < 15;

rollback to savepoint sp1;
 after the insert and the first update --
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) order by col1;

select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) difference select /*+ recompile */ * from t where col1 < 15;

rollback;
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) order by col1;
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) difference select /*+ recompile */ * from t where col1 < 15;



    -- a new transaction starts here, repeat all statements for a direct rollback
select /*+ recompile */ * from t order by col1;
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) order by col1;
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) difference select /*+ recompile */ * from t where col1 < 15;

insert into t(col1, col2) values (18, '   ');
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) order by col1;
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) difference select /*+ recompile */ * from t where col1 < 15;

update t set col1 = col1 + 20 where col1 < 12;
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) order by col1;
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) difference select /*+ recompile */ * from t where col1 < 15;

savepoint sp1;
update t set col1 = col1 - 10 where col1 > 15 and col1 < 18;
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) order by col1;
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) difference select /*+ recompile */ * from t where col1 < 15;

savepoint sp2;
replace t(col1, col3) values (17, 'personnel list');
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) order by col1;
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) difference select /*+ recompile */ * from t where col1 < 15;

savepoint sp3;
delete from t where col1 > 12 and col1 < 17;
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) order by col1;
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) difference select /*+ recompile */ * from t where col1 < 15;

savepoint sp4;
truncate t;
select /*+ recompile */ * from t;
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+);
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) difference select /*+ recompile */ * from t;


rollback;
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+);

select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) difference select /*+ recompile */ * from t;



 new transaction, repeat all statements for a random savepoint
select /*+ recompile */ * from t order by col1;

select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) order by col1;

select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) difference select /*+ recompile */ * from t where col1 < 15;


insert into t(col1, col2) values (18, '   ');
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) order by col1;

select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) difference select /*+ recompile */ * from t where col1 < 15;


update t set col1 = col1 + 20 where col1 < 12;
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) order by col1;

select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) difference select /*+ recompile */ * from t where col1 < 15;


savepoint sp1;
update t set col1 = col1 - 10 where col1 > 15 and col1 < 18;
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) order by col1;

select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) difference select /*+ recompile */ * from t where col1 < 15;


savepoint sp2;
replace t(col1, col3) values (17, 'personnel list');
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) order by col1;

select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) difference select /*+ recompile */ * from t where col1 < 15;


savepoint sp3;
delete from t where col1 > 12 and col1 < 17;
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) order by col1;

select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) difference select /*+ recompile */ * from t where col1 < 15;


savepoint sp4;
truncate t;
select /*+ recompile */ * from t;
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+);

select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) difference select /*+ recompile */ * from t;


rollback to savepoint sp1;
select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+);

select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) difference select /*+ recompile */ * from t;

commit;


select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+);

select /*+ recompile */ * from t where col1 > -1 using index i_t_col1_col2(+) difference select /*+ recompile */ * from t;


drop table t;
commit;

autocommit on;

