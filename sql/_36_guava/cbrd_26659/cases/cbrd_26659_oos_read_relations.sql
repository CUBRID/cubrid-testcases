-- Work456/05: independently modeled full-value relational and copy contracts.
-- A=100 bytes; B/C=5107 bytes and differ ONLY in the last byte; id4 duplicates B.
-- N=NULL and E=empty are distinct. Full-value equality classifies every output.
-- SELECT_RECORD_INFO observes this exact JDBC invocation's unpartitioned
-- current REC_HOME records. Record type=2 and HAS_OOS bit=8 are asserted.
-- The identical 100-byte A value crosses C/S sources and C/S destinations
-- through DEFAULT/FORCE_OUTLINE; B/C stay S at these ordinary destination layouts. NULL/empty cannot form a profitable >24-byte stub.
-- No per-attribute, internal dispatch, Expand, vacuum or chain-identity claim.

drop table if exists w456r_rows;

drop table if exists w456r_plain;

drop table if exists w456r_outline;

drop table if exists w456r_cc;

drop table if exists w456r_cs;

drop table if exists w456r_sc;

drop table if exists w456r_ss;

drop table if exists w456r_ctas;

drop table if exists w456r_self;

drop table if exists w456r_rollback;

drop table if exists w456r_strings;

drop table if exists w456r_fixed;

drop table if exists w456r_fixedcopy;

drop table if exists w456r_fixedclear;

create table w456r_rows(id int primary key,note int,payload bit varying);

create table w456r_plain(id int primary key,note int,payload bit varying);

create table w456r_outline(id int primary key,note int,payload bit varying storage force_outline);

create index w456r_note on w456r_rows(note,id);

insert into w456r_rows values (1,11,cast(concat(repeat('19',99),'ab') as bit varying)),(2,22,cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)),(3,33,cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying)),(4,44,cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)),(5,55,NULL),(6,66,X'');

insert into w456r_plain select * from w456r_rows;

insert into w456r_outline select * from w456r_rows;

-- actual flags and complete values: rows

select /*+ SELECT_RECORD_INFO */ id, note, case when id=1 and payload=cast(concat(repeat('19',99),'ab') as bit varying) then 1 when id=2 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=3 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 when id=4 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=5 and payload is null then 1 when id=6 and payload=X'' then 1 else 0 end as value_ok, t_rectype as record_type, case when mod(t_flags,16)>=8 then 1 else 0 end as has_oos from w456r_rows order by id;

-- actual flags and complete values: plain

select /*+ SELECT_RECORD_INFO */ id, note, case when id=1 and payload=cast(concat(repeat('19',99),'ab') as bit varying) then 1 when id=2 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=3 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 when id=4 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=5 and payload is null then 1 when id=6 and payload=X'' then 1 else 0 end as value_ok, t_rectype as record_type, case when mod(t_flags,16)>=8 then 1 else 0 end as has_oos from w456r_plain order by id;

-- actual flags and complete values: outline

select /*+ SELECT_RECORD_INFO */ id, note, case when id=1 and payload=cast(concat(repeat('19',99),'ab') as bit varying) then 1 when id=2 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=3 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 when id=4 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=5 and payload is null then 1 when id=6 and payload=X'' then 1 else 0 end as value_ok, t_rectype as record_type, case when mod(t_flags,16)>=8 then 1 else 0 end as has_oos from w456r_outline order by id;

-- heap complete values

select id, case when payload is null then 'N' when payload=X'' then 'E' when payload=cast(concat(repeat('19',99),'ab') as bit varying) then 'A' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 'B' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 'C' else 'BAD' end as value_code from w456r_rows using index none order by id;

-- index range descending complete values

select id, case when payload is null then 'N' when payload=X'' then 'E' when payload=cast(concat(repeat('19',99),'ab') as bit varying) then 'A' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 'B' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 'C' else 'BAD' end as value_code from w456r_rows where note between 11 and 44 using index w456r_note(+) order by note desc,id;

-- existence and selective header projection

select id,note from w456r_rows where exists(select 1 from w456r_plain b where b.id=w456r_rows.id) order by id;

-- full payload equality distinguishes same-length tails

select id, case when payload is null then 'N' when payload=X'' then 'E' when payload=cast(concat(repeat('19',99),'ab') as bit varying) then 'A' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 'B' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 'C' else 'BAD' end as value_code from w456r_rows where payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) order by id;

