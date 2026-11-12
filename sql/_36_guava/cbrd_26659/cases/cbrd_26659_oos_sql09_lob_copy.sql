-- CBRD-26659 Ticket09: external LOB contents and copy independence.
-- Reuses P02 4200/3000B VARBIT,300B tag,four64B BLOBs and31B CLOBs.
-- Every value is checked in the destination after source DELETE and DROP.
-- Independently prepared lowercase hexadecimal MD5 and ASCII MD5 literals
-- are in the answer. Equality checks cover all contents, including every tail.
-- A separate two-locator FORCE_OUTLINE fixture exercises accepted eligibility
-- without a large VARBIT candidate. SQL output is logical only. The private
-- cbrd_26659_lob_locators companion independently observes physical locators.
-- Locator bytes demote, external payload files remain LOB-layer owned (ADR0002).
-- Native attempt owns the DB/lob tree and removes it on normal/failed cleanup.

drop table if exists t_oos09_ncopy;

drop table if exists t_oos09_neighbor;

drop table if exists t_oos09_lcopy;

drop table if exists t_oos09_locator;

create table t_oos09_neighbor (id int primary key,payload bit varying,tag bit varying,b1 blob,b2 blob,b3 blob,b4 blob,c1 clob);

create table t_oos09_ncopy (id int primary key,payload bit varying,tag bit varying,b1 blob,b2 blob,b3 blob,b4 blob,c1 clob);

insert into t_oos09_neighbor values (1,cast(repeat('a',8400) as bit varying),cast(repeat('b',600) as bit varying),bit_to_blob(cast(repeat('a1',64) as bit varying)),bit_to_blob(cast(repeat('b2',64) as bit varying)),bit_to_blob(cast(repeat('c3',64) as bit varying)),bit_to_blob(cast(repeat('d4',64) as bit varying)),char_to_clob('cbrd-26659-oos-clob-neighbour-1'));

insert into t_oos09_neighbor values (2,cast(repeat('c',6000) as bit varying),cast(repeat('d',600) as bit varying),bit_to_blob(cast(repeat('a1',64) as bit varying)),bit_to_blob(cast(repeat('b2',64) as bit varying)),bit_to_blob(cast(repeat('c3',64) as bit varying)),bit_to_blob(cast(repeat('d4',64) as bit varying)),char_to_clob('cbrd-26659-oos-clob-neighbour-2'));

select id, octet_length(payload) as payload_octets, md5(payload) as payload_md5,
       payload=cast(repeat(case id when 1 then 'a' else 'c' end,case id when 1 then 8400 else 6000 end) as bit varying) as payload_ok,
       tag=cast(repeat(case id when 1 then 'b' else 'd' end,600) as bit varying) as tag_ok,
       blob_to_bit(b1)=cast(repeat('a1',64) as bit varying) as b1_ok,
       blob_to_bit(b2)=cast(repeat('b2',64) as bit varying) as b2_ok,
       blob_to_bit(b3)=cast(repeat('c3',64) as bit varying) as b3_ok,
       blob_to_bit(b4)=cast(repeat('d4',64) as bit varying) as b4_ok,
       clob_to_char(c1)=concat('cbrd-26659-oos-clob-neighbour-',cast(id as varchar(2))) as c1_ok,
       md5(blob_to_bit(b1)) as b1_md5, md5(blob_to_bit(b2)) as b2_md5,
       md5(blob_to_bit(b3)) as b3_md5, md5(blob_to_bit(b4)) as b4_md5,
       md5(clob_to_char(c1)) as c1_md5 from t_oos09_neighbor order by id;

insert into t_oos09_ncopy select * from t_oos09_neighbor;

delete from t_oos09_neighbor;

select count(*) as source_rows from t_oos09_neighbor;

drop table t_oos09_neighbor;

select id, octet_length(payload) as payload_octets, md5(payload) as payload_md5,
       payload=cast(repeat(case id when 1 then 'a' else 'c' end,case id when 1 then 8400 else 6000 end) as bit varying) as payload_ok,
       tag=cast(repeat(case id when 1 then 'b' else 'd' end,600) as bit varying) as tag_ok,
       blob_to_bit(b1)=cast(repeat('a1',64) as bit varying) as b1_ok,
       blob_to_bit(b2)=cast(repeat('b2',64) as bit varying) as b2_ok,
       blob_to_bit(b3)=cast(repeat('c3',64) as bit varying) as b3_ok,
       blob_to_bit(b4)=cast(repeat('d4',64) as bit varying) as b4_ok,
       clob_to_char(c1)=concat('cbrd-26659-oos-clob-neighbour-',cast(id as varchar(2))) as c1_ok,
       md5(blob_to_bit(b1)) as b1_md5, md5(blob_to_bit(b2)) as b2_md5,
       md5(blob_to_bit(b3)) as b3_md5, md5(blob_to_bit(b4)) as b4_md5,
       md5(clob_to_char(c1)) as c1_md5 from t_oos09_ncopy order by id;

create table t_oos09_locator (id int primary key,b blob storage force_outline,c clob storage force_outline);

create table t_oos09_lcopy (id int primary key,b blob storage force_outline,c clob storage force_outline);

insert into t_oos09_locator values (1,bit_to_blob(cast(repeat('010203a1',17) as bit varying)),char_to_clob('OOS09-CLOB-A-head-middle-tail'));

insert into t_oos09_locator values (2,bit_to_blob(cast(repeat('f0e0d0b2',17) as bit varying)),char_to_clob('OOS09-CLOB-B-HEAD-MIDDLE-TAIL'));

insert into t_oos09_lcopy select * from t_oos09_locator;

select id,blob_length(b) as blob_octets,clob_length(c) as clob_octets,
       blob_to_bit(b)=cast(repeat(case id when 1 then '010203a1' else 'f0e0d0b2' end,17) as bit varying) as blob_ok,
       clob_to_char(c)=case id when 1 then 'OOS09-CLOB-A-head-middle-tail' else 'OOS09-CLOB-B-HEAD-MIDDLE-TAIL' end as clob_ok,
       md5(blob_to_bit(b)) as blob_md5,md5(clob_to_char(c)) as clob_md5 from t_oos09_lcopy order by id;

delete from t_oos09_locator;

drop table t_oos09_locator;

select id,blob_length(b) as blob_octets,clob_length(c) as clob_octets,
       blob_to_bit(b)=cast(repeat(case id when 1 then '010203a1' else 'f0e0d0b2' end,17) as bit varying) as blob_ok,
       clob_to_char(c)=case id when 1 then 'OOS09-CLOB-A-head-middle-tail' else 'OOS09-CLOB-B-HEAD-MIDDLE-TAIL' end as clob_ok,
       md5(blob_to_bit(b)) as blob_md5,md5(clob_to_char(c)) as clob_md5 from t_oos09_lcopy order by id;

drop table t_oos09_ncopy;

drop table t_oos09_lcopy;

select count(*) as remaining_tables from db_class where class_name in ('t_oos09_neighbor','t_oos09_ncopy','t_oos09_locator','t_oos09_lcopy');
