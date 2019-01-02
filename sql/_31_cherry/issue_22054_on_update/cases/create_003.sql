drop if exists t;
create table t(i short default 0 on update current_timestamp);

drop if exists t;
create table t(i smallint default 0 on update current_timestamp);

drop if exists t;
create table t(i int default 0 on update current_timestamp);

drop if exists t;
create table t(i integer default 0 on update current_timestamp);

drop if exists t;
create table t(i bigint default 0 on update current_timestamp);

drop if exists t;
create table t(i numeric(4,3) on update current_timestamp);

drop if exists t;
create table t(i decimal on update current_timestamp);

drop if exists t;
create table t(i float on update current_timestamp());

drop if exists t;
create table t(i double on update current_timestamp());


drop if exists t;
create table t(i double on update cast(current_timestamp as int));

drop if exists set_tbl;
CREATE TABLE set_tbl (col_1 SET (CHAR(1)) on update current_timestamp);

drop if exists multiset_tbl;
CREATE TABLE multiset_tbl (col_1 MULTISET (CHAR(1)) on update current_timestamp);

drop if exists list_tbl;
CREATE TABLE list_tbl (col_1 LIST (CHAR(1)) on update current_timestamp);

drop if exists doc_t;
CREATE TABLE doc_t (doc_id VARCHAR(64) PRIMARY KEY, content CLOB on update current_timestamp);

drop if exists tbl;
CREATE TABLE tbl(color ENUM ('red', 'green', 'blue') on update current_timestamp);

drop if exists bit_tbl;
CREATE TABLE bit_tbl(a1 BIT on update current_timestamp, a2 BIT(1), a3 BIT(8), a4 BIT VARYING);