-- inner full-value join multiplicity

select a.id as left_id,b.id as right_id,case when a.payload is null then 'N' when a.payload=X'' then 'E' when a.payload=cast(concat(repeat('19',99),'ab') as bit varying) then 'A' when a.payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 'B' when a.payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 'C' else 'BAD' end as value_code from w456r_rows a join w456r_plain b on a.payload=b.payload order by a.id,b.id;

-- outer join NULL and duplicate semantics

select a.id as left_id,b.id as right_id,case when a.payload is null then 'N' when a.payload=X'' then 'E' when a.payload=cast(concat(repeat('19',99),'ab') as bit varying) then 'A' when a.payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 'B' when a.payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 'C' else 'BAD' end as value_code from w456r_rows a left join w456r_outline b on a.payload=b.payload and b.id in (2,3,5) order by a.id,b.id;

-- correlated full-value subquery

select a.id,case when a.payload is null then 'N' when a.payload=X'' then 'E' when a.payload=cast(concat(repeat('19',99),'ab') as bit varying) then 'A' when a.payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 'B' when a.payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 'C' else 'BAD' end as value_code from w456r_rows a where exists(select 1 from w456r_plain b where b.payload=a.payload and b.id>a.id) order by a.id;

-- CTE preserves complete values

with chosen as (select id,payload from w456r_rows where id in (1,3,5,6)) select id,case when payload is null then 'N' when payload=X'' then 'E' when payload=cast(concat(repeat('19',99),'ab') as bit varying) then 'A' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 'B' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 'C' else 'BAD' end as value_code from chosen order by id;

-- full payload order and LIMIT

select id,case when payload is null then 'N' when payload=X'' then 'E' when payload=cast(concat(repeat('19',99),'ab') as bit varying) then 'A' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 'B' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 'C' else 'BAD' end as value_code from w456r_rows where payload is not null order by payload desc,id limit 4;

-- GROUP BY compares full values

select case when payload is null then 'N' when payload=X'' then 'E' when payload=cast(concat(repeat('19',99),'ab') as bit varying) then 'A' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 'B' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 'C' else 'BAD' end as value_code,count(*) as multiplicity,min(id) as first_id,max(id) as last_id,sum(note) as note_sum from w456r_rows group by payload order by value_code;

-- full-value MIN MAX and DISTINCT aggregate

select case when min(payload) is null then 'N' when min(payload)=X'' then 'E' when min(payload)=cast(concat(repeat('19',99),'ab') as bit varying) then 'A' when min(payload)=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 'B' when min(payload)=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 'C' else 'BAD' end as min_code,case when max(payload) is null then 'N' when max(payload)=X'' then 'E' when max(payload)=cast(concat(repeat('19',99),'ab') as bit varying) then 'A' when max(payload)=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 'B' when max(payload)=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 'C' else 'BAD' end as max_code,count(payload) as nonnull_count,count(distinct payload) as distinct_payloads from w456r_rows;

-- DISTINCT compares full values

select case when payload is null then 'N' when payload=X'' then 'E' when payload=cast(concat(repeat('19',99),'ab') as bit varying) then 'A' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 'B' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 'C' else 'BAD' end as value_code from (select distinct payload from w456r_rows) d order by value_code;

-- union exact full-value multiset

select case when payload is null then 'N' when payload=X'' then 'E' when payload=cast(concat(repeat('19',99),'ab') as bit varying) then 'A' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 'B' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 'C' else 'BAD' end as value_code from (select payload from w456r_rows union select payload from w456r_outline where id in (2,3,5,6)) d order by value_code;

-- union all exact full-value multiset

select case when payload is null then 'N' when payload=X'' then 'E' when payload=cast(concat(repeat('19',99),'ab') as bit varying) then 'A' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 'B' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 'C' else 'BAD' end as value_code from (select payload from w456r_rows union all select payload from w456r_outline where id in (2,3,5,6)) d order by value_code;

-- intersection exact full-value multiset

select case when payload is null then 'N' when payload=X'' then 'E' when payload=cast(concat(repeat('19',99),'ab') as bit varying) then 'A' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 'B' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 'C' else 'BAD' end as value_code from (select payload from w456r_rows intersection select payload from w456r_outline where id in (2,3,5,6)) d order by value_code;

-- intersection all exact full-value multiset

