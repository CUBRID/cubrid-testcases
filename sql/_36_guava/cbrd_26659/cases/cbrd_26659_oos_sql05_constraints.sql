/*
 * CBRD-26659 Ticket05: independent immediate transaction/error oracle.
 * Strengthens recovered P07/P08 and the current transaction/bigone units.
 * Noncompressed VARBIT uses distinguishable head/middle/tail hex patterns.
 * Answer sizes, full values and lowercase-hex MD5 were derived outside CUBRID
 * before execution at engine fb567a629cdb390fff920542173fa36f454c74a0.
 * SQL through JDBC proves logical outcomes only. Paired CS physical fixtures
 * are a separate invocation, never observation of this public SQL execution.
 * No vacuum completion, reclaim, chain ownership/reuse, recovery or HA claim.
 */
/*
 * Effective JDBC/CS direct DML unique-error setting defaults to no and copied
 * configuration does not override it: ER_BTREE_UNIQUE_FAILED=-670.
 * Direct server NOT NULL uses ER_NULL_CONSTRAINT_VIOLATION=-631.
 * Table-schema CHECK is parsed but ignored at this revision; it has no
 * enforcement credit. Supported view WITH CHECK OPTION uses ER_PT_EXECUTE
 * (-495). View writes take a client-template path, credited only logically.
 * Positive eligible payloads are separate from rejected NULL payloads.
 */

drop view if exists v_oos05_check;

drop table if exists t_oos05_constraints;

create table t_oos05_constraints (id int primary key, payload bit varying not null, tag bit varying, uniq int unique, required int not null);

insert into t_oos05_constraints values (1,cast(concat(repeat('12', 7001), repeat('34', 6501), repeat('56', 6501)) as bit varying),cast(repeat('11',300) as bit varying),100,1);

insert into t_oos05_constraints values (2,cast(concat(repeat('d1', 1401), repeat('e2', 1403), repeat('f3', 1403)) as bit varying),cast(repeat('22',300) as bit varying),200,2);

evaluate '[TEST 1] positive eligible constraint fixture';

select id, octet_length(payload) as payload_octets, disk_size(payload) as payload_disk, md5(payload) as payload_md5, octet_length(tag) as tag_octets, md5(tag) as tag_md5, uniq, required, case when id=1 and payload=cast(concat(repeat('12', 7001), repeat('34', 6501), repeat('56', 6501)) as bit varying) and tag=cast(repeat('11',300) as bit varying) and uniq=100 and required=1 then 1 when id=2 and payload=cast(concat(repeat('d1', 1401), repeat('e2', 1403), repeat('f3', 1403)) as bit varying) and tag=cast(repeat('22',300) as bit varying) and uniq=200 and required=2 then 1 else 0 end as value_ok from t_oos05_constraints order by id;

select count(*) as row_count from t_oos05_constraints;

evaluate '[TEST 2] rejected PK INSERT preserves all survivors';

insert into t_oos05_constraints values (1,cast(concat(repeat('78', 11001), repeat('9a', 11000), repeat('bc', 11000)) as bit varying),cast(repeat('44',300) as bit varying),300,3);

select id, octet_length(payload) as payload_octets, disk_size(payload) as payload_disk, md5(payload) as payload_md5, octet_length(tag) as tag_octets, md5(tag) as tag_md5, uniq, required, case when id=1 and payload=cast(concat(repeat('12', 7001), repeat('34', 6501), repeat('56', 6501)) as bit varying) and tag=cast(repeat('11',300) as bit varying) and uniq=100 and required=1 then 1 when id=2 and payload=cast(concat(repeat('d1', 1401), repeat('e2', 1403), repeat('f3', 1403)) as bit varying) and tag=cast(repeat('22',300) as bit varying) and uniq=200 and required=2 then 1 else 0 end as value_ok from t_oos05_constraints order by id;

select count(*) as row_count from t_oos05_constraints;

evaluate '[TEST 3] rejected PK UPDATE cancels payload and key changes';

update t_oos05_constraints set id=1,payload=cast(concat(repeat('78', 11001), repeat('9a', 11000), repeat('bc', 11000)) as bit varying) where id=2;

select id, octet_length(payload) as payload_octets, disk_size(payload) as payload_disk, md5(payload) as payload_md5, octet_length(tag) as tag_octets, md5(tag) as tag_md5, uniq, required, case when id=1 and payload=cast(concat(repeat('12', 7001), repeat('34', 6501), repeat('56', 6501)) as bit varying) and tag=cast(repeat('11',300) as bit varying) and uniq=100 and required=1 then 1 when id=2 and payload=cast(concat(repeat('d1', 1401), repeat('e2', 1403), repeat('f3', 1403)) as bit varying) and tag=cast(repeat('22',300) as bit varying) and uniq=200 and required=2 then 1 else 0 end as value_ok from t_oos05_constraints order by id;

