-- CBRD-26659 Ticket04: compact delete regression, derived from P05/P06.
-- Every snapshot checks all affected rows and untouched survivors in ID order.
-- The independent row model plus literal MD5 answers detects row/column swaps.
-- VARBIT MD5 hashes lowercase hexadecimal ASCII, computed outside CUBRID.
-- Payloads have distinct head/middle/tail patterns; tags are 300 bytes.
-- Public JDBC/autocommit proves logical values. Separate shell SA observations
-- qualify physical transitions only for that fixture/configuration.
-- No always-new-chain, chain reuse, commit notification, vacuum, ownership or
-- page reclamation expectation is encoded here (CBRD-27230 remains a gap).
-- No session/parameter changes; final catalog query proves fixture cleanup.


drop table if exists t_oos04_delete_source_model;

drop table if exists t_oos04_delete_source;

drop table if exists t_oos04_delete_model;

drop table if exists t_oos04_delete;

create table t_oos04_delete (id int primary key, payload bit varying, tag bit varying, note int);

create table t_oos04_delete_model (id int primary key, payload bit varying, tag bit varying, note int);

create table t_oos04_delete_source (id int primary key, payload bit varying, tag bit varying, note int);

create table t_oos04_delete_source_model (id int primary key, payload bit varying, tag bit varying, note int);

insert into t_oos04_delete values
  (1,cast(concat(repeat('aa',1000),repeat('bb',1000),repeat('cc',1000)) as bit varying),cast(repeat('11',300) as bit varying),10),
  (2,cast(concat(repeat('d1',1401),repeat('e2',1403),repeat('f3',1403)) as bit varying),cast(repeat('22',300) as bit varying),20),
  (3,cast(concat(repeat('12',7001),repeat('34',6501),repeat('56',6501)) as bit varying),cast(repeat('33',300) as bit varying),30),
  (4,cast(concat(repeat('78',11001),repeat('9a',11000),repeat('bc',11000)) as bit varying),cast(repeat('44',300) as bit varying),40);

insert into t_oos04_delete_model values
  (1,cast(concat(repeat('aa',1000),repeat('bb',1000),repeat('cc',1000)) as bit varying),cast(repeat('11',300) as bit varying),10),
  (2,cast(concat(repeat('d1',1401),repeat('e2',1403),repeat('f3',1403)) as bit varying),cast(repeat('22',300) as bit varying),20),
  (3,cast(concat(repeat('12',7001),repeat('34',6501),repeat('56',6501)) as bit varying),cast(repeat('33',300) as bit varying),30),
  (4,cast(concat(repeat('78',11001),repeat('9a',11000),repeat('bc',11000)) as bit varying),cast(repeat('44',300) as bit varying),40);

insert into t_oos04_delete_source values
  (11,cast(concat(repeat('a1',1700),repeat('b2',1700),repeat('c3',1603)) as bit varying),cast(repeat('a7',300) as bit varying),110),
  (12,cast(concat(repeat('d4',3000),repeat('e5',3000),repeat('f6',3001)) as bit varying),cast(repeat('b8',300) as bit varying),120);

insert into t_oos04_delete_source_model values
  (11,cast(concat(repeat('a1',1700),repeat('b2',1700),repeat('c3',1603)) as bit varying),cast(repeat('a7',300) as bit varying),110),
  (12,cast(concat(repeat('d4',3000),repeat('e5',3000),repeat('f6',3001)) as bit varying),cast(repeat('b8',300) as bit varying),120);

evaluate '[D01] exact delete fixture';

select s.id, s.note, coalesce(octet_length(s.payload),-1) as payload_octets,
       coalesce(md5(s.payload),'NULL') as payload_md5, md5(s.tag) as tag_md5,
       case when (s.payload is null and m.payload is null) or s.payload=m.payload then 1 else 0 end as payload_ok,
       case when s.tag=m.tag then 1 else 0 end as tag_ok,
       case when s.note=m.note then 1 else 0 end as note_ok
  from t_oos04_delete s, t_oos04_delete_model m where s.id=m.id order by s.id;

select count(*) as row_count, count(distinct id) as distinct_ids from t_oos04_delete;

delete from t_oos04_delete where id=2;

delete from t_oos04_delete_model where id=2;

evaluate '[D02] primary-key DELETE preserves every survivor';

