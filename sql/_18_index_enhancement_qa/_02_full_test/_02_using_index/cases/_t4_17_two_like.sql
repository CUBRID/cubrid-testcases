create table t (a int, b varchar(20), c char(20));
insert into t select rownum, cast(rownum as varchar(20)), cast(rownum as char(20)) from db_class a, db_class b, db_class c limit 50000;

create index i_t_b_c  on t (b,c);

PREPARE stmt from 'select /*+ recompile */ b,c from t where b like ?||''%'' and c like ?||''%'' '
EXECUTE stmt using '99', '99888'
DEALLOCATE PREPARE stmt;

PREPARE stmt from 'select /*+ recompile */ b,c from t where b like ?||''%'' and c like ?||''%''  and b||c like ?||''%'' '
EXECUTE stmt using '99', '99888', '988899'
EXECUTE stmt using '99', '99888', '9888%99'
DEALLOCATE PREPARE stmt;

PREPARE stmt from 'select /*+ recompile */ b,c from t where b like ?||''%'' and c like ?||''%''  and b like ?||''%'' '
EXECUTE stmt using '99', '99888', '99888X'
EXECUTE stmt using '99', '99888', '99888'
DEALLOCATE PREPARE stmt;

PREPARE stmt from 'select /*+ recompile */ b,c from t where b like ?||''%'' and c like a||''%''  and b like ?||''%'' '
EXECUTE stmt using '99', '99888'
DEALLOCATE PREPARE stmt;

PREPARE stmt from 'select /*+ recompile */ b,c from t where b like ?||''%'' and b like ?||''%'' and b like ?||''%'' '
EXECUTE stmt using '99', '9988', '99888'
DEALLOCATE PREPARE stmt;

drop table t;




