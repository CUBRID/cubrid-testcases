autocommit off;
create table t
	(
	    id		    integer unique,
	    textlabel	    varchar(255),
	    description	    varchar(4096)
	);
insert into t(id, textlabel, description)
    values
	(10, 'aab', 'the textbook'),
	(11, 'xab', 'book description'),
	(12, 'xxy', 'book chapters'),
	(13, 'xa0', 'author names'),
	(14, 'xa1', 'xa1'),
	(15, 'xab', 'xab'),
	(16, 'aff', 'syntax description'),
	(17, 'afg', 'operators list');

create index i_t_id_text on t(id, textlabel) where id < 15;

commit;

    -- a new transaction starts here
select /*+ recompile */ * from t order by id;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) order by id;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) difference select /*+ recompile */ * from t where id < 15;

insert into t(id, textlabel) values (18, '   ');
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) order by id;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) difference select /*+ recompile */ * from t where id < 15;

update t set id = id + 20 where id < 12;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) order by id;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) difference select /*+ recompile */ * from t where id < 15;

savepoint sp1;
update t set id = id - 10 where id > 15 and id < 18;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) order by id;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) difference select /*+ recompile */ * from t where id < 15;

savepoint sp2;
replace t(id, description) values (17, 'personnel list');
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) order by id;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) difference select /*+ recompile */ * from t where id < 15;

savepoint sp3;
delete from t where id > 12 and id < 17;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) order by id;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) difference select /*+ recompile */ * from t where id < 15;

savepoint sp4;
truncate t;
select /*+ recompile */ * from t;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+);
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) difference select /*+ recompile */ * from t;

rollback to savepoint sp4;
-- after delete --
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) order by id;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) difference select /*+ recompile */ * from t where id < 15;

rollback to savepoint sp3;
-- after replace --
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) order by id;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) difference select /*+ recompile */ * from t where id < 15;


rollback to savepoint sp2;
-- after update --
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) order by id;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) difference select /*+ recompile */ * from t where id < 15;

rollback to savepoint sp1;
-- after the insert and the first update --
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) order by id;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) difference select /*+ recompile */ * from t where id < 15;

rollback;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) order by id;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) difference select /*+ recompile */ * from t where id < 15;



    -- a new transaction starts here, repeat all statements for a direct rollback
select /*+ recompile */ * from t order by id;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) order by id;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) difference select /*+ recompile */ * from t where id < 15;

insert into t(id, textlabel) values (18, '   ');
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) order by id;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) difference select /*+ recompile */ * from t where id < 15;

update t set id = id + 20 where id < 12;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) order by id;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) difference select /*+ recompile */ * from t where id < 15;

savepoint sp1;
update t set id = id - 10 where id > 15 and id < 18;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) order by id;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) difference select /*+ recompile */ * from t where id < 15;

savepoint sp2;
replace t(id, description) values (17, 'personnel list');
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) order by id;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) difference select /*+ recompile */ * from t where id < 15;

savepoint sp3;
delete from t where id > 12 and id < 17;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) order by id;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) difference select /*+ recompile */ * from t where id < 15;

savepoint sp4;
truncate t;
select /*+ recompile */ * from t;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+);
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) difference select /*+ recompile */ * from t;

rollback;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+);
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) difference select /*+ recompile */ * from t;



    -- new transaction, repeat all statements for a random savepoint
select /*+ recompile */ * from t order by id;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) order by id;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) difference select /*+ recompile */ * from t where id < 15;

insert into t(id, textlabel) values (18, '   ');
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) order by id;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) difference select /*+ recompile */ * from t where id < 15;

update t set id = id + 20 where id < 12;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) order by id;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) difference select /*+ recompile */ * from t where id < 15;

savepoint sp1;
update t set id = id - 10 where id > 15 and id < 18;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) order by id;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) difference select /*+ recompile */ * from t where id < 15;

savepoint sp2;
replace t(id, description) values (17, 'personnel list');
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) order by id;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) difference select /*+ recompile */ * from t where id < 15;

savepoint sp3;
delete from t where id > 12 and id < 17;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) order by id;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) difference select /*+ recompile */ * from t where id < 15;

savepoint sp4;
truncate t;
select /*+ recompile */ * from t;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+);
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) difference select /*+ recompile */ * from t;


rollback to savepoint sp1;
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+);
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) difference select /*+ recompile */ * from t;

commit;

select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+);
select /*+ recompile */ * from t where id > -1 using index i_t_id_text(+) difference select /*+ recompile */ * from t;


drop table t;
commit;
autocommit on;