select case when payload is null then 'N' when payload=X'' then 'E' when payload=cast(concat(repeat('19',99),'ab') as bit varying) then 'A' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 'B' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 'C' else 'BAD' end as value_code from (select payload from w456r_rows intersection all select payload from w456r_outline where id in (2,3,5,6)) d order by value_code;

-- difference exact full-value multiset

select case when payload is null then 'N' when payload=X'' then 'E' when payload=cast(concat(repeat('19',99),'ab') as bit varying) then 'A' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 'B' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 'C' else 'BAD' end as value_code from (select payload from w456r_rows difference select payload from w456r_outline where id in (2,3,5,6)) d order by value_code;

-- difference all exact full-value multiset

select case when payload is null then 'N' when payload=X'' then 'E' when payload=cast(concat(repeat('19',99),'ab') as bit varying) then 'A' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 'B' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 'C' else 'BAD' end as value_code from (select payload from w456r_rows difference all select payload from w456r_outline where id in (2,3,5,6)) d order by value_code;

-- VARBIT CAST and COALESCE preserve complete identity

select id,case when coalesce(payload,X'') is null then 'N' when coalesce(payload,X'')=X'' then 'E' when coalesce(payload,X'')=cast(concat(repeat('19',99),'ab') as bit varying) then 'A' when coalesce(payload,X'')=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 'B' when coalesce(payload,X'')=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 'C' else 'BAD' end as coalesced_code,case when payload is null then 1 when cast(cast(payload as varchar) as bit varying)=payload then 1 else 0 end as cast_ok from w456r_rows order by id;

create table w456r_cc(id int primary key,note int,payload bit varying storage default);

insert into w456r_cc select * from w456r_plain;

-- actual flags and complete values: cc

select /*+ SELECT_RECORD_INFO */ id, note, case when id=1 and payload=cast(concat(repeat('19',99),'ab') as bit varying) then 1 when id=2 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=3 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 when id=4 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=5 and payload is null then 1 when id=6 and payload=X'' then 1 else 0 end as value_ok, t_rectype as record_type, case when mod(t_flags,16)>=8 then 1 else 0 end as has_oos from w456r_cc order by id;

create table w456r_cs(id int primary key,note int,payload bit varying storage force_outline);

insert into w456r_cs select * from w456r_plain;

-- actual flags and complete values: cs

select /*+ SELECT_RECORD_INFO */ id, note, case when id=1 and payload=cast(concat(repeat('19',99),'ab') as bit varying) then 1 when id=2 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=3 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 when id=4 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=5 and payload is null then 1 when id=6 and payload=X'' then 1 else 0 end as value_ok, t_rectype as record_type, case when mod(t_flags,16)>=8 then 1 else 0 end as has_oos from w456r_cs order by id;

create table w456r_sc(id int primary key,note int,payload bit varying storage default);

insert into w456r_sc select * from w456r_outline;

-- actual flags and complete values: sc

select /*+ SELECT_RECORD_INFO */ id, note, case when id=1 and payload=cast(concat(repeat('19',99),'ab') as bit varying) then 1 when id=2 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=3 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 when id=4 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=5 and payload is null then 1 when id=6 and payload=X'' then 1 else 0 end as value_ok, t_rectype as record_type, case when mod(t_flags,16)>=8 then 1 else 0 end as has_oos from w456r_sc order by id;

create table w456r_ss(id int primary key,note int,payload bit varying storage force_outline);

insert into w456r_ss select * from w456r_outline;

-- actual flags and complete values: ss

select /*+ SELECT_RECORD_INFO */ id, note, case when id=1 and payload=cast(concat(repeat('19',99),'ab') as bit varying) then 1 when id=2 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=3 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 when id=4 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=5 and payload is null then 1 when id=6 and payload=X'' then 1 else 0 end as value_ok, t_rectype as record_type, case when mod(t_flags,16)>=8 then 1 else 0 end as has_oos from w456r_ss order by id;

insert into w456r_sc select NULL,note,payload from w456r_rows where id=1;

insert into w456r_sc select NULL,note,payload from w456r_rows where id=2;

-- actual flags and complete values: sc

select /*+ SELECT_RECORD_INFO */ id, note, case when id=1 and payload=cast(concat(repeat('19',99),'ab') as bit varying) then 1 when id=2 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=3 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 when id=4 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=5 and payload is null then 1 when id=6 and payload=X'' then 1 else 0 end as value_ok, t_rectype as record_type, case when mod(t_flags,16)>=8 then 1 else 0 end as has_oos from w456r_sc order by id;