select count(*) as row_count from t_oos05_constraints;

evaluate '[TEST 4] rejected secondary UNIQUE INSERT preserves all survivors';

insert into t_oos05_constraints values (3,cast(concat(repeat('78', 11001), repeat('9a', 11000), repeat('bc', 11000)) as bit varying),cast(repeat('44',300) as bit varying),100,3);

select id, octet_length(payload) as payload_octets, disk_size(payload) as payload_disk, md5(payload) as payload_md5, octet_length(tag) as tag_octets, md5(tag) as tag_md5, uniq, required, case when id=1 and payload=cast(concat(repeat('12', 7001), repeat('34', 6501), repeat('56', 6501)) as bit varying) and tag=cast(repeat('11',300) as bit varying) and uniq=100 and required=1 then 1 when id=2 and payload=cast(concat(repeat('d1', 1401), repeat('e2', 1403), repeat('f3', 1403)) as bit varying) and tag=cast(repeat('22',300) as bit varying) and uniq=200 and required=2 then 1 else 0 end as value_ok from t_oos05_constraints order by id;

select count(*) as row_count from t_oos05_constraints;

evaluate '[TEST 5] rejected secondary UNIQUE UPDATE cancels payload and key changes';

update t_oos05_constraints set uniq=100,payload=cast(concat(repeat('78', 11001), repeat('9a', 11000), repeat('bc', 11000)) as bit varying) where id=2;

select id, octet_length(payload) as payload_octets, disk_size(payload) as payload_disk, md5(payload) as payload_md5, octet_length(tag) as tag_octets, md5(tag) as tag_md5, uniq, required, case when id=1 and payload=cast(concat(repeat('12', 7001), repeat('34', 6501), repeat('56', 6501)) as bit varying) and tag=cast(repeat('11',300) as bit varying) and uniq=100 and required=1 then 1 when id=2 and payload=cast(concat(repeat('d1', 1401), repeat('e2', 1403), repeat('f3', 1403)) as bit varying) and tag=cast(repeat('22',300) as bit varying) and uniq=200 and required=2 then 1 else 0 end as value_ok from t_oos05_constraints order by id;

select count(*) as row_count from t_oos05_constraints;

evaluate '[TEST 6] rejected NULL payload INSERT is separate from positive OOS fixture';

insert into t_oos05_constraints values (3,null,cast(repeat('44',300) as bit varying),300,3);

select id, octet_length(payload) as payload_octets, disk_size(payload) as payload_disk, md5(payload) as payload_md5, octet_length(tag) as tag_octets, md5(tag) as tag_md5, uniq, required, case when id=1 and payload=cast(concat(repeat('12', 7001), repeat('34', 6501), repeat('56', 6501)) as bit varying) and tag=cast(repeat('11',300) as bit varying) and uniq=100 and required=1 then 1 when id=2 and payload=cast(concat(repeat('d1', 1401), repeat('e2', 1403), repeat('f3', 1403)) as bit varying) and tag=cast(repeat('22',300) as bit varying) and uniq=200 and required=2 then 1 else 0 end as value_ok from t_oos05_constraints order by id;

select count(*) as row_count from t_oos05_constraints;

evaluate '[TEST 7] rejected NOT NULL UPDATE cancels eligible payload change';

update t_oos05_constraints set required=null,payload=cast(concat(repeat('78', 11001), repeat('9a', 11000), repeat('bc', 11000)) as bit varying) where id=1;

select id, octet_length(payload) as payload_octets, disk_size(payload) as payload_disk, md5(payload) as payload_md5, octet_length(tag) as tag_octets, md5(tag) as tag_md5, uniq, required, case when id=1 and payload=cast(concat(repeat('12', 7001), repeat('34', 6501), repeat('56', 6501)) as bit varying) and tag=cast(repeat('11',300) as bit varying) and uniq=100 and required=1 then 1 when id=2 and payload=cast(concat(repeat('d1', 1401), repeat('e2', 1403), repeat('f3', 1403)) as bit varying) and tag=cast(repeat('22',300) as bit varying) and uniq=200 and required=2 then 1 else 0 end as value_ok from t_oos05_constraints order by id;

select count(*) as row_count from t_oos05_constraints;

evaluate '[TEST 8] last-row PK failure cancels the whole multi-row INSERT';

