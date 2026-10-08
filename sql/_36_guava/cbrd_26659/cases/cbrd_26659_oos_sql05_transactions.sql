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

autocommit off;

drop table if exists t_oos05_txn;

create table t_oos05_txn (id int primary key, payload bit varying, tag bit varying);

insert into t_oos05_txn values (1,cast(concat(repeat('12', 7001), repeat('34', 6501), repeat('56', 6501)) as bit varying),cast(repeat('11',300) as bit varying));

insert into t_oos05_txn values (2,cast(concat(repeat('aa', 1000), repeat('bb', 1000), repeat('cc', 1000)) as bit varying),cast(repeat('22',300) as bit varying));

insert into t_oos05_txn values (3,cast(concat(repeat('d1', 1401), repeat('e2', 1403), repeat('f3', 1403)) as bit varying),cast(repeat('33',300) as bit varying));

commit;

evaluate '[TEST 1] committed multi-chunk, inline and single-chunk pre-images';

select id, octet_length(payload) as payload_octets, disk_size(payload) as payload_disk, md5(payload) as payload_md5, octet_length(tag) as tag_octets, md5(tag) as tag_md5, case when id=1 and payload=cast(concat(repeat('12', 7001), repeat('34', 6501), repeat('56', 6501)) as bit varying) and tag=cast(repeat('11',300) as bit varying) then 1 when id=2 and payload=cast(concat(repeat('aa', 1000), repeat('bb', 1000), repeat('cc', 1000)) as bit varying) and tag=cast(repeat('22',300) as bit varying) then 1 when id=3 and payload=cast(concat(repeat('d1', 1401), repeat('e2', 1403), repeat('f3', 1403)) as bit varying) and tag=cast(repeat('33',300) as bit varying) then 1 else 0 end as value_ok from t_oos05_txn order by id;

select count(*) as row_count from t_oos05_txn;

evaluate '[TEST 2] INSERT UPDATE DELETE writer state before full ROLLBACK';

insert into t_oos05_txn values (4,cast(concat(repeat('78', 11001), repeat('9a', 11000), repeat('bc', 11000)) as bit varying),cast(repeat('44',300) as bit varying));

update t_oos05_txn set payload=cast(concat(repeat('21', 8001), repeat('43', 7501), repeat('65', 7501)) as bit varying) where id=1;

delete from t_oos05_txn where id=3;

select id, octet_length(payload) as payload_octets, disk_size(payload) as payload_disk, md5(payload) as payload_md5, octet_length(tag) as tag_octets, md5(tag) as tag_md5, case when id=1 and payload=cast(concat(repeat('21', 8001), repeat('43', 7501), repeat('65', 7501)) as bit varying) and tag=cast(repeat('11',300) as bit varying) then 1 when id=2 and payload=cast(concat(repeat('aa', 1000), repeat('bb', 1000), repeat('cc', 1000)) as bit varying) and tag=cast(repeat('22',300) as bit varying) then 1 when id=4 and payload=cast(concat(repeat('78', 11001), repeat('9a', 11000), repeat('bc', 11000)) as bit varying) and tag=cast(repeat('44',300) as bit varying) then 1 else 0 end as value_ok from t_oos05_txn order by id;

select count(*) as row_count from t_oos05_txn;

rollback;

select id, octet_length(payload) as payload_octets, disk_size(payload) as payload_disk, md5(payload) as payload_md5, octet_length(tag) as tag_octets, md5(tag) as tag_md5, case when id=1 and payload=cast(concat(repeat('12', 7001), repeat('34', 6501), repeat('56', 6501)) as bit varying) and tag=cast(repeat('11',300) as bit varying) then 1 when id=2 and payload=cast(concat(repeat('aa', 1000), repeat('bb', 1000), repeat('cc', 1000)) as bit varying) and tag=cast(repeat('22',300) as bit varying) then 1 when id=3 and payload=cast(concat(repeat('d1', 1401), repeat('e2', 1403), repeat('f3', 1403)) as bit varying) and tag=cast(repeat('33',300) as bit varying) then 1 else 0 end as value_ok from t_oos05_txn order by id;

select count(*) as row_count from t_oos05_txn;

evaluate '[TEST 3] DELETE multi-chunk pre-image and restore it with ROLLBACK';

delete from t_oos05_txn where id=1;

select id, octet_length(payload) as payload_octets, disk_size(payload) as payload_disk, md5(payload) as payload_md5, octet_length(tag) as tag_octets, md5(tag) as tag_md5, case when id=2 and payload=cast(concat(repeat('aa', 1000), repeat('bb', 1000), repeat('cc', 1000)) as bit varying) and tag=cast(repeat('22',300) as bit varying) then 1 when id=3 and payload=cast(concat(repeat('d1', 1401), repeat('e2', 1403), repeat('f3', 1403)) as bit varying) and tag=cast(repeat('33',300) as bit varying) then 1 else 0 end as value_ok from t_oos05_txn order by id;

select count(*) as row_count from t_oos05_txn;

rollback;

select id, octet_length(payload) as payload_octets, disk_size(payload) as payload_disk, md5(payload) as payload_md5, octet_length(tag) as tag_octets, md5(tag) as tag_md5, case when id=1 and payload=cast(concat(repeat('12', 7001), repeat('34', 6501), repeat('56', 6501)) as bit varying) and tag=cast(repeat('11',300) as bit varying) then 1 when id=2 and payload=cast(concat(repeat('aa', 1000), repeat('bb', 1000), repeat('cc', 1000)) as bit varying) and tag=cast(repeat('22',300) as bit varying) then 1 when id=3 and payload=cast(concat(repeat('d1', 1401), repeat('e2', 1403), repeat('f3', 1403)) as bit varying) and tag=cast(repeat('33',300) as bit varying) then 1 else 0 end as value_ok from t_oos05_txn order by id;

