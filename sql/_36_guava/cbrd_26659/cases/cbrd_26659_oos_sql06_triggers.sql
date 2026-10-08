/*
 * CBRD-26659: AFTER UPDATE log/mirror, BEFORE UPDATE rejection, and valid writes.
 * Reuses P09's trigger semantics with Ticket01/02's distinguishable four-row
 * fixture, built before triggers exist. Ticket02 observes a separate matching
 * CS baseline; it does not observe placement in this public JDBC execution.
 * All triggered UPDATE, mirror INSERT and triggered INSERT checks are logical
 * only. At source fb567a629, matching triggers reject server DML eligibility
 * (execute_statement.c:is_server_update_allowed/is_server_insert_allowed);
 * client object templates serialize through transform_cl.c:tf_mem_to_disk.
 * No triggered OOS placement, chain ownership/reuse, retry, recovery or reclaim
 * is claimed here. DISK_SIZE/OCTET_LENGTH would not prove physical placement.
 *
 * Payload lengths are 3000/4207/20003/33001 bytes, initial total60211. The
 * final valid row2 replacement is a1/b2/c3, 1403 bytes each, total4209 bytes;
 * final payload total60213. Tags are300 bytes. MD5(VARBIT) uses lowercase hex
 * text; answers are independently derived with hashlib.md5(hex.encode()).
 * BEFORE REJECT is ER_TR_REJECTED=-517 (error_code.h:609). The rejected update
 * changes no row/log/mirror; later valid writes must still execute. All SELECTs
 * have deterministic ordering. JDBC autocommit remains at its default true;
 * no session parameters are changed. Explicit final cleanup checks tables and
 * triggers; native attempt cleanup also removes the owned database on failures.
 */
drop table if exists t_oos06_inslog;

drop table if exists t_oos06_ins;

drop table if exists t_oos06_mirror;

drop table if exists t_oos06_log;

drop table if exists t_oos06;

drop table if exists t_oos06_model;

create table t_oos06_model (id int primary key, head_hex char(2), head_bytes int,
  middle_hex char(2), middle_bytes int, tail_hex char(2), tail_bytes int, tag_hex char(2));

insert into t_oos06_model values
  (1,'aa',1000,'bb',1000,'cc',1000,'11'),
  (2,'d1',1401,'e2',1403,'f3',1403,'22'),
  (3,'12',7001,'34',6501,'56',6501,'33'),
  (4,'78',11001,'9a',11000,'bc',11000,'44');

create table t_oos06 (id int primary key, payload bit varying, tag bit varying);

create table t_oos06_log (seq int auto_increment primary key, id int,
  payload_octets int,payload_md5 varchar(32),tag_md5 varchar(32));

create table t_oos06_mirror (seq int auto_increment primary key,id int,payload bit varying,tag bit varying);

evaluate '[TEST 1] the matching four-row fixture exists before triggers';

insert into t_oos06 values (1,cast(concat(repeat('aa',1000),repeat('bb',1000),repeat('cc',1000)) as bit varying),cast(repeat('11',300) as bit varying));

insert into t_oos06 select id,cast(concat(repeat(head_hex,head_bytes),repeat(middle_hex,middle_bytes),repeat(tail_hex,tail_bytes)) as bit varying),cast(repeat(tag_hex,300) as bit varying) from t_oos06_model where id>1;

select s.id, octet_length(s.payload) as payload_octets, md5(s.payload) as payload_md5,
       md5(s.tag) as tag_md5, s.payload=cast(concat(repeat(m.head_hex,m.head_bytes),repeat(m.middle_hex,m.middle_bytes),repeat(m.tail_hex,m.tail_bytes)) as bit varying) as payload_ok,
       s.tag=cast(repeat(m.tag_hex,300) as bit varying) as tag_ok
  from t_oos06 s, t_oos06_model m where s.id=m.id order by s.id;

evaluate '[TEST 2] AFTER UPDATE logs the complete post-image';

create trigger tr_oos06_log after update on t_oos06
  execute insert into t_oos06_log (id,payload_octets,payload_md5,tag_md5)
  values (obj.id,octet_length(obj.payload),md5(obj.payload),md5(obj.tag));

update t_oos06 set tag=cast(repeat('55',300) as bit varying) where id=2;

select seq,id,payload_octets,payload_md5,tag_md5 from t_oos06_log order by seq;

evaluate '[TEST 3] AFTER UPDATE mirror and log preserve the second post-image';

create trigger tr_oos06_mirror after update on t_oos06
  execute insert into t_oos06_mirror (id,payload,tag) values (obj.id,obj.payload,obj.tag);

update t_oos06 set tag=cast(repeat('66',300) as bit varying) where id=2;

select s.id, octet_length(s.payload) as payload_octets, md5(s.payload) as payload_md5,
       md5(s.tag) as tag_md5, s.payload=cast(concat(repeat(m.head_hex,m.head_bytes),repeat(m.middle_hex,m.middle_bytes),repeat(m.tail_hex,m.tail_bytes)) as bit varying) as payload_ok,
       s.tag=cast(repeat('66',300) as bit varying) as tag_ok
  from t_oos06 s, t_oos06_model m where s.id=m.id and s.id=2 order by s.id;

select seq,id,payload_octets,payload_md5,tag_md5 from t_oos06_log order by seq;

select seq,id,octet_length(payload) as payload_octets,md5(payload) as payload_md5,md5(tag) as tag_md5,
       payload=cast(concat(repeat('d1',1401),repeat('e2',1403),repeat('f3',1403)) as bit varying) as payload_ok,
       tag=cast(repeat('66',300) as bit varying) as tag_ok from t_oos06_mirror order by seq;

