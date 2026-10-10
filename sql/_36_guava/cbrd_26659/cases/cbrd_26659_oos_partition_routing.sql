-- Ticket08 supported partition SQL subset: creation/routing/read/duplicate rejection.
-- Exact independent values; no movement/reorganization/destination-owner credit.
-- Full intended movement/reorganization remains cbrd_26659_oos_partition.sql.

drop table if exists oos08_route_sql;
create table oos08_route_sql(id int primary key,payload bit varying) partition by range(id)(partition p0 values less than(10),partition p1 values less than maxvalue);
insert into oos08_route_sql values(1,cast(repeat('a1',5000) as bit varying)),(11,cast(repeat('b2',4600) as bit varying));
select id,octet_length(payload) as octets,md5(payload) as digest from oos08_route_sql order by id;
insert into oos08_route_sql values(11,cast(repeat('ff',6000) as bit varying));
select count(*) as exact_rows from oos08_route_sql where (id=1 and payload=cast(repeat('a1',5000) as bit varying)) or (id=11 and payload=cast(repeat('b2',4600) as bit varying));
drop table oos08_route_sql;
