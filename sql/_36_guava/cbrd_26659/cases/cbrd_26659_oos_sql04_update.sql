-- CBRD-26659 Ticket04: compact update regression, derived from P05/P06.
-- Every snapshot checks all affected rows and untouched survivors in ID order.
-- The independent row model plus literal MD5 answers detects row/column swaps.
-- VARBIT MD5 hashes lowercase hexadecimal ASCII, computed outside CUBRID.
-- Payloads have distinct head/middle/tail patterns; tags are 300 bytes.
-- Public JDBC/autocommit proves logical values. Separate shell SA observations
-- qualify physical transitions only for that fixture/configuration.
-- No always-new-chain, chain reuse, commit notification, vacuum, ownership or
-- page reclamation expectation is encoded here (CBRD-27230 remains a gap).
-- No session/parameter changes; final catalog query proves fixture cleanup.


drop table if exists t_oos04_update_source_model;

drop table if exists t_oos04_update_source;

drop table if exists t_oos04_update_model;

drop table if exists t_oos04_update;

create table t_oos04_update (id int primary key, payload bit varying, tag bit varying, note int);

create table t_oos04_update_model (id int primary key, payload bit varying, tag bit varying, note int);

create table t_oos04_update_source (id int primary key, payload bit varying, tag bit varying, note int);

create table t_oos04_update_source_model (id int primary key, payload bit varying, tag bit varying, note int);

insert into t_oos04_update values
  (1,cast(concat(repeat('aa',1000),repeat('bb',1000),repeat('cc',1000)) as bit varying),cast(repeat('11',300) as bit varying),10),
  (2,cast(concat(repeat('d1',1401),repeat('e2',1403),repeat('f3',1403)) as bit varying),cast(repeat('22',300) as bit varying),20),
  (3,cast(concat(repeat('12',7001),repeat('34',6501),repeat('56',6501)) as bit varying),cast(repeat('33',300) as bit varying),30),
  (4,cast(concat(repeat('78',11001),repeat('9a',11000),repeat('bc',11000)) as bit varying),cast(repeat('44',300) as bit varying),40);

insert into t_oos04_update_model values
  (1,cast(concat(repeat('aa',1000),repeat('bb',1000),repeat('cc',1000)) as bit varying),cast(repeat('11',300) as bit varying),10),
  (2,cast(concat(repeat('d1',1401),repeat('e2',1403),repeat('f3',1403)) as bit varying),cast(repeat('22',300) as bit varying),20),
  (3,cast(concat(repeat('12',7001),repeat('34',6501),repeat('56',6501)) as bit varying),cast(repeat('33',300) as bit varying),30),
  (4,cast(concat(repeat('78',11001),repeat('9a',11000),repeat('bc',11000)) as bit varying),cast(repeat('44',300) as bit varying),40);

insert into t_oos04_update_source values
  (11,cast(concat(repeat('a1',1700),repeat('b2',1700),repeat('c3',1603)) as bit varying),cast(repeat('a7',300) as bit varying),110),
  (12,cast(concat(repeat('d4',3000),repeat('e5',3000),repeat('f6',3001)) as bit varying),cast(repeat('b8',300) as bit varying),120);

insert into t_oos04_update_source_model values
  (11,cast(concat(repeat('a1',1700),repeat('b2',1700),repeat('c3',1603)) as bit varying),cast(repeat('a7',300) as bit varying),110),
  (12,cast(concat(repeat('d4',3000),repeat('e5',3000),repeat('f6',3001)) as bit varying),cast(repeat('b8',300) as bit varying),120);

evaluate '[U01] exact inline single multiple and untouched survivor fixture';

select s.id, s.note, coalesce(octet_length(s.payload),-1) as payload_octets,
       coalesce(md5(s.payload),'NULL') as payload_md5, md5(s.tag) as tag_md5,
       case when (s.payload is null and m.payload is null) or s.payload=m.payload then 1 else 0 end as payload_ok,
       case when s.tag=m.tag then 1 else 0 end as tag_ok,
       case when s.note=m.note then 1 else 0 end as note_ok
  from t_oos04_update s, t_oos04_update_model m where s.id=m.id order by s.id;

