drop if exists t;
create table t(i int primary key, name varchar(20),job varchar(20));
insert into t values(1,'Jone','teacher');
insert into t values(2,'Chandel','programmer');
insert into t values(3,'Jim',null);
insert into t select rownum+3,'person'||rownum,'unkown' from db_root connect by level <=10;
create index idx_t_job on t(job,i asc);

--expr:unsign int
prepare stmt from 'select * from t where job=? using index idx_t_job keylimit ?,?';
execute stmt using 'unkown',0,3;
prepare stmt from 'select * from t where job=? using index idx_t_job keylimit ?,?';
execute stmt using 'unkown',4,3;
prepare stmt from 'select * from t where job=? using index idx_t_job keylimit ?,?';
execute stmt using 'unkown',4,5;
prepare stmt from 'select * from t where job=? using index idx_t_job keylimit ? ';
execute stmt using 'unkown',0;
prepare stmt from 'select * from t where job=? using index idx_t_job keylimit ?';
execute stmt using 'unkown',1;
prepare stmt from 'select * from t where job=? using index idx_t_job keylimit ? ';
execute stmt using 'unkown',5;
prepare stmt from 'select * from t where job=? using index idx_t_job keylimit ?';
execute stmt using 'unkown',1000;

--expr: unsign int+unsign int
prepare stmt from 'select * from t where job=? using index idx_t_job keylimit ?+?,?';
execute stmt using 'unkown',0,2,3;
prepare stmt from 'select * from t where job=? using index idx_t_job keylimit ?+?,? ';
execute stmt using 'unkown',4,0,3;
prepare stmt from 'select * from t where job=? using index idx_t_job keylimit ?+?,? ';
execute stmt using 'unkown',4,2,3;
prepare stmt from 'select * from t where job=? using index idx_t_job keylimit ?+?,? ';
execute stmt using 'unkown',4,1000,3;
prepare stmt from 'select * from t where job=? using index idx_t_job keylimit ?+? ';
execute stmt using 'unkown',0,1;
prepare stmt from 'select * from t where job=? using index idx_t_job keylimit ?+? ';
execute stmt using 'unkown',0,1000;
prepare stmt from 'select * from t where job=? using index idx_t_job keylimit ?+?,?+?';
execute stmt using 'unkown',0,2,3,1;
prepare stmt from 'select * from t where job=? using index idx_t_job keylimit ?+?,? +?';
execute stmt using 'unkown',4,0,3,0;
prepare stmt from 'select * from t where job=? using index idx_t_job keylimit ?+?,? +?';
execute stmt using 'unkown',4,0,3,1000;

--expr: unsign int-unsign int
prepare stmt from 'select * from t where job=? using index idx_t_job keylimit ?-?,?';
execute stmt using 'unkown',0,2,3;
prepare stmt from 'select * from t where job=? using index idx_t_job keylimit ?-?,?';
execute stmt using 'unkown',4,0,3;
prepare stmt from 'select * from t where job=? using index idx_t_job keylimit ?-?,? ';
execute stmt using 'unkown',4,2,3;
prepare stmt from 'select * from t where job=? using index idx_t_job keylimit ?-?,?';
execute stmt using 'unkown',4,1000,3;
prepare stmt from 'select * from t where job=? using index idx_t_job keylimit ?-?';
execute stmt using 'unkown',0,1;
prepare stmt from 'select * from t where job=? using index idx_t_job keylimit ?-?';
execute stmt using 'unkown',0,1000;
prepare stmt from 'select * from t where job=? using index idx_t_job keylimit ?-?,?-?';
execute stmt using 'unkown',0,2,3,1;
prepare stmt from 'select * from t where job=? using index idx_t_job keylimit ?-?,? -?';
execute stmt using 'unkown',4,0,3,0;
prepare stmt from 'select * from t where job=? using index idx_t_job keylimit ?-?,? -?';
execute stmt using 'unkown',4,0,3,1000;


--nvl
set @a=3;
prepare stmt from 'select * from t where job=? using index idx_t_job keylimit @a,?';
execute stmt using 'unkown',3;
prepare stmt from 'select * from t where job=? using index idx_t_job keylimit nvl(null,?),?';
execute stmt using 'unkown',0,3;
prepare stmt from 'select * from t where job=? using index idx_t_job keylimit nvl(null,?),?';
execute stmt using 'unkown',1,3;
deallocate prepare stmt;
drop if exists t;