select s.id, s.note, coalesce(octet_length(s.payload),-1) as payload_octets,
       coalesce(md5(s.payload),'NULL') as payload_md5, md5(s.tag) as tag_md5,
       case when (s.payload is null and m.payload is null) or s.payload=m.payload then 1 else 0 end as payload_ok,
       case when s.tag=m.tag then 1 else 0 end as tag_ok,
       case when s.note=m.note then 1 else 0 end as note_ok
  from t_oos04_delete s, t_oos04_delete_model m where s.id=m.id order by s.id;

select count(*) as row_count, count(distinct id) as distinct_ids from t_oos04_delete;

delete from t_oos04_delete where payload=cast(concat(repeat('12',7001),repeat('34',6501),repeat('56',6501)) as bit varying);

delete from t_oos04_delete_model where id=3;

evaluate '[D03] OOS-value-predicate DELETE preserves every survivor';

select s.id, s.note, coalesce(octet_length(s.payload),-1) as payload_octets,
       coalesce(md5(s.payload),'NULL') as payload_md5, md5(s.tag) as tag_md5,
       case when (s.payload is null and m.payload is null) or s.payload=m.payload then 1 else 0 end as payload_ok,
       case when s.tag=m.tag then 1 else 0 end as tag_ok,
       case when s.note=m.note then 1 else 0 end as note_ok
  from t_oos04_delete s, t_oos04_delete_model m where s.id=m.id order by s.id;

select count(*) as row_count, count(distinct id) as distinct_ids from t_oos04_delete;

insert into t_oos04_delete values
  (2,cast(concat(repeat('d1',1401),repeat('e2',1403),repeat('f3',1403)) as bit varying),cast(repeat('22',300) as bit varying),20),
  (3,cast(concat(repeat('12',7001),repeat('34',6501),repeat('56',6501)) as bit varying),cast(repeat('33',300) as bit varying),30);

insert into t_oos04_delete_model values
  (2,cast(concat(repeat('d1',1401),repeat('e2',1403),repeat('f3',1403)) as bit varying),cast(repeat('22',300) as bit varying),20),
  (3,cast(concat(repeat('12',7001),repeat('34',6501),repeat('56',6501)) as bit varying),cast(repeat('33',300) as bit varying),30);

evaluate '[D04] deleted IDs reinsert without mixing surviving values';

select s.id, s.note, coalesce(octet_length(s.payload),-1) as payload_octets,
       coalesce(md5(s.payload),'NULL') as payload_md5, md5(s.tag) as tag_md5,
       case when (s.payload is null and m.payload is null) or s.payload=m.payload then 1 else 0 end as payload_ok,
       case when s.tag=m.tag then 1 else 0 end as tag_ok,
       case when s.note=m.note then 1 else 0 end as note_ok
  from t_oos04_delete s, t_oos04_delete_model m where s.id=m.id order by s.id;

select count(*) as row_count, count(distinct id) as distinct_ids from t_oos04_delete;

delete from t_oos04_delete;

delete from t_oos04_delete_model;

evaluate '[D05] DELETE all produces an exact empty row set';

select s.id, s.note, coalesce(octet_length(s.payload),-1) as payload_octets,
       coalesce(md5(s.payload),'NULL') as payload_md5, md5(s.tag) as tag_md5,
       case when (s.payload is null and m.payload is null) or s.payload=m.payload then 1 else 0 end as payload_ok,
       case when s.tag=m.tag then 1 else 0 end as tag_ok,
       case when s.note=m.note then 1 else 0 end as note_ok
  from t_oos04_delete s, t_oos04_delete_model m where s.id=m.id order by s.id;

select count(*) as row_count, count(distinct id) as distinct_ids from t_oos04_delete;

insert into t_oos04_delete values
  (1,cast(concat(repeat('aa',1000),repeat('bb',1000),repeat('cc',1000)) as bit varying),cast(repeat('11',300) as bit varying),10),
  (2,cast(concat(repeat('d1',1401),repeat('e2',1403),repeat('f3',1403)) as bit varying),cast(repeat('22',300) as bit varying),20),
  (3,cast(concat(repeat('12',7001),repeat('34',6501),repeat('56',6501)) as bit varying),cast(repeat('33',300) as bit varying),30),
  (4,cast(concat(repeat('78',11001),repeat('9a',11000),repeat('bc',11000)) as bit varying),cast(repeat('44',300) as bit varying),40);