select count(*) as row_count, count(distinct id) as distinct_ids from t_oos04_update;

update t_oos04_update set payload=cast(concat(repeat('12',7001),repeat('34',6501),repeat('56',6501)) as bit varying) where payload=cast(concat(repeat('d1',1401),repeat('e2',1403),repeat('f3',1403)) as bit varying);

update t_oos04_update_model set payload=cast(concat(repeat('12',7001),repeat('34',6501),repeat('56',6501)) as bit varying) where id=2;

evaluate '[U02] single grows to two chunks by payload predicate';

select s.id, s.note, coalesce(octet_length(s.payload),-1) as payload_octets,
       coalesce(md5(s.payload),'NULL') as payload_md5, md5(s.tag) as tag_md5,
       case when (s.payload is null and m.payload is null) or s.payload=m.payload then 1 else 0 end as payload_ok,
       case when s.tag=m.tag then 1 else 0 end as tag_ok,
       case when s.note=m.note then 1 else 0 end as note_ok
  from t_oos04_update s, t_oos04_update_model m where s.id=m.id order by s.id;

select count(*) as row_count, count(distinct id) as distinct_ids from t_oos04_update;

update t_oos04_update set payload=cast(concat(repeat('ab',1701),repeat('cd',1701),repeat('ef',1701)) as bit varying) where id=2;

update t_oos04_update_model set payload=cast(concat(repeat('ab',1701),repeat('cd',1701),repeat('ef',1701)) as bit varying) where id=2;

evaluate '[U03] multiple shrinks to single';

select s.id, s.note, coalesce(octet_length(s.payload),-1) as payload_octets,
       coalesce(md5(s.payload),'NULL') as payload_md5, md5(s.tag) as tag_md5,
       case when (s.payload is null and m.payload is null) or s.payload=m.payload then 1 else 0 end as payload_ok,
       case when s.tag=m.tag then 1 else 0 end as tag_ok,
       case when s.note=m.note then 1 else 0 end as note_ok
  from t_oos04_update s, t_oos04_update_model m where s.id=m.id order by s.id;

select count(*) as row_count, count(distinct id) as distinct_ids from t_oos04_update;

update t_oos04_update set payload=cast(concat(repeat('aa',1000),repeat('bb',1000),repeat('cc',1000)) as bit varying) where id=2;

update t_oos04_update_model set payload=cast(concat(repeat('aa',1000),repeat('bb',1000),repeat('cc',1000)) as bit varying) where id=2;

evaluate '[U04] large shrinks to inline';

select s.id, s.note, coalesce(octet_length(s.payload),-1) as payload_octets,
       coalesce(md5(s.payload),'NULL') as payload_md5, md5(s.tag) as tag_md5,
       case when (s.payload is null and m.payload is null) or s.payload=m.payload then 1 else 0 end as payload_ok,
       case when s.tag=m.tag then 1 else 0 end as tag_ok,
       case when s.note=m.note then 1 else 0 end as note_ok
  from t_oos04_update s, t_oos04_update_model m where s.id=m.id order by s.id;

select count(*) as row_count, count(distinct id) as distinct_ids from t_oos04_update;

update t_oos04_update set payload=cast(concat(repeat('d1',1401),repeat('e2',1403),repeat('f3',1403)) as bit varying) where id=2;

update t_oos04_update_model set payload=cast(concat(repeat('d1',1401),repeat('e2',1403),repeat('f3',1403)) as bit varying) where id=2;

evaluate '[U05] inline grows to large';

select s.id, s.note, coalesce(octet_length(s.payload),-1) as payload_octets,
       coalesce(md5(s.payload),'NULL') as payload_md5, md5(s.tag) as tag_md5,
       case when (s.payload is null and m.payload is null) or s.payload=m.payload then 1 else 0 end as payload_ok,
       case when s.tag=m.tag then 1 else 0 end as tag_ok,
       case when s.note=m.note then 1 else 0 end as note_ok
  from t_oos04_update s, t_oos04_update_model m where s.id=m.id order by s.id;