evaluate '[TEST 4] BEFORE UPDATE rejects row2 with Error:-517';

create trigger tr_oos06_reject before update on t_oos06 if obj.id=2 execute reject;

update t_oos06 set payload=cast(repeat('ff',5000) as bit varying),tag=cast(repeat('99',300) as bit varying) where id=2;

evaluate '[TEST 5] rejection preserves the exact row and all AFTER effects';

select s.id, octet_length(s.payload) as payload_octets, md5(s.payload) as payload_md5,
       md5(s.tag) as tag_md5, s.payload=cast(concat(repeat(m.head_hex,m.head_bytes),repeat(m.middle_hex,m.middle_bytes),repeat(m.tail_hex,m.tail_bytes)) as bit varying) as payload_ok,
       s.tag=cast(repeat('66',300) as bit varying) as tag_ok
  from t_oos06 s, t_oos06_model m where s.id=m.id and s.id=2 order by s.id;

select seq,id,payload_octets,payload_md5,tag_md5 from t_oos06_log order by seq;

select count(*) as mirror_rows,sum(case when id=2 and payload=cast(concat(repeat('d1',1401),repeat('e2',1403),repeat('f3',1403)) as bit varying) and tag=cast(repeat('66',300) as bit varying) and md5(payload)='5a43433dc26414a3625551ee8fc23cd2' and md5(tag)='27b46a35fe6e802a41a7137b460ceb6d' then 1 else 0 end) as mirror_values_ok from t_oos06_mirror;

evaluate '[TEST 6] another row remains writable while rejection is active';

update t_oos06 set tag=cast(repeat('77',300) as bit varying) where id=1;

evaluate '[TEST 7] dropping rejection permits a complete row2 replacement';

drop trigger tr_oos06_reject;

update t_oos06 set payload=cast(concat(repeat('a1',1403),repeat('b2',1403),repeat('c3',1403)) as bit varying),tag=cast(repeat('88',300) as bit varying) where id=2;

select s.id, octet_length(s.payload) as payload_octets, md5(s.payload) as payload_md5,
       md5(s.tag) as tag_md5, s.payload=case when s.id=2 then cast(concat(repeat('a1',1403),repeat('b2',1403),repeat('c3',1403)) as bit varying) else cast(concat(repeat(m.head_hex,m.head_bytes),repeat(m.middle_hex,m.middle_bytes),repeat(m.tail_hex,m.tail_bytes)) as bit varying) end as payload_ok,
       s.tag=case when s.id=1 then cast(repeat('77',300) as bit varying) when s.id=2 then cast(repeat('88',300) as bit varying) else cast(repeat(m.tag_hex,300) as bit varying) end as tag_ok
  from t_oos06 s, t_oos06_model m where s.id=m.id order by s.id;

select seq,id,payload_octets,payload_md5,tag_md5 from t_oos06_log order by seq;

select seq,id,octet_length(payload) as payload_octets,md5(payload) as payload_md5,md5(tag) as tag_md5,
       payload=case seq when 1 then cast(concat(repeat('d1',1401),repeat('e2',1403),repeat('f3',1403)) as bit varying)
         when 2 then cast(concat(repeat('aa',1000),repeat('bb',1000),repeat('cc',1000)) as bit varying)
         when 3 then cast(concat(repeat('a1',1403),repeat('b2',1403),repeat('c3',1403)) as bit varying) end as payload_ok,
       tag=case seq when 1 then cast(repeat('66',300) as bit varying) when 2 then cast(repeat('77',300) as bit varying)
         when 3 then cast(repeat('88',300) as bit varying) end as tag_ok from t_oos06_mirror order by seq;

select count(*) as n_rows,sum(octet_length(payload)) as payload_octets_total,count(distinct md5(payload)) as distinct_payloads from t_oos06;

evaluate '[TEST 8] triggered INSERT preserves logical values and its log';

create table t_oos06_ins (id int primary key,payload bit varying,tag bit varying);

create table t_oos06_inslog (id int primary key,payload_octets int,payload_md5 varchar(32),tag_md5 varchar(32));

create trigger tr_oos06_ins after insert on t_oos06_ins
  execute insert into t_oos06_inslog values (obj.id,octet_length(obj.payload),md5(obj.payload),md5(obj.tag));

insert into t_oos06_ins values (5,cast(concat(repeat('d1',1401),repeat('e2',1403),repeat('f3',1403)) as bit varying),cast(repeat('99',300) as bit varying));

select id,octet_length(payload) as payload_octets,md5(payload) as payload_md5,md5(tag) as tag_md5,
       payload=cast(concat(repeat('d1',1401),repeat('e2',1403),repeat('f3',1403)) as bit varying) as payload_ok,
       tag=cast(repeat('99',300) as bit varying) as tag_ok from t_oos06_ins order by id;

select id,payload_octets,payload_md5,tag_md5 from t_oos06_inslog order by id;

evaluate '[TEST 9] every trigger mirror log and helper is removed';

drop trigger tr_oos06_ins;

drop trigger tr_oos06_mirror;

drop trigger tr_oos06_log;

drop table t_oos06_inslog;

drop table t_oos06_ins;

drop table t_oos06_mirror;

drop table t_oos06_log;

drop table t_oos06;

drop table t_oos06_model;

select count(*) as fixture_tables from db_class where class_name in ('t_oos06','t_oos06_model','t_oos06_log','t_oos06_mirror','t_oos06_ins','t_oos06_inslog');

select count(*) as fixture_triggers from db_trigger where trigger_name in ('tr_oos06_log','tr_oos06_mirror','tr_oos06_reject','tr_oos06_ins');