insert into t_oos05_constraints values (3,cast(concat(repeat('78', 11001), repeat('9a', 11000), repeat('bc', 11000)) as bit varying),cast(repeat('33',300) as bit varying),300,3),(4,cast(concat(repeat('21', 8001), repeat('43', 7501), repeat('65', 7501)) as bit varying),cast(repeat('44',300) as bit varying),400,4),(1,cast(concat(repeat('41', 9001), repeat('63', 8001), repeat('85', 8001)) as bit varying),cast(repeat('55',300) as bit varying),500,5);

select id, octet_length(payload) as payload_octets, disk_size(payload) as payload_disk, md5(payload) as payload_md5, octet_length(tag) as tag_octets, md5(tag) as tag_md5, uniq, required, case when id=1 and payload=cast(concat(repeat('12', 7001), repeat('34', 6501), repeat('56', 6501)) as bit varying) and tag=cast(repeat('11',300) as bit varying) and uniq=100 and required=1 then 1 when id=2 and payload=cast(concat(repeat('d1', 1401), repeat('e2', 1403), repeat('f3', 1403)) as bit varying) and tag=cast(repeat('22',300) as bit varying) and uniq=200 and required=2 then 1 else 0 end as value_ok from t_oos05_constraints order by id;

select count(*) as row_count from t_oos05_constraints;

evaluate '[TEST 9] multi-row UNIQUE failure cancels all payload changes';

update t_oos05_constraints set uniq=900,payload=cast(concat(repeat('78', 11001), repeat('9a', 11000), repeat('bc', 11000)) as bit varying) where id in (1,2);

select id, octet_length(payload) as payload_octets, disk_size(payload) as payload_disk, md5(payload) as payload_md5, octet_length(tag) as tag_octets, md5(tag) as tag_md5, uniq, required, case when id=1 and payload=cast(concat(repeat('12', 7001), repeat('34', 6501), repeat('56', 6501)) as bit varying) and tag=cast(repeat('11',300) as bit varying) and uniq=100 and required=1 then 1 when id=2 and payload=cast(concat(repeat('d1', 1401), repeat('e2', 1403), repeat('f3', 1403)) as bit varying) and tag=cast(repeat('22',300) as bit varying) and uniq=200 and required=2 then 1 else 0 end as value_ok from t_oos05_constraints order by id;

select count(*) as row_count from t_oos05_constraints;

evaluate '[TEST 10] statement failure preserves earlier transaction work and permits follow-up';

autocommit off;

insert into t_oos05_constraints values (3,cast(concat(repeat('78', 11001), repeat('9a', 11000), repeat('bc', 11000)) as bit varying),cast(repeat('33',300) as bit varying),300,3);

update t_oos05_constraints set uniq=999,payload=cast(concat(repeat('41', 9001), repeat('63', 8001), repeat('85', 8001)) as bit varying) where id in (1,2);

select id, octet_length(payload) as payload_octets, disk_size(payload) as payload_disk, md5(payload) as payload_md5, octet_length(tag) as tag_octets, md5(tag) as tag_md5, uniq, required, case when id=1 and payload=cast(concat(repeat('12', 7001), repeat('34', 6501), repeat('56', 6501)) as bit varying) and tag=cast(repeat('11',300) as bit varying) and uniq=100 and required=1 then 1 when id=2 and payload=cast(concat(repeat('d1', 1401), repeat('e2', 1403), repeat('f3', 1403)) as bit varying) and tag=cast(repeat('22',300) as bit varying) and uniq=200 and required=2 then 1 when id=3 and payload=cast(concat(repeat('78', 11001), repeat('9a', 11000), repeat('bc', 11000)) as bit varying) and tag=cast(repeat('33',300) as bit varying) and uniq=300 and required=3 then 1 else 0 end as value_ok from t_oos05_constraints order by id;

select count(*) as row_count from t_oos05_constraints;

update t_oos05_constraints set payload=cast(concat(repeat('89', 12001), repeat('ab', 11001), repeat('cd', 11001)) as bit varying),required=30 where id=3;

commit;

select id, octet_length(payload) as payload_octets, disk_size(payload) as payload_disk, md5(payload) as payload_md5, octet_length(tag) as tag_octets, md5(tag) as tag_md5, uniq, required, case when id=1 and payload=cast(concat(repeat('12', 7001), repeat('34', 6501), repeat('56', 6501)) as bit varying) and tag=cast(repeat('11',300) as bit varying) and uniq=100 and required=1 then 1 when id=2 and payload=cast(concat(repeat('d1', 1401), repeat('e2', 1403), repeat('f3', 1403)) as bit varying) and tag=cast(repeat('22',300) as bit varying) and uniq=200 and required=2 then 1 when id=3 and payload=cast(concat(repeat('89', 12001), repeat('ab', 11001), repeat('cd', 11001)) as bit varying) and tag=cast(repeat('33',300) as bit varying) and uniq=300 and required=30 then 1 else 0 end as value_ok from t_oos05_constraints order by id;