select count(*) as row_count, count(distinct id) as distinct_ids from t_oos04_update;

update t_oos04_update set note=31 where id=3;

update t_oos04_update_model set note=31 where id=3;

evaluate '[U06] inline-only assignment leaves OOS payload unassigned';

select s.id, s.note, coalesce(octet_length(s.payload),-1) as payload_octets,
       coalesce(md5(s.payload),'NULL') as payload_md5, md5(s.tag) as tag_md5,
       case when (s.payload is null and m.payload is null) or s.payload=m.payload then 1 else 0 end as payload_ok,
       case when s.tag=m.tag then 1 else 0 end as tag_ok,
       case when s.note=m.note then 1 else 0 end as note_ok
  from t_oos04_update s, t_oos04_update_model m where s.id=m.id order by s.id;

select count(*) as row_count, count(distinct id) as distinct_ids from t_oos04_update;

update t_oos04_update set payload=payload where id=3;

evaluate '[U07] equal-value OOS assignment is a distinct operation';

select s.id, s.note, coalesce(octet_length(s.payload),-1) as payload_octets,
       coalesce(md5(s.payload),'NULL') as payload_md5, md5(s.tag) as tag_md5,
       case when (s.payload is null and m.payload is null) or s.payload=m.payload then 1 else 0 end as payload_ok,
       case when s.tag=m.tag then 1 else 0 end as tag_ok,
       case when s.note=m.note then 1 else 0 end as note_ok
  from t_oos04_update s, t_oos04_update_model m where s.id=m.id order by s.id;

select count(*) as row_count, count(distinct id) as distinct_ids from t_oos04_update;

update t_oos04_update set tag=cast(repeat('5a',300) as bit varying) where id=2;

update t_oos04_update_model set tag=cast(repeat('5a',300) as bit varying) where id=2;

evaluate '[U08] assigned tag leaves OOS payload genuinely unassigned';

select s.id, s.note, coalesce(octet_length(s.payload),-1) as payload_octets,
       coalesce(md5(s.payload),'NULL') as payload_md5, md5(s.tag) as tag_md5,
       case when (s.payload is null and m.payload is null) or s.payload=m.payload then 1 else 0 end as payload_ok,
       case when s.tag=m.tag then 1 else 0 end as tag_ok,
       case when s.note=m.note then 1 else 0 end as note_ok
  from t_oos04_update s, t_oos04_update_model m where s.id=m.id order by s.id;

select count(*) as row_count, count(distinct id) as distinct_ids from t_oos04_update;

update t_oos04_update set payload=NULL where id=2;

update t_oos04_update_model set payload=NULL where id=2;

evaluate '[U09] large becomes NULL';

select s.id, s.note, coalesce(octet_length(s.payload),-1) as payload_octets,
       coalesce(md5(s.payload),'NULL') as payload_md5, md5(s.tag) as tag_md5,
       case when (s.payload is null and m.payload is null) or s.payload=m.payload then 1 else 0 end as payload_ok,
       case when s.tag=m.tag then 1 else 0 end as tag_ok,
       case when s.note=m.note then 1 else 0 end as note_ok
  from t_oos04_update s, t_oos04_update_model m where s.id=m.id order by s.id;

select count(*) as row_count, count(distinct id) as distinct_ids from t_oos04_update;

update t_oos04_update set payload=X'' where id=2;

update t_oos04_update_model set payload=X'' where id=2;

evaluate '[U10] NULL becomes empty VARBIT';

select s.id, s.note, coalesce(octet_length(s.payload),-1) as payload_octets,
       coalesce(md5(s.payload),'NULL') as payload_md5, md5(s.tag) as tag_md5,
       case when (s.payload is null and m.payload is null) or s.payload=m.payload then 1 else 0 end as payload_ok,
       case when s.tag=m.tag then 1 else 0 end as tag_ok,
       case when s.note=m.note then 1 else 0 end as note_ok
  from t_oos04_update s, t_oos04_update_model m where s.id=m.id order by s.id;