select count(*) as row_count from t_oos05_txn;

evaluate '[TEST 4] savepoint preserves preceding UPDATE and discards later mixed DML';

update t_oos05_txn set payload=cast(concat(repeat('31', 7001), repeat('53', 7001), repeat('75', 7001)) as bit varying) where id=1;

savepoint oos05_sp;

update t_oos05_txn set payload=cast(concat(repeat('41', 9001), repeat('63', 8001), repeat('85', 8001)) as bit varying) where id=1;

insert into t_oos05_txn values (4,cast(concat(repeat('78', 11001), repeat('9a', 11000), repeat('bc', 11000)) as bit varying),cast(repeat('44',300) as bit varying));

delete from t_oos05_txn where id=3;

select id, octet_length(payload) as payload_octets, disk_size(payload) as payload_disk, md5(payload) as payload_md5, octet_length(tag) as tag_octets, md5(tag) as tag_md5, case when id=1 and payload=cast(concat(repeat('41', 9001), repeat('63', 8001), repeat('85', 8001)) as bit varying) and tag=cast(repeat('11',300) as bit varying) then 1 when id=2 and payload=cast(concat(repeat('aa', 1000), repeat('bb', 1000), repeat('cc', 1000)) as bit varying) and tag=cast(repeat('22',300) as bit varying) then 1 when id=4 and payload=cast(concat(repeat('78', 11001), repeat('9a', 11000), repeat('bc', 11000)) as bit varying) and tag=cast(repeat('44',300) as bit varying) then 1 else 0 end as value_ok from t_oos05_txn order by id;

select count(*) as row_count from t_oos05_txn;

rollback to savepoint oos05_sp;

select id, octet_length(payload) as payload_octets, disk_size(payload) as payload_disk, md5(payload) as payload_md5, octet_length(tag) as tag_octets, md5(tag) as tag_md5, case when id=1 and payload=cast(concat(repeat('31', 7001), repeat('53', 7001), repeat('75', 7001)) as bit varying) and tag=cast(repeat('11',300) as bit varying) then 1 when id=2 and payload=cast(concat(repeat('aa', 1000), repeat('bb', 1000), repeat('cc', 1000)) as bit varying) and tag=cast(repeat('22',300) as bit varying) then 1 when id=3 and payload=cast(concat(repeat('d1', 1401), repeat('e2', 1403), repeat('f3', 1403)) as bit varying) and tag=cast(repeat('33',300) as bit varying) then 1 else 0 end as value_ok from t_oos05_txn order by id;

select count(*) as row_count from t_oos05_txn;

commit;

select id, octet_length(payload) as payload_octets, disk_size(payload) as payload_disk, md5(payload) as payload_md5, octet_length(tag) as tag_octets, md5(tag) as tag_md5, case when id=1 and payload=cast(concat(repeat('31', 7001), repeat('53', 7001), repeat('75', 7001)) as bit varying) and tag=cast(repeat('11',300) as bit varying) then 1 when id=2 and payload=cast(concat(repeat('aa', 1000), repeat('bb', 1000), repeat('cc', 1000)) as bit varying) and tag=cast(repeat('22',300) as bit varying) then 1 when id=3 and payload=cast(concat(repeat('d1', 1401), repeat('e2', 1403), repeat('f3', 1403)) as bit varying) and tag=cast(repeat('33',300) as bit varying) then 1 else 0 end as value_ok from t_oos05_txn order by id;

select count(*) as row_count from t_oos05_txn;

evaluate '[TEST 5] committed mixed DML has the independently intended row set';

insert into t_oos05_txn values (4,cast(concat(repeat('78', 11001), repeat('9a', 11000), repeat('bc', 11000)) as bit varying),cast(repeat('44',300) as bit varying));

update t_oos05_txn set payload=cast(concat(repeat('21', 8001), repeat('43', 7501), repeat('65', 7501)) as bit varying) where id=3;

delete from t_oos05_txn where id=2;

commit;

select id, octet_length(payload) as payload_octets, disk_size(payload) as payload_disk, md5(payload) as payload_md5, octet_length(tag) as tag_octets, md5(tag) as tag_md5, case when id=1 and payload=cast(concat(repeat('31', 7001), repeat('53', 7001), repeat('75', 7001)) as bit varying) and tag=cast(repeat('11',300) as bit varying) then 1 when id=3 and payload=cast(concat(repeat('21', 8001), repeat('43', 7501), repeat('65', 7501)) as bit varying) and tag=cast(repeat('33',300) as bit varying) then 1 when id=4 and payload=cast(concat(repeat('78', 11001), repeat('9a', 11000), repeat('bc', 11000)) as bit varying) and tag=cast(repeat('44',300) as bit varying) then 1 else 0 end as value_ok from t_oos05_txn order by id;

select count(*) as row_count from t_oos05_txn;

evaluate '[TEST 6] fixture and session cleanup';

drop table t_oos05_txn;

commit;

select count(*) as fixture_tables from db_class where class_name='t_oos05_txn';

commit;

autocommit on;