insert into t_oos04_delete_model values
  (1,cast(concat(repeat('aa',1000),repeat('bb',1000),repeat('cc',1000)) as bit varying),cast(repeat('11',300) as bit varying),10),
  (2,cast(concat(repeat('d1',1401),repeat('e2',1403),repeat('f3',1403)) as bit varying),cast(repeat('22',300) as bit varying),20),
  (3,cast(concat(repeat('12',7001),repeat('34',6501),repeat('56',6501)) as bit varying),cast(repeat('33',300) as bit varying),30),
  (4,cast(concat(repeat('78',11001),repeat('9a',11000),repeat('bc',11000)) as bit varying),cast(repeat('44',300) as bit varying),40);

evaluate '[D06] DELETE-all reinsert restores the complete model';

select s.id, s.note, coalesce(octet_length(s.payload),-1) as payload_octets,
       coalesce(md5(s.payload),'NULL') as payload_md5, md5(s.tag) as tag_md5,
       case when (s.payload is null and m.payload is null) or s.payload=m.payload then 1 else 0 end as payload_ok,
       case when s.tag=m.tag then 1 else 0 end as tag_ok,
       case when s.note=m.note then 1 else 0 end as note_ok
  from t_oos04_delete s, t_oos04_delete_model m where s.id=m.id order by s.id;

select count(*) as row_count, count(distinct id) as distinct_ids from t_oos04_delete;

truncate t_oos04_delete;

truncate t_oos04_delete_model;

evaluate '[D07] TRUNCATE produces an exact empty row set';

select s.id, s.note, coalesce(octet_length(s.payload),-1) as payload_octets,
       coalesce(md5(s.payload),'NULL') as payload_md5, md5(s.tag) as tag_md5,
       case when (s.payload is null and m.payload is null) or s.payload=m.payload then 1 else 0 end as payload_ok,
       case when s.tag=m.tag then 1 else 0 end as tag_ok,
       case when s.note=m.note then 1 else 0 end as note_ok
  from t_oos04_delete s, t_oos04_delete_model m where s.id=m.id order by s.id;

select count(*) as row_count, count(distinct id) as distinct_ids from t_oos04_delete;

insert into t_oos04_delete values
  (1,cast(concat(repeat('aa',1000),repeat('bb',1000),repeat('cc',1000)) as bit varying),cast(repeat('11',300) as bit varying),10),
  (2,cast(concat(repeat('d1',1401),repeat('e2',1403),repeat('f3',1403)) as bit varying),cast(repeat('22',300) as bit varying),20),
  (3,cast(concat(repeat('12',7001),repeat('34',6501),repeat('56',6501)) as bit varying),cast(repeat('33',300) as bit varying),30),
  (4,cast(concat(repeat('78',11001),repeat('9a',11000),repeat('bc',11000)) as bit varying),cast(repeat('44',300) as bit varying),40);

insert into t_oos04_delete_model values
  (1,cast(concat(repeat('aa',1000),repeat('bb',1000),repeat('cc',1000)) as bit varying),cast(repeat('11',300) as bit varying),10),
  (2,cast(concat(repeat('d1',1401),repeat('e2',1403),repeat('f3',1403)) as bit varying),cast(repeat('22',300) as bit varying),20),
  (3,cast(concat(repeat('12',7001),repeat('34',6501),repeat('56',6501)) as bit varying),cast(repeat('33',300) as bit varying),30),
  (4,cast(concat(repeat('78',11001),repeat('9a',11000),repeat('bc',11000)) as bit varying),cast(repeat('44',300) as bit varying),40);

evaluate '[D08] TRUNCATE reinsert preserves distinct exact values';

select s.id, s.note, coalesce(octet_length(s.payload),-1) as payload_octets,
       coalesce(md5(s.payload),'NULL') as payload_md5, md5(s.tag) as tag_md5,
       case when (s.payload is null and m.payload is null) or s.payload=m.payload then 1 else 0 end as payload_ok,
       case when s.tag=m.tag then 1 else 0 end as tag_ok,
       case when s.note=m.note then 1 else 0 end as note_ok
  from t_oos04_delete s, t_oos04_delete_model m where s.id=m.id order by s.id;

select count(*) as row_count, count(distinct id) as distinct_ids from t_oos04_delete;

evaluate '[cleanup] every fixture table is removed';

drop table t_oos04_delete_source_model;

drop table t_oos04_delete_source;

drop table t_oos04_delete_model;

drop table t_oos04_delete;

select count(*) as fixture_tables from db_class where class_name in ('t_oos04_delete_source_model','t_oos04_delete_source','t_oos04_delete_model','t_oos04_delete');