create table w456r_ctas as select * from w456r_rows;

-- actual flags and complete values: ctas

select /*+ SELECT_RECORD_INFO */ id, note, case when id=1 and payload=cast(concat(repeat('19',99),'ab') as bit varying) then 1 when id=2 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=3 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 when id=4 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=5 and payload is null then 1 when id=6 and payload=X'' then 1 else 0 end as value_ok, t_rectype as record_type, case when mod(t_flags,16)>=8 then 1 else 0 end as has_oos from w456r_ctas order by id;

create table w456r_self(id int primary key,note int,payload bit varying);

insert into w456r_self select * from w456r_rows;

insert into w456r_self select id+10,note,payload from w456r_self;

-- self-copy full identity

select id,case when payload is null then 'N' when payload=X'' then 'E' when payload=cast(concat(repeat('19',99),'ab') as bit varying) then 'A' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 'B' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 'C' else 'BAD' end as value_code from w456r_self order by id;

-- self-copy actual stored flags

select /*+ SELECT_RECORD_INFO */ id,case when (case when id>10 then id-10 else id end)=1 and payload=cast(concat(repeat('19',99),'ab') as bit varying) then 1 when (case when id>10 then id-10 else id end)=2 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when (case when id>10 then id-10 else id end)=3 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 when (case when id>10 then id-10 else id end)=4 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when (case when id>10 then id-10 else id end)=5 and payload is null then 1 when (case when id>10 then id-10 else id end)=6 and payload=X'' then 1 else 0 end as value_ok,t_rectype as record_type,case when mod(t_flags,16)>=8 then 1 else 0 end as has_oos from w456r_self order by id;

create table w456r_fixed(id int primary key,note int,payload bit(40856));

insert into w456r_fixed select * from w456r_rows where id in (2,3,4);

create table w456r_fixedcopy(id int primary key,note int,payload bit varying storage force_outline);

insert into w456r_fixedcopy select * from w456r_fixed;

create table w456r_fixedclear(id int primary key,note int,payload bit(40856));

insert into w456r_fixedclear select * from w456r_fixed;

-- large fixed/variable exact transfer flags: fixed

select /*+ SELECT_RECORD_INFO */ id,case when id=1 and payload=cast(concat(repeat('19',99),'ab') as bit varying) then 1 when id=2 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=3 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 when id=4 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=5 and payload is null then 1 when id=6 and payload=X'' then 1 else 0 end as value_ok,t_rectype as record_type,case when mod(t_flags,16)>=8 then 1 else 0 end as has_oos from w456r_fixed order by id;

-- large fixed/variable exact transfer flags: fixedcopy

select /*+ SELECT_RECORD_INFO */ id,case when id=1 and payload=cast(concat(repeat('19',99),'ab') as bit varying) then 1 when id=2 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=3 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 when id=4 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=5 and payload is null then 1 when id=6 and payload=X'' then 1 else 0 end as value_ok,t_rectype as record_type,case when mod(t_flags,16)>=8 then 1 else 0 end as has_oos from w456r_fixedcopy order by id;

-- large fixed/variable exact transfer flags: fixedclear

select /*+ SELECT_RECORD_INFO */ id,case when id=1 and payload=cast(concat(repeat('19',99),'ab') as bit varying) then 1 when id=2 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=3 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 when id=4 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=5 and payload is null then 1 when id=6 and payload=X'' then 1 else 0 end as value_ok,t_rectype as record_type,case when mod(t_flags,16)>=8 then 1 else 0 end as has_oos from w456r_fixedclear order by id;

create table w456r_rollback(id int primary key,note int,payload bit varying storage force_outline);

autocommit off;

insert into w456r_rollback select * from w456r_rows;

-- actual flags and complete values: rollback

select /*+ SELECT_RECORD_INFO */ id, note, case when id=1 and payload=cast(concat(repeat('19',99),'ab') as bit varying) then 1 when id=2 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=3 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 when id=4 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=5 and payload is null then 1 when id=6 and payload=X'' then 1 else 0 end as value_ok, t_rectype as record_type, case when mod(t_flags,16)>=8 then 1 else 0 end as has_oos from w456r_rollback order by id;

rollback;

-- rolled-back copy is logically absent

select count(*) as row_count from w456r_rollback;

-- source pre-image survives copy rollback

