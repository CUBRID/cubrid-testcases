--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t (id int, a varchar(10));
insert into t values (1,'');
insert into t values (2,chr(0));
insert into t values (3,chr(0)||'a');
insert into t values (4,chr(1));

select id,length(a),a from t order by id asc;
--A: we expect id in (2,3) should return.
select id,length(a),a from t where a like concat(chr(0),'%');
--B: the result should be the same as A. 
prepare stmt from 'select /*+ recompile */ id,length(a),a from t where a like concat(chr(?),''%'') ';
execute stmt using 0;
deallocate prepare stmt;

drop table t;


create table t (id int, a varchar(10));
insert into t values (1,'');
insert into t values (2,chr(1));
insert into t values (3,chr(1)||'a');
insert into t values (4,chr(1));

select id,length(a),a from t order by id asc;

--A: result is good
select /*+ recompile */ id,length(a),a from t where a like concat(chr(1),'%');
--B: the result should be the same as A.
prepare stmt from 'select /*+ recompile */ id,length(a),a from t where a like concat(chr(?),''%'') ';
execute stmt using 1;
deallocate prepare stmt;

drop table t;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
