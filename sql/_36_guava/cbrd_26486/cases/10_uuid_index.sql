/**
 *  This test case verifies CBRD-26572: Support UUID()/SYS_GUID() built-in functions.
 *
 *  NOTE: Generated UUID values differ on every execution, so raw values must
 *  never appear in the answer. All checks are derived and deterministic.
 */


evaluate '[TEST 1] UUID(7) column with UNIQUE index';
drop table if exists uuid_idx_t;
create table uuid_idx_t (k int auto_increment primary key, u bit(128) default uuid(7), v int);
create unique index idx_uuid_u on uuid_idx_t(u);
insert into uuid_idx_t(v) select rownum from db_class a join db_class b limit 600;
select count(*) total, count(distinct u) uniq from uuid_idx_t;
-- index lookup: exactly one row matches the minimum UUID value
select count(*) as u_found from uuid_idx_t where u = (select min(u) from uuid_idx_t);

evaluate '[TEST 1.1] UNIQUE index rejects duplicate UUID';
-- insert a row whose UUID value already exists -> UNIQUE constraint violation
/* error */ insert into uuid_idx_t(u, v) select u, 999 from uuid_idx_t where k = 1;
select count(*) still_100 from uuid_idx_t;

evaluate '[TEST 1.2] non-unique index on UUID column';
drop index idx_uuid_u on uuid_idx_t;
create index idx_uuid_nu on uuid_idx_t(u);
insert into uuid_idx_t(v) values (200);
select count(*) total from uuid_idx_t;
-- range scan covering all rows: min(u) to max(u) must include every row
select count(*) range_cnt
from uuid_idx_t
where u >= (select min(u) from uuid_idx_t)
and u <= (select max(u) from uuid_idx_t);
drop table uuid_idx_t;