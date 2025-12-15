--Test bug cubrid_sus665
create table par_t (
pgm_id char(20),
dummy char(1000)
)
partition by list (pgm_id) (
partition day_01 values in ('day_01'),
partition day_02 values in ('day_02'),
partition day_03 values in ('day_03')
);

create index par_index on par_t (pgm_id)  with online;

drop index par_index on par_t;

SELECT index_name, is_unique, is_reverse, class_name, owner_name, key_count, is_primary_key, is_foreign_key, filter_expression, have_function, comment, status FROM db_index where index_name like 'par_index%';

drop table par_t;
