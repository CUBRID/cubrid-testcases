-- CBRD-26659 Ticket05: independent immediate transaction/error oracle.
-- Strengthens recovered P07/P08 and the current transaction/bigone units.
-- Noncompressed VARBIT uses distinguishable head/middle/tail hex patterns.
-- Answer sizes, full values and lowercase-hex MD5 were derived outside CUBRID
-- before execution at engine fb567a629cdb390fff920542173fa36f454c74a0.
-- SQL through JDBC proves logical outcomes only. Paired CS physical fixtures
-- are a separate invocation, never observation of this public SQL execution.
-- No vacuum completion, reclaim, chain ownership/reuse, recovery or HA claim.
-- Current error: ER_HEAP_OOS_OVERPASS_MAXOBJ_SIZE=-1397 (error_code.h).
-- A user-class record never becomes REC_BIGONE: a row whose inline size, after
-- every eligible variable value moved to OOS, exceeds the maximum record size
-- (16236 bytes on a 16 KB page) is rejected before any chain is written, with or
-- without an OOS value. Earlier engines stored a fixed-only row as REC_BIGONE.
-- BIT(140000) retains 17500 fixed bytes (a 17548-byte row), so every INSERT is
-- rejected. BIT(129408) retains 16176 fixed bytes: a row with a NULL payload is
-- 16224 bytes and fits, but a payload that moves to OOS adds a 24-byte stub and
-- makes it 16248 bytes, which the same check rejects. BIT(100000) retains 12500
-- bytes and is a legal slotted-record neighbor despite exceeding the OOS inline
-- target. The MD5 of a BIT value is taken over its hex string; the BIT(129408)
-- values were derived outside CUBRID and then matched at 9b49b3f438.
-- Historic -1375/-1382/-1384 and CBRD-27403 answers are not the current oracle.

drop table if exists t_oos05_bigone;

drop table if exists t_oos05_edge;

drop table if exists t_oos05_residual;

create table t_oos05_bigone (id int primary key, fixed_payload bit(140000), payload bit varying, marker int);

create table t_oos05_edge (id int primary key, fixed_payload bit(129408), payload bit varying, marker int);

create table t_oos05_residual (id int primary key, fixed_payload bit(100000), payload bit varying);

evaluate '[TEST 1] ordinary non-OOS bigone INSERT with NULL variable payload rejects without partial rows';

insert into t_oos05_bigone values (1,B'1',null,10);

select id,octet_length(fixed_payload) as fixed_octets,md5(fixed_payload) as fixed_md5,case when payload is null then 1 else 0 end as payload_null,marker,case when id=1 and fixed_payload=cast(B'1' as bit(140000)) and payload is null and marker=10 then 1 else 0 end as value_ok from t_oos05_bigone order by id;

select count(*) as row_count from t_oos05_bigone;

evaluate '[TEST 2] OOS plus bigone INSERT rejects without partial rows';

insert into t_oos05_bigone values (2,B'0',cast(concat(repeat('ab', 500), repeat('cd', 500)) as bit varying),20);

select id,octet_length(fixed_payload) as fixed_octets,md5(fixed_payload) as fixed_md5,case when payload is null then 1 else 0 end as payload_null,marker,case when id=1 and fixed_payload=cast(B'1' as bit(140000)) and payload is null and marker=10 then 1 else 0 end as value_ok from t_oos05_bigone order by id;

select count(*) as row_count from t_oos05_bigone;

evaluate '[TEST 3] near-limit non-OOS record with NULL variable payload fits in one slotted page';

insert into t_oos05_edge values (1,B'1',null,10);

select id,octet_length(fixed_payload) as fixed_octets,md5(fixed_payload) as fixed_md5,case when payload is null then 1 else 0 end as payload_null,marker,case when id=1 and fixed_payload=cast(B'1' as bit(129408)) and payload is null and marker=10 then 1 else 0 end as value_ok from t_oos05_edge order by id;

select count(*) as row_count from t_oos05_edge;

evaluate '[TEST 4] OOS plus bigone UPDATE rejects both fixed and variable changes';

update t_oos05_edge set fixed_payload=B'0',payload=cast(concat(repeat('ab', 500), repeat('cd', 500)) as bit varying),marker=99 where id=1;

select id,octet_length(fixed_payload) as fixed_octets,md5(fixed_payload) as fixed_md5,case when payload is null then 1 else 0 end as payload_null,marker,case when id=1 and fixed_payload=cast(B'1' as bit(129408)) and payload is null and marker=10 then 1 else 0 end as value_ok from t_oos05_edge order by id;

select count(*) as row_count from t_oos05_edge;

evaluate '[TEST 5] legal follow-up INSERT and UPDATE after rejection';

insert into t_oos05_edge values (2,B'0',null,20);

update t_oos05_edge set marker=11 where id=1;

select id,octet_length(fixed_payload) as fixed_octets,md5(fixed_payload) as fixed_md5,case when payload is null then 1 else 0 end as payload_null,marker,case when id=1 and fixed_payload=cast(B'1' as bit(129408)) and payload is null and marker=11 then 1 when id=2 and fixed_payload=cast(B'0' as bit(129408)) and payload is null and marker=20 then 1 else 0 end as value_ok from t_oos05_edge order by id;

select count(*) as row_count from t_oos05_edge;

evaluate '[TEST 6] legal residual between inline target and slotted-record limit';

insert into t_oos05_residual values (1,B'1',cast(concat(repeat('ab', 500), repeat('cd', 500)) as bit varying));

select id,octet_length(fixed_payload) as fixed_octets,md5(fixed_payload) as fixed_md5,octet_length(payload) as payload_octets,disk_size(payload) as payload_disk,md5(payload) as payload_md5,case when fixed_payload=cast(B'1' as bit(100000)) and payload=cast(concat(repeat('ab', 500), repeat('cd', 500)) as bit varying) then 1 else 0 end as value_ok from t_oos05_residual order by id;

update t_oos05_residual set payload=cast(concat(repeat('ef', 500), repeat('01', 500)) as bit varying) where id=1;

select id,octet_length(fixed_payload) as fixed_octets,md5(fixed_payload) as fixed_md5,octet_length(payload) as payload_octets,disk_size(payload) as payload_disk,md5(payload) as payload_md5,case when fixed_payload=cast(B'1' as bit(100000)) and payload=cast(concat(repeat('ef', 500), repeat('01', 500)) as bit varying) then 1 else 0 end as value_ok from t_oos05_residual order by id;

evaluate '[TEST 7] cleanup removes all neighboring schemas';

drop table t_oos05_bigone;

drop table t_oos05_edge;

drop table t_oos05_residual;

select count(*) as fixture_tables from db_class where class_name in ('t_oos05_bigone','t_oos05_edge','t_oos05_residual');
