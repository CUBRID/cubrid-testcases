/* CBRD-26659 Ticket07: complete values through supported relational reads.
 * Expected rows/digests come from an independent four-row Python model before
 * execution. MD5(VARBIT) hashes lowercase hexadecimal text, including the tail.
 * Rows contain 3000/4207/20003/33001-byte distinct VARBIT payloads and 300-byte
 * tags, with VARCHAR/NUMERIC/INT inline fields. Every result has a unique key.
 * USING INDEX NONE and named index(+) follow current repository conventions;
 * paired CS csql plans retain their execution/path proof separately from JDBC.
 * The paired shell has identical values/schema/16 KiB settings and positive
 * named SHOW/owned diagdb observations. It does not observe this SQL invocation.
 * CTAS/read/copy coverage does not establish utility raw-fetch consumers,
 * reclaim, snapshots, recovery, retry or internal cursor behavior.
 * Default JDBC autocommit=true; no session parameters are changed.
 */

drop view if exists oos07_view;

drop table if exists oos07_copy;

drop table if exists oos07_inline;

drop table if exists oos07_rows;

create table oos07_rows
  (id int, grp int, score int, amount numeric(8,2), label varchar(20),
   payload bit varying, tag bit varying, constraint pk_oos07_rows primary key(id));

create index idx_oos07_group_score on oos07_rows(grp, score, id);

insert into oos07_rows values
  (1, 2, 40, 10.25, 'inline-one', cast(concat(repeat('aa', 1000), repeat('bb', 1000), repeat('cc', 1000)) as bit varying), cast(repeat('11', 300) as bit varying)),
  (2, 1, 30, 20.50, 'one-chunk', cast(concat(repeat('d1', 1401), repeat('e2', 1403), repeat('f3', 1403)) as bit varying), cast(repeat('22', 300) as bit varying)),
  (3, 2, 20, 30.75, 'two-chunks', cast(concat(repeat('12', 7001), repeat('34', 6501), repeat('56', 6501)) as bit varying), cast(repeat('33', 300) as bit varying)),
  (4, 1, 10, 40.00, 'three-chunks', cast(concat(repeat('78', 11001), repeat('9a', 11000), repeat('bc', 11000)) as bit varying), cast(repeat('44', 300) as bit varying));

create table oos07_inline as select * from oos07_rows where id=1 using index none;

evaluate '[TEST 1] heap inline-only projection';

select /*+ recompile */ id, grp, score, amount, label from oos07_rows where id>0 using index none order by id;

evaluate '[TEST 2] heap full-value equality and independently derived digests';

select /*+ recompile */ id, octet_length(payload) as payload_octets, md5(payload) as payload_md5, md5(tag) as tag_md5,
       payload = case id when 1 then cast(concat(repeat('aa', 1000), repeat('bb', 1000), repeat('cc', 1000)) as bit varying) when 2 then cast(concat(repeat('d1', 1401), repeat('e2', 1403), repeat('f3', 1403)) as bit varying) when 3 then cast(concat(repeat('12', 7001), repeat('34', 6501), repeat('56', 6501)) as bit varying) when 4 then cast(concat(repeat('78', 11001), repeat('9a', 11000), repeat('bc', 11000)) as bit varying) end as payload_ok
  from oos07_rows where id>0 using index none order by id;

evaluate '[TEST 3] forced primary-key scan returns the same complete values';

select /*+ recompile */ id, octet_length(payload) as payload_octets, md5(payload) as payload_md5, md5(tag) as tag_md5
  from oos07_rows where id>0 using index pk_oos07_rows(+) order by id;

evaluate '[TEST 4] forced multicolumn index preserves ordered payload values';

select /*+ recompile */ id, grp, score, octet_length(payload) as payload_octets, md5(payload) as payload_md5, md5(tag) as tag_md5
  from oos07_rows where grp=1 and score between 10 and 30
 using index idx_oos07_group_score(+) order by score, id;

create table oos07_copy as select * from oos07_rows using index none;

evaluate '[TEST 5] CTAS reads and writes complete logical values';

select id, octet_length(payload) as payload_octets, md5(payload) as payload_md5, md5(tag) as tag_md5 from oos07_copy order by id;

create view oos07_view as select id, grp, score, amount, label, payload, tag from oos07_rows;

evaluate '[TEST 6] view exposes the same complete logical values';

select id, octet_length(payload) as payload_octets, md5(payload) as payload_md5, md5(tag) as tag_md5 from oos07_view order by id;

evaluate '[TEST 7] join returns independently modeled ordered row pairs';

select a.id as left_id, b.id as right_id, md5(a.payload) as left_md5, md5(b.payload) as right_md5
  from oos07_rows a join oos07_copy b on a.grp=b.grp and a.id<b.id
 order by a.id, b.id;

evaluate '[TEST 8] correlated subquery selects the intended complete rows';

select a.id, octet_length(a.payload) as payload_octets, md5(a.payload) as payload_md5, md5(a.tag) as tag_md5
  from oos07_rows a where exists
       (select 1 from oos07_copy b where b.grp=a.grp and b.id>a.id and b.amount>a.amount)
 order by a.id;

evaluate '[TEST 9] payload sort has a unique id tie-breaker';

select id, octet_length(payload) as payload_octets, md5(payload) as payload_md5, md5(tag) as tag_md5 from oos07_rows order by payload, id;

evaluate '[TEST 10] grouped aggregates read complete payloads and mixed scalar types';

select grp, count(*) as row_count, sum(octet_length(payload)) as payload_octets,
       sum(amount) as amount_total, count(distinct md5(payload)) as distinct_payloads,
       min(id) as first_id, max(id) as last_id
  from oos07_rows group by grp order by grp;

evaluate '[TEST 11] grouping on the entire payload preserves all distinct values';

select min(id) as id, md5(payload) as payload_md5, count(*) as row_count,
       sum(octet_length(payload)) as payload_octets
  from oos07_rows group by payload order by min(id);

drop view oos07_view;

drop table oos07_rows;

evaluate '[TEST 12] CTAS values survive source DROP';

select id, octet_length(payload) as payload_octets, md5(payload) as payload_md5, md5(tag) as tag_md5 from oos07_copy order by id;

evaluate '[TEST 13] cleanup removes every owned fixture';

drop table oos07_copy;

drop table oos07_inline;

select count(*) as fixture_tables from db_class where class_name in ('oos07_rows', 'oos07_inline', 'oos07_copy', 'oos07_view');