select id,case when payload is null then 'N' when payload=X'' then 'E' when payload=cast(concat(repeat('19',99),'ab') as bit varying) then 'A' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 'B' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 'C' else 'BAD' end as value_code from w456r_rows order by id;

-- actual flags and complete values: rows

select /*+ SELECT_RECORD_INFO */ id, note, case when id=1 and payload=cast(concat(repeat('19',99),'ab') as bit varying) then 1 when id=2 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=3 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 when id=4 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=5 and payload is null then 1 when id=6 and payload=X'' then 1 else 0 end as value_ok, t_rectype as record_type, case when mod(t_flags,16)>=8 then 1 else 0 end as has_oos from w456r_rows order by id;

commit;

autocommit on;

create table w456r_strings(id int primary key,v varchar storage force_outline,n nchar varying storage force_outline);

insert into w456r_strings values(1,concat(repeat('Head-mid-',11),'tail-a'),cast(concat(repeat('N-head-mid-',11),'tail-z') as nchar varying)),(2,'small-v',cast('small-n' as nchar varying));

-- string/national-string CAST and full expressions

select id,case when id=1 and v=concat(repeat('Head-mid-',11),'tail-a') and n=cast(concat(repeat('N-head-mid-',11),'tail-z') as nchar varying) and concat(v,'!')=concat(repeat('Head-mid-',11),'tail-a!') then 1 when id=2 and v='small-v' and n=cast('small-n' as nchar varying) then 1 else 0 end as value_ok from w456r_strings order by id;

-- actual string records state

select /*+ SELECT_RECORD_INFO */ id,case when id=1 and v=concat(repeat('Head-mid-',11),'tail-a') and n=cast(concat(repeat('N-head-mid-',11),'tail-z') as nchar varying) then 1 when id=2 and v='small-v' and n=cast('small-n' as nchar varying) then 1 else 0 end as value_ok,t_rectype as record_type,case when mod(t_flags,16)>=8 then 1 else 0 end as has_oos from w456r_strings order by id;

delete from w456r_rows;

drop table w456r_rows;

delete from w456r_plain;

drop table w456r_plain;

delete from w456r_outline;

drop table w456r_outline;

delete from w456r_fixed;

drop table w456r_fixed;

-- fixed-source destruction survivor: fixedcopy

select id,case when payload is null then 'N' when payload=X'' then 'E' when payload=cast(concat(repeat('19',99),'ab') as bit varying) then 'A' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 'B' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 'C' else 'BAD' end as value_code from w456r_fixedcopy order by id;

-- fixed-copy survivor stored flags: fixedcopy

select /*+ SELECT_RECORD_INFO */ id,case when id=1 and payload=cast(concat(repeat('19',99),'ab') as bit varying) then 1 when id=2 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=3 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 when id=4 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=5 and payload is null then 1 when id=6 and payload=X'' then 1 else 0 end as value_ok,t_rectype as record_type,case when mod(t_flags,16)>=8 then 1 else 0 end as has_oos from w456r_fixedcopy order by id;

-- fixed-source destruction survivor: fixedclear

select id,case when payload is null then 'N' when payload=X'' then 'E' when payload=cast(concat(repeat('19',99),'ab') as bit varying) then 'A' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 'B' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 'C' else 'BAD' end as value_code from w456r_fixedclear order by id;

-- fixed-copy survivor stored flags: fixedclear

select /*+ SELECT_RECORD_INFO */ id,case when id=1 and payload=cast(concat(repeat('19',99),'ab') as bit varying) then 1 when id=2 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=3 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 when id=4 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=5 and payload is null then 1 when id=6 and payload=X'' then 1 else 0 end as value_ok,t_rectype as record_type,case when mod(t_flags,16)>=8 then 1 else 0 end as has_oos from w456r_fixedclear order by id;

-- source DELETE/DROP survivor: cc

select id,case when payload is null then 'N' when payload=X'' then 'E' when payload=cast(concat(repeat('19',99),'ab') as bit varying) then 'A' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 'B' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 'C' else 'BAD' end as value_code from w456r_cc order by id;

-- actual flags and complete values: cc

select /*+ SELECT_RECORD_INFO */ id, note, case when id=1 and payload=cast(concat(repeat('19',99),'ab') as bit varying) then 1 when id=2 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=3 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 when id=4 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=5 and payload is null then 1 when id=6 and payload=X'' then 1 else 0 end as value_ok, t_rectype as record_type, case when mod(t_flags,16)>=8 then 1 else 0 end as has_oos from w456r_cc order by id;

