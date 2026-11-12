/* CBRD-26659 Ticket03: representation and the strict serialized profitability floor.
 * SQL verifies logical values only; delivered shell observes separate physical fixtures.
 * VARBIT serialized length is ALIGN(prefix + CEIL(bits/8),4), prefix1 below255 bits,
 * otherwise prefix5. Stub/chunk header are24B; FORCE_OUTLINE retains the strict >24B floor.
 * Independently derived answers: no captured engine output. Default JDBC autocommit.
 * Unequal 3000/1200B candidates require only the 3008B serialized value to demote.
 * The comparator is1000/500B; both layouts are away from CBRD-27057's disputed band.
 */

drop table if exists t03_largest;
drop table if exists t03_inline;
drop table if exists t03_floor;
drop table if exists t03_text_floor;
create table t03_largest (id int primary key, larger bit varying, smaller bit varying);
insert into t03_largest values (1,cast(repeat('a1',3000) as bit varying),cast(repeat('b2',1200) as bit varying));
select id, disk_size(larger) as larger_disk, disk_size(smaller) as smaller_disk, md5(larger) as larger_md5, md5(smaller) as smaller_md5, larger=cast(repeat('a1',3000) as bit varying) as larger_ok, smaller=cast(repeat('b2',1200) as bit varying) as smaller_ok from t03_largest order by id;
create table t03_inline (id int primary key, larger bit varying, smaller bit varying);
insert into t03_inline values (1,cast(repeat('a1',1000) as bit varying),cast(repeat('b2',500) as bit varying));
select id, disk_size(larger) as larger_disk, disk_size(smaller) as smaller_disk, md5(larger) as larger_md5, md5(smaller) as smaller_md5, larger=cast(repeat('a1',1000) as bit varying) as larger_ok, smaller=cast(repeat('b2',500) as bit varying) as smaller_ok from t03_inline order by id;
create table t03_floor (id int primary key, payload bit varying storage force_outline);
insert into t03_floor values
  (1,NULL),
  (2,X''),
  (3,cast(repeat('31',19) as bit varying)),
  (4,cast(repeat('42',20) as bit varying)),
  (5,cast(repeat('53',23) as bit varying)),
  (6,cast(repeat('64',24) as bit varying)),
  (7,B'10101'),
  (8,cast(concat(repeat('a1',4200),'a') as bit varying(33603)));
select id, bit_length(payload) as payload_bits, disk_size(payload) as payload_disk, case when payload is null then 1 else 0 end as is_null from t03_floor order by id;
select count(*) as row_count, sum(case when id=1 and payload is null then 1 when id=2 and payload=X'' then 1 when id=3 and payload=cast(repeat('31',19) as bit varying) then 1 when id=4 and payload=cast(repeat('42',20) as bit varying) then 1 when id=5 and payload=cast(repeat('53',23) as bit varying) then 1 when id=6 and payload=cast(repeat('64',24) as bit varying) then 1 when id=7 and payload=B'10101' then 1 when id=8 and payload=cast(concat(repeat('a1',4200),'a') as bit varying(33603)) then 1 else 0 end) as value_ok from t03_floor;
create table t03_text_floor (id int primary key, payload varchar(100) storage force_outline);
insert into t03_text_floor values (1,repeat('z',22)),(2,repeat('w',23)),(3,NULL),(4,'');
select id, char_length(payload) as payload_chars, disk_size(payload) as payload_disk from t03_text_floor order by id;
select count(*) as row_count, sum(case when (id=1 and payload=repeat('z',22)) or (id=2 and payload=repeat('w',23)) or (id=3 and payload is null) or (id=4 and payload='') then 1 else 0 end) as value_ok from t03_text_floor;
drop table t03_largest;
drop table t03_inline;
drop table t03_floor;
drop table t03_text_floor;
select count(*) as fixture_tables from db_class where class_name in ('t03_largest','t03_inline','t03_floor','t03_text_floor');
