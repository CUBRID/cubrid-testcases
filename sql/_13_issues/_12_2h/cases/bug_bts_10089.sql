drop table if exists t1,t2,t3,t4;

create table t1(a varchar(20)) REUSE_OID;
create table t2(a varchar(20)) collate euckr_bin;

--test: fail. we expect it will be successful.
create table t3(a varchar(20)) REUSE_OID collate euckr_bin;

--test: fail. we expect it will be successful.
create table t4(a varchar(20)) collate euckr_bin REUSE_OID;

drop table if exists t1,t2,t3,t4;

create table t1(a char(200)) REUSE_OID;
create table t2(a char(200)) collate euckr_bin;

--test: fail. we expect it will be successful.
create table t3(a char(200)) REUSE_OID collate euckr_bin;

--test: fail. we expect it will be successful.
create table t4(a char(200)) collate euckr_bin REUSE_OID;

drop table if exists t1,t2,t3,t4;

create table t1(a char(200)) REUSE_OID;

create table t2(a char(200)) collate euckr_bin REUSE_OID;

create table t3(a numeric) REUSE_OID collate euckr_bin;

create table t4(a numeric) collate euckr_bin REUSE_OID;

drop table if exists t1,t2,t3,t4;


create table t1(a char(200) primary key ) REUSE_OID;

create table t2(a char(200) primary key ) collate euckr_bin REUSE_OID;

create table t3(a numeric primary key ) REUSE_OID collate euckr_bin;

create table t4(a numeric primary key ) collate euckr_bin REUSE_OID;

drop table if exists t1,t2,t3,t4;

create table t1(a char(200) unique ) REUSE_OID;

create table t2(a char(200),index i_t2_a(a)) collate euckr_bin REUSE_OID;

create table t3(a numeric, index i_t3_a(a)) REUSE_OID collate euckr_bin;

create table t4(a numeric, index i_t4_a(a)) collate euckr_bin REUSE_OID;

drop table if exists t1,t2,t3,t4;








