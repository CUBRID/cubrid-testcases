--test: CBRD-28454 a ROWNUM paging query over an ordered join view whose ROWNUM bounds are host variables
--test: The compilation of a bind type signature sees no value of the ROWNUM bounds: they become an ORDERBY_NUM () bound
--test: only in the rewrite. The plan priced by the guessed LIMIT is planned again under the values at the first execution,
--test: so it reads the primary key in the ORDER BY order and stops at the page (no hash join, no ORDER BY sort).
--+ holdcas on;
drop table if exists t28454_nums, t28454_dbm, t28454_code;
create table t28454_nums (n int not null);
insert into t28454_nums values (1);
insert into t28454_nums select n + 1 from t28454_nums where n <= 1;
insert into t28454_nums select n + 2 from t28454_nums where n <= 2;
insert into t28454_nums select n + 4 from t28454_nums where n <= 4;
insert into t28454_nums select n + 8 from t28454_nums where n <= 8;
insert into t28454_nums select n + 16 from t28454_nums where n <= 16;
insert into t28454_nums select n + 32 from t28454_nums where n <= 32;
insert into t28454_nums select n + 64 from t28454_nums where n <= 64;
insert into t28454_nums select n + 128 from t28454_nums where n <= 128;
insert into t28454_nums select n + 256 from t28454_nums where n <= 256;
insert into t28454_nums select n + 512 from t28454_nums where n <= 512;
insert into t28454_nums select n + 1024 from t28454_nums where n <= 1024;
insert into t28454_nums select n + 2048 from t28454_nums where n <= 2048;
insert into t28454_nums select n + 4096 from t28454_nums where n <= 4096;
insert into t28454_nums select n + 8192 from t28454_nums where n <= 8192;
insert into t28454_nums select n + 16384 from t28454_nums where n <= 16384;
insert into t28454_nums select n + 32768 from t28454_nums where n <= 32768;
create table t28454_dbm (src_nm varchar(180) not null primary key, server_nm varchar(180), dbms_knd varchar(6) not null, ceck_sql varchar(750), mngr_email varchar(150), sttus char(2) not null, upd_dt datetime not null);
insert into t28454_dbm select 'DATASRC_' || lpad(cast(n as varchar), 12, '0'), 'server ' || cast(mod(n, 5000) as varchar), '0' || cast(mod(n, 4) + 1 as varchar), 'select ' || cast(mod(n, 200) as varchar), rpad('mgr' || cast(n as varchar) || '@', 50, 'x'), '0' || cast(mod(n, 2) + 1 as varchar), datetime'2019-01-01 00:00:00' + cast(n as bigint) * 3500000 from t28454_nums where n <= 50000;
create table t28454_code (code_id varchar(18) not null, code varchar(45) not null, code_nm varchar(180), constraint pk_t28454_code primary key (code_id, code));
insert into t28454_code select 'COM' || lpad(cast(1 + (n - 1) / 8 as varchar), 3, '0'), '0' || cast(mod(n - 1, 8) + 1 as varchar), 'code name ' || cast(n as varchar) from t28454_nums where n <= 800;
delete from t28454_code where code_id = 'COM048' and code > '04';
delete from t28454_code where code_id = 'COM046' and code > '02';
update statistics on t28454_dbm, t28454_code with fullscan;
commit;

set trace on;

--test: Case 1. the first page, rn between ? + 1 and ? + ?
prepare s1 from 'select * from (select rownum rn, tb.* from (select a.src_nm, a.server_nm, a.ceck_sql, a.mngr_email, to_char (a.upd_dt, ''YYYY-MM-DD HH24:MI:SS'') upd_dt, b.code_nm knd_nm, c.code_nm sttus_nm from t28454_dbm a, t28454_code b, t28454_code c where a.dbms_knd = b.code and a.sttus = c.code and b.code_id = ''COM048'' and c.code_id = ''COM046'' order by a.src_nm asc) tb) z where rn between ? + 1 and ? + ?';
execute s1 using 0, 0, 10;
show trace;
--test: Case 2. a later page of the same statement keeps the plan of the first execution
execute s1 using 5000, 5000, 10;
deallocate prepare s1;

--test: Case 3. the bounds as plain host variables, rn between ? and ?
prepare s3 from 'select * from (select rownum rn, tb.* from (select a.src_nm, b.code_nm knd_nm, c.code_nm sttus_nm from t28454_dbm a, t28454_code b, t28454_code c where a.dbms_knd = b.code and a.sttus = c.code and b.code_id = ''COM048'' and c.code_id = ''COM046'' order by a.src_nm asc) tb) z where rn between ? and ?';
execute s3 using 21, 30;
show trace;
deallocate prepare s3;

--test: Case 4. rn <= ?
prepare s4 from 'select * from (select rownum rn, tb.* from (select a.src_nm, b.code_nm knd_nm, c.code_nm sttus_nm from t28454_dbm a, t28454_code b, t28454_code c where a.dbms_knd = b.code and a.sttus = c.code and b.code_id = ''COM048'' and c.code_id = ''COM046'' order by a.src_nm desc) tb) z where rn <= ?';
execute s4 using 5;
show trace;
deallocate prepare s4;

set trace off;

--test: Case 5. a bound that fails to evaluate is no compilation error: the execution reports the division by zero
prepare s5 from 'select * from (select rownum rn, tb.* from (select a.src_nm from t28454_dbm a order by a.src_nm) tb) z where rn <= ? / ?';
execute s5 using 10, 0;
deallocate prepare s5;

drop table t28454_nums, t28454_dbm, t28454_code;
commit;
--+ holdcas off;