select count(*) as row_count, count(distinct id) as distinct_ids from t_oos04_update;

update t_oos04_update set payload=cast(concat(repeat('12',7001),repeat('34',6501),repeat('56',6501)) as bit varying) where id=2;

update t_oos04_update_model set payload=cast(concat(repeat('12',7001),repeat('34',6501),repeat('56',6501)) as bit varying) where id=2;

evaluate '[U11] empty grows to multiple';

select s.id, s.note, coalesce(octet_length(s.payload),-1) as payload_octets,
       coalesce(md5(s.payload),'NULL') as payload_md5, md5(s.tag) as tag_md5,
       case when (s.payload is null and m.payload is null) or s.payload=m.payload then 1 else 0 end as payload_ok,
       case when s.tag=m.tag then 1 else 0 end as tag_ok,
       case when s.note=m.note then 1 else 0 end as note_ok
  from t_oos04_update s, t_oos04_update_model m where s.id=m.id order by s.id;

select count(*) as row_count, count(distinct id) as distinct_ids from t_oos04_update;

update t_oos04_update set payload=cast(concat(repeat('91',2000),repeat('82',1500),repeat('73',1501)) as bit varying) where id=2;

update t_oos04_update_model set payload=cast(concat(repeat('91',2000),repeat('82',1500),repeat('73',1501)) as bit varying) where id=2;

evaluate '[U12] repeated write 1 remains exact';

select s.id, s.note, coalesce(octet_length(s.payload),-1) as payload_octets,
       coalesce(md5(s.payload),'NULL') as payload_md5, md5(s.tag) as tag_md5,
       case when (s.payload is null and m.payload is null) or s.payload=m.payload then 1 else 0 end as payload_ok,
       case when s.tag=m.tag then 1 else 0 end as tag_ok,
       case when s.note=m.note then 1 else 0 end as note_ok
  from t_oos04_update s, t_oos04_update_model m where s.id=m.id order by s.id;

select count(*) as row_count, count(distinct id) as distinct_ids from t_oos04_update;

update t_oos04_update set payload=cast(concat(repeat('64',2000),repeat('55',2000),repeat('46',2002)) as bit varying) where id=2;

update t_oos04_update_model set payload=cast(concat(repeat('64',2000),repeat('55',2000),repeat('46',2002)) as bit varying) where id=2;

evaluate '[U13] repeated write 2 remains exact';

select s.id, s.note, coalesce(octet_length(s.payload),-1) as payload_octets,
       coalesce(md5(s.payload),'NULL') as payload_md5, md5(s.tag) as tag_md5,
       case when (s.payload is null and m.payload is null) or s.payload=m.payload then 1 else 0 end as payload_ok,
       case when s.tag=m.tag then 1 else 0 end as tag_ok,
       case when s.note=m.note then 1 else 0 end as note_ok
  from t_oos04_update s, t_oos04_update_model m where s.id=m.id order by s.id;

select count(*) as row_count, count(distinct id) as distinct_ids from t_oos04_update;

update t_oos04_update set payload=cast(concat(repeat('37',1400),repeat('28',1400),repeat('19',1407)) as bit varying) where id=2;

update t_oos04_update_model set payload=cast(concat(repeat('37',1400),repeat('28',1400),repeat('19',1407)) as bit varying) where id=2;

evaluate '[U14] repeated write 3 remains exact';

select s.id, s.note, coalesce(octet_length(s.payload),-1) as payload_octets,
       coalesce(md5(s.payload),'NULL') as payload_md5, md5(s.tag) as tag_md5,
       case when (s.payload is null and m.payload is null) or s.payload=m.payload then 1 else 0 end as payload_ok,
       case when s.tag=m.tag then 1 else 0 end as tag_ok,
       case when s.note=m.note then 1 else 0 end as note_ok
  from t_oos04_update s, t_oos04_update_model m where s.id=m.id order by s.id;

