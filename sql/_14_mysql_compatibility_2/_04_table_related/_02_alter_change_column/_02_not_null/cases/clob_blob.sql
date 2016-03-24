--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  
-- constraints : testing add/drop : NOT NULL, 
-- name : same of different
-- type : CLOB, BLOB , not type change 
 
-- adding 'not null'  : permissive mode
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes'; 


-- no NULL values
create table t1 (i int unique, b1 blob, c1 clob);
insert into t1 values (1,bit_to_blob(X'1aaabbbccc'),char_to_clob('1aaabbbccc'));
insert into t1 values (2,bit_to_blob(X'2aa3bbbccc'),char_to_clob('2aa3bbbccc'));

--select i, blob_to_bit(b1), clob_to_char(c1) from t1 order by 1;

desc t1;


alter table t1 change b1 b1 blob not null;

alter table t1 change c1 c1 clob not null;

-- select i, blob_to_bit(b1), clob_to_char(c1) from t1 order by 1;

desc t1;

drop table t1;



-- with NULL values
create table t1 (i int unique, b1 blob, c1 clob);
insert into t1 values (1,bit_to_blob(X'1aaabbbccc'),char_to_clob('1aaabbbccc'));
insert into t1 values (2,bit_to_blob(X'2aa3bbbccc'),char_to_clob('2aa3bbbccc'));
insert into t1 values (2,NULL, NULL);

--select i, blob_to_bit(b1), clob_to_char(c1) from t1 order by 1;

desc t1;


alter table t1 change b1 b1 blob not null;

alter table t1 change c1 c1 clob not null;

--select i, blob_to_bit(b1), clob_to_char(c1) from t1 order by 1;

desc t1;

drop table t1;





-- adding 'not null'  : strict mode
set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes'; 


-- no NULL values
create table t1 (i int unique, b1 blob, c1 clob);
insert into t1 values (1,bit_to_blob(X'1aaabbbccc'),char_to_clob('1aaabbbccc'));
insert into t1 values (2,bit_to_blob(X'2aa3bbbccc'),char_to_clob('2aa3bbbccc'));

--select i, blob_to_bit(b1), clob_to_char(c1) from t1 order by 1;

desc t1;


alter table t1 change b1 b1 blob not null;

alter table t1 change c1 c1 clob not null;

--select i, blob_to_bit(b1), clob_to_char(c1) from t1 order by 1;

desc t1;

drop table t1;



-- with NULL values
create table t1 (i int unique, b1 blob, c1 clob);
insert into t1 values (1,bit_to_blob(X'1aaabbbccc'),char_to_clob('1aaabbbccc'));
insert into t1 values (2,bit_to_blob(X'2aa3bbbccc'),char_to_clob('2aa3bbbccc'));
insert into t1 values (2,NULL, NULL);

--select i, blob_to_bit(b1), clob_to_char(c1) from t1 order by 1;

desc t1;


alter table t1 change b1 b1 blob not null;

alter table t1 change c1 c1 clob not null;

--select i, blob_to_bit(b1), clob_to_char(c1) from t1 order by 1;

desc t1;

drop table t1;



set system parameters 'alter_table_change_type_strict=no';

commit;
--+ holdcas off;

set system parameters 'error_log_level=syntax';
set system parameters 'error_log_warning=no';