-- source DELETE/DROP survivor: cs

select id,case when payload is null then 'N' when payload=X'' then 'E' when payload=cast(concat(repeat('19',99),'ab') as bit varying) then 'A' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 'B' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 'C' else 'BAD' end as value_code from w456r_cs order by id;

-- actual flags and complete values: cs

select /*+ SELECT_RECORD_INFO */ id, note, case when id=1 and payload=cast(concat(repeat('19',99),'ab') as bit varying) then 1 when id=2 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=3 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 when id=4 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=5 and payload is null then 1 when id=6 and payload=X'' then 1 else 0 end as value_ok, t_rectype as record_type, case when mod(t_flags,16)>=8 then 1 else 0 end as has_oos from w456r_cs order by id;

-- source DELETE/DROP survivor: sc

select id,case when payload is null then 'N' when payload=X'' then 'E' when payload=cast(concat(repeat('19',99),'ab') as bit varying) then 'A' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 'B' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 'C' else 'BAD' end as value_code from w456r_sc order by id;

-- actual flags and complete values: sc

select /*+ SELECT_RECORD_INFO */ id, note, case when id=1 and payload=cast(concat(repeat('19',99),'ab') as bit varying) then 1 when id=2 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=3 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 when id=4 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=5 and payload is null then 1 when id=6 and payload=X'' then 1 else 0 end as value_ok, t_rectype as record_type, case when mod(t_flags,16)>=8 then 1 else 0 end as has_oos from w456r_sc order by id;

-- source DELETE/DROP survivor: ss

select id,case when payload is null then 'N' when payload=X'' then 'E' when payload=cast(concat(repeat('19',99),'ab') as bit varying) then 'A' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 'B' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 'C' else 'BAD' end as value_code from w456r_ss order by id;

-- actual flags and complete values: ss

select /*+ SELECT_RECORD_INFO */ id, note, case when id=1 and payload=cast(concat(repeat('19',99),'ab') as bit varying) then 1 when id=2 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=3 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 when id=4 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=5 and payload is null then 1 when id=6 and payload=X'' then 1 else 0 end as value_ok, t_rectype as record_type, case when mod(t_flags,16)>=8 then 1 else 0 end as has_oos from w456r_ss order by id;

-- source DELETE/DROP survivor: ctas

select id,case when payload is null then 'N' when payload=X'' then 'E' when payload=cast(concat(repeat('19',99),'ab') as bit varying) then 'A' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 'B' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 'C' else 'BAD' end as value_code from w456r_ctas order by id;

-- actual flags and complete values: ctas

select /*+ SELECT_RECORD_INFO */ id, note, case when id=1 and payload=cast(concat(repeat('19',99),'ab') as bit varying) then 1 when id=2 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=3 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 when id=4 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=5 and payload is null then 1 when id=6 and payload=X'' then 1 else 0 end as value_ok, t_rectype as record_type, case when mod(t_flags,16)>=8 then 1 else 0 end as has_oos from w456r_ctas order by id;

delete from w456r_self where id<10;

-- self-copy survivor after original rows DELETE

select id,case when payload is null then 'N' when payload=X'' then 'E' when payload=cast(concat(repeat('19',99),'ab') as bit varying) then 'A' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 'B' when payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 'C' else 'BAD' end as value_code from w456r_self order by id;

-- self-copy survivor stored flags

select /*+ SELECT_RECORD_INFO */ id,case when (id-10)=1 and payload=cast(concat(repeat('19',99),'ab') as bit varying) then 1 when (id-10)=2 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when (id-10)=3 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 when (id-10)=4 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when (id-10)=5 and payload is null then 1 when (id-10)=6 and payload=X'' then 1 else 0 end as value_ok,t_rectype as record_type,case when mod(t_flags,16)>=8 then 1 else 0 end as has_oos from w456r_self where id>10 order by id;

drop table w456r_cc;

drop table w456r_cs;

drop table w456r_sc;

drop table w456r_ss;

drop table w456r_ctas;

drop table w456r_self;

drop table w456r_rollback;

drop table w456r_strings;

drop table w456r_fixedcopy;

drop table w456r_fixedclear;

-- cleanup removes all owned classes

select count(*) as remaining from db_class where class_name like 'w456r_%';