select count(*) as row_count from t_oos05_constraints;

autocommit on;

evaluate '[TEST 11] supported view CHECK OPTION rejection preserves base rows';

create view v_oos05_check as select * from t_oos05_constraints where required>0 with check option;

insert into v_oos05_check values (4,cast(concat(repeat('78', 11001), repeat('9a', 11000), repeat('bc', 11000)) as bit varying),cast(repeat('44',300) as bit varying),400,-1);

select id, octet_length(payload) as payload_octets, disk_size(payload) as payload_disk, md5(payload) as payload_md5, octet_length(tag) as tag_octets, md5(tag) as tag_md5, uniq, required, case when id=1 and payload=cast(concat(repeat('12', 7001), repeat('34', 6501), repeat('56', 6501)) as bit varying) and tag=cast(repeat('11',300) as bit varying) and uniq=100 and required=1 then 1 when id=2 and payload=cast(concat(repeat('d1', 1401), repeat('e2', 1403), repeat('f3', 1403)) as bit varying) and tag=cast(repeat('22',300) as bit varying) and uniq=200 and required=2 then 1 when id=3 and payload=cast(concat(repeat('89', 12001), repeat('ab', 11001), repeat('cd', 11001)) as bit varying) and tag=cast(repeat('33',300) as bit varying) and uniq=300 and required=30 then 1 else 0 end as value_ok from t_oos05_constraints order by id;

select count(*) as row_count from t_oos05_constraints;

update v_oos05_check set required=-1,payload=cast(concat(repeat('41', 9001), repeat('63', 8001), repeat('85', 8001)) as bit varying) where id=1;

select id, octet_length(payload) as payload_octets, disk_size(payload) as payload_disk, md5(payload) as payload_md5, octet_length(tag) as tag_octets, md5(tag) as tag_md5, uniq, required, case when id=1 and payload=cast(concat(repeat('12', 7001), repeat('34', 6501), repeat('56', 6501)) as bit varying) and tag=cast(repeat('11',300) as bit varying) and uniq=100 and required=1 then 1 when id=2 and payload=cast(concat(repeat('d1', 1401), repeat('e2', 1403), repeat('f3', 1403)) as bit varying) and tag=cast(repeat('22',300) as bit varying) and uniq=200 and required=2 then 1 when id=3 and payload=cast(concat(repeat('89', 12001), repeat('ab', 11001), repeat('cd', 11001)) as bit varying) and tag=cast(repeat('33',300) as bit varying) and uniq=300 and required=30 then 1 else 0 end as value_ok from t_oos05_constraints order by id;

select count(*) as row_count from t_oos05_constraints;

insert into v_oos05_check values (4,cast(concat(repeat('d1', 1401), repeat('e2', 1403), repeat('f3', 1403)) as bit varying),cast(repeat('44',300) as bit varying),400,4);

select id, octet_length(payload) as payload_octets, disk_size(payload) as payload_disk, md5(payload) as payload_md5, octet_length(tag) as tag_octets, md5(tag) as tag_md5, uniq, required, case when id=1 and payload=cast(concat(repeat('12', 7001), repeat('34', 6501), repeat('56', 6501)) as bit varying) and tag=cast(repeat('11',300) as bit varying) and uniq=100 and required=1 then 1 when id=2 and payload=cast(concat(repeat('d1', 1401), repeat('e2', 1403), repeat('f3', 1403)) as bit varying) and tag=cast(repeat('22',300) as bit varying) and uniq=200 and required=2 then 1 when id=3 and payload=cast(concat(repeat('89', 12001), repeat('ab', 11001), repeat('cd', 11001)) as bit varying) and tag=cast(repeat('33',300) as bit varying) and uniq=300 and required=30 then 1 when id=4 and payload=cast(concat(repeat('d1', 1401), repeat('e2', 1403), repeat('f3', 1403)) as bit varying) and tag=cast(repeat('44',300) as bit varying) and uniq=400 and required=4 then 1 else 0 end as value_ok from t_oos05_constraints order by id;

select count(*) as row_count from t_oos05_constraints;

evaluate '[TEST 12] constraint schema and cleanup';

select count(*) as attribute_count, sum(case when is_nullable='NO' then 1 else 0 end) as not_null_count from db_attribute where class_name='t_oos05_constraints';

drop view v_oos05_check;

drop table t_oos05_constraints;

select count(*) as fixture_tables from db_class where class_name in ('t_oos05_constraints','v_oos05_check');