select count(*) as row_count, count(distinct id) as distinct_ids from t_oos04_update;

update t_oos04_update set payload=(select payload from t_oos04_update_source where id=11) where id=1;

update t_oos04_update_model set payload=cast(concat(repeat('a1',1700),repeat('b2',1700),repeat('c3',1603)) as bit varying) where id=1;

evaluate '[U15] subquery UPDATE copies source row11 only';

select s.id, s.note, coalesce(octet_length(s.payload),-1) as payload_octets,
       coalesce(md5(s.payload),'NULL') as payload_md5, md5(s.tag) as tag_md5,
       case when (s.payload is null and m.payload is null) or s.payload=m.payload then 1 else 0 end as payload_ok,
       case when s.tag=m.tag then 1 else 0 end as tag_ok,
       case when s.note=m.note then 1 else 0 end as note_ok
  from t_oos04_update s, t_oos04_update_model m where s.id=m.id order by s.id;

select count(*) as row_count, count(distinct id) as distinct_ids from t_oos04_update;

update t_oos04_update a, t_oos04_update_source b set a.payload=b.payload, a.tag=b.tag where a.id=2 and b.id=12;

update t_oos04_update_model set payload=cast(concat(repeat('d4',3000),repeat('e5',3000),repeat('f6',3001)) as bit varying), tag=cast(repeat('b8',300) as bit varying) where id=2;

evaluate '[U16] join UPDATE copies distinct source row12 only';

select s.id, s.note, coalesce(octet_length(s.payload),-1) as payload_octets,
       coalesce(md5(s.payload),'NULL') as payload_md5, md5(s.tag) as tag_md5,
       case when (s.payload is null and m.payload is null) or s.payload=m.payload then 1 else 0 end as payload_ok,
       case when s.tag=m.tag then 1 else 0 end as tag_ok,
       case when s.note=m.note then 1 else 0 end as note_ok
  from t_oos04_update s, t_oos04_update_model m where s.id=m.id order by s.id;

select count(*) as row_count, count(distinct id) as distinct_ids from t_oos04_update;

evaluate '[U17] both source rows remain exact';

select s.id, s.note, coalesce(octet_length(s.payload),-1) as payload_octets,
       coalesce(md5(s.payload),'NULL') as payload_md5, md5(s.tag) as tag_md5,
       case when (s.payload is null and m.payload is null) or s.payload=m.payload then 1 else 0 end as payload_ok,
       case when s.tag=m.tag then 1 else 0 end as tag_ok,
       case when s.note=m.note then 1 else 0 end as note_ok
  from t_oos04_update_source s, t_oos04_update_source_model m where s.id=m.id order by s.id;

select count(*) as row_count, count(distinct id) as distinct_ids from t_oos04_update_source;

delete from t_oos04_update_source;

evaluate '[U18] source deletion leaves copied targets and survivors exact';

select s.id, s.note, coalesce(octet_length(s.payload),-1) as payload_octets,
       coalesce(md5(s.payload),'NULL') as payload_md5, md5(s.tag) as tag_md5,
       case when (s.payload is null and m.payload is null) or s.payload=m.payload then 1 else 0 end as payload_ok,
       case when s.tag=m.tag then 1 else 0 end as tag_ok,
       case when s.note=m.note then 1 else 0 end as note_ok
  from t_oos04_update s, t_oos04_update_model m where s.id=m.id order by s.id;

select count(*) as row_count, count(distinct id) as distinct_ids from t_oos04_update;

evaluate '[cleanup] every fixture table is removed';

drop table t_oos04_update_source_model;

drop table t_oos04_update_source;

drop table t_oos04_update_model;

drop table t_oos04_update;

select count(*) as fixture_tables from db_class where class_name in ('t_oos04_update_source_model','t_oos04_update_source','t_oos04_update_model','t_oos04_update');
