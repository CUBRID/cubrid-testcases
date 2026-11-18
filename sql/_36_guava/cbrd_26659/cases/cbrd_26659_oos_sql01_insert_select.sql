/*
 * CBRD-26659: compact VALUES / INSERT SELECT value-copy regression.
 * Reuses the recovered P03 structure, with four independently modeled rows.
 *
 * Payloads contain distinct head/middle/tail byte patterns, including values
 * intended for one, two and three OOS chunks at the 16 KiB profile. VARBIT is
 * not compressed. The 3000-byte row is an inline comparator; the remaining
 * rows are well above both the accepted 4060-byte target and the current
 * implementation gate. The 300-byte tag stays below the target after payload
 * demotion. These premises require separate physical companion observations.
 *
 * This case proves logical values, row identity and copy independence after
 * source DELETE and DROP. It does not observe placement, chain ownership,
 * vacuum reclamation, crash recovery or a particular internal fetch function.
 *
 * For N payload bytes, OCTET_LENGTH=N and DISK_SIZE=ALIGN(5+N,4).
 * MD5(VARBIT) hashes its lowercase hexadecimal representation; independently
 * derive the answer with hashlib.md5(hex_text.encode('ascii')).hexdigest().
 * Payload totals: 3000+4207+20003+33001=60211 bytes; tags total 4*300=1200.
 * The answer was derived before execution and is maintained independently.
 * Default JDBC autocommit is true; this case changes no session parameters.
 */

drop table if exists t_cbrd_26659_sql01_copy;
drop table if exists t_cbrd_26659_sql01_source;
drop table if exists t_cbrd_26659_sql01_model;

create table t_cbrd_26659_sql01_model
  (id int primary key, head_hex char(2), head_bytes int,
   middle_hex char(2), middle_bytes int, tail_hex char(2), tail_bytes int,
   tag_hex char(2));
insert into t_cbrd_26659_sql01_model values
  (1, 'aa', 1000, 'bb', 1000, 'cc', 1000, '11'),
  (2, 'd1', 1401, 'e2', 1403, 'f3', 1403, '22'),
  (3, '12', 7001, '34', 6501, '56', 6501, '33'),
  (4, '78', 11001, '9a', 11000, 'bc', 11000, '44');

evaluate '[TEST 1] VALUES and INSERT SELECT preserve each modeled source row';
create table t_cbrd_26659_sql01_source
  (id int primary key, payload bit varying, tag bit varying);
insert into t_cbrd_26659_sql01_source values
  (1, cast(concat(repeat('aa', 1000), repeat('bb', 1000), repeat('cc', 1000)) as bit varying),
      cast(repeat('11', 300) as bit varying));
insert into t_cbrd_26659_sql01_source
  select id,
         cast(concat(repeat(head_hex, head_bytes), repeat(middle_hex, middle_bytes),
                     repeat(tail_hex, tail_bytes)) as bit varying),
         cast(repeat(tag_hex, 300) as bit varying)
    from t_cbrd_26659_sql01_model where id > 1;
select s.id, octet_length(s.payload) as payload_octets,
       disk_size(s.payload) as payload_disk, md5(s.payload) as payload_md5,
       octet_length(s.tag) as tag_octets, md5(s.tag) as tag_md5,
       s.payload = cast(concat(repeat(m.head_hex, m.head_bytes),
                               repeat(m.middle_hex, m.middle_bytes),
                               repeat(m.tail_hex, m.tail_bytes)) as bit varying) as payload_ok,
       s.tag = cast(repeat(m.tag_hex, 300) as bit varying) as tag_ok
  from t_cbrd_26659_sql01_source s, t_cbrd_26659_sql01_model m
 where s.id = m.id order by s.id;
select count(*) as n_rows, sum(octet_length(payload)) as payload_octets_total,
       sum(octet_length(tag)) as tag_octets_total,
       count(distinct md5(payload)) as distinct_payloads,
       sum(case when payload = tag then 1 else 0 end) as n_aliased
  from t_cbrd_26659_sql01_source;

evaluate '[TEST 2] copied rows match source and independent model row by row';
create table t_cbrd_26659_sql01_copy
  (id int primary key, payload bit varying, tag bit varying);
insert into t_cbrd_26659_sql01_copy
  select id, payload, tag from t_cbrd_26659_sql01_source;
select c.id, c.payload = s.payload as source_payload_ok,
       c.tag = s.tag as source_tag_ok,
       c.payload = cast(concat(repeat(m.head_hex, m.head_bytes),
                               repeat(m.middle_hex, m.middle_bytes),
                               repeat(m.tail_hex, m.tail_bytes)) as bit varying) as model_payload_ok,
       c.tag = cast(repeat(m.tag_hex, 300) as bit varying) as model_tag_ok
  from t_cbrd_26659_sql01_copy c, t_cbrd_26659_sql01_source s,
       t_cbrd_26659_sql01_model m
 where c.id = s.id and c.id = m.id order by c.id;
select count(*) as n_rows, sum(octet_length(payload)) as payload_octets_total,
       sum(octet_length(tag)) as tag_octets_total,
       count(distinct md5(payload)) as distinct_payloads
  from t_cbrd_26659_sql01_copy;

evaluate '[TEST 3] source DELETE leaves all copied values intact';
delete from t_cbrd_26659_sql01_source;
select count(*) as source_rows from t_cbrd_26659_sql01_source;
select c.id, octet_length(c.payload) as payload_octets,
       disk_size(c.payload) as payload_disk, md5(c.payload) as payload_md5,
       octet_length(c.tag) as tag_octets, md5(c.tag) as tag_md5,
       c.payload = cast(concat(repeat(m.head_hex, m.head_bytes),
                               repeat(m.middle_hex, m.middle_bytes),
                               repeat(m.tail_hex, m.tail_bytes)) as bit varying) as payload_ok,
       c.tag = cast(repeat(m.tag_hex, 300) as bit varying) as tag_ok
  from t_cbrd_26659_sql01_copy c, t_cbrd_26659_sql01_model m
 where c.id = m.id order by c.id;

evaluate '[TEST 4] source DROP leaves all copied values intact';
drop table t_cbrd_26659_sql01_source;
select c.id, octet_length(c.payload) as payload_octets,
       disk_size(c.payload) as payload_disk, md5(c.payload) as payload_md5,
       octet_length(c.tag) as tag_octets, md5(c.tag) as tag_md5,
       c.payload = cast(concat(repeat(m.head_hex, m.head_bytes),
                               repeat(m.middle_hex, m.middle_bytes),
                               repeat(m.tail_hex, m.tail_bytes)) as bit varying) as payload_ok,
       c.tag = cast(repeat(m.tag_hex, 300) as bit varying) as tag_ok
  from t_cbrd_26659_sql01_copy c, t_cbrd_26659_sql01_model m
 where c.id = m.id order by c.id;
select count(*) as n_rows, sum(octet_length(payload)) as payload_octets_total,
       sum(octet_length(tag)) as tag_octets_total,
       count(distinct md5(payload)) as distinct_payloads
  from t_cbrd_26659_sql01_copy;

evaluate '[TEST 5] cleanup removes every fixture table';
drop table t_cbrd_26659_sql01_copy;
drop table t_cbrd_26659_sql01_model;
select count(*) as fixture_tables
  from db_class where class_name in
    ('t_cbrd_26659_sql01_source', 't_cbrd_26659_sql01_copy', 't_cbrd_26659_sql01_model');
