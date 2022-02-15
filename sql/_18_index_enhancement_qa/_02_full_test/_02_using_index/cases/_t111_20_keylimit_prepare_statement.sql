
create table t (a int, b varchar, c datetime);

create index i_t_c_b  on t(c,b);

insert into t select rownum, cast(rownum as varchar), DATETIME'03/17/2011' from db_class a, db_class b, db_class c limit 20000;

insert into t values (30000, '30000', DATETIME'03/18/2011');
insert into t values (30001, '30001', DATETIME'03/19/2011');
insert into t values (30002, '30002', DATETIME'03/20/2011');

PREPARE stmt FROM 'select b,c from t where b > ''0'' and c > DATETIME''03/01/2011'' using index i_t_c_b keylimit ?,? ';
EXECUTE stmt using 20000, 3;
DEALLOCATE PREPARE stmt;

select b,c from t where b > '0' and c > DATETIME '03/01/2011' using index i_t_c_b keylimit 20000,3;

drop table t;

