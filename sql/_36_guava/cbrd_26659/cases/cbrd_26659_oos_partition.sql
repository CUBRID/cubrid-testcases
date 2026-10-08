/* Ticket08 R15 logical routing/movement/reorganization only. Exact bytes are independently modeled; the separate correct destination-owner regression retains CBRD-27089 without converting logical equality into ownership credit. */

drop table if exists oos08_part;
create table oos08_part(id int primary key,payload bit varying) partition by range(id)(partition p0 values less than(10),partition p1 values less than maxvalue);
insert into oos08_part values(1,cast(repeat('a1',5000) as bit varying)),(11,cast(repeat('b2',4600) as bit varying));
select id,octet_length(payload) as octets,md5(payload) as digest from oos08_part order by id;
update oos08_part set id=12 where id=1;
select id,octet_length(payload) as octets,md5(payload) as digest from oos08_part order by id;
alter table oos08_part reorganize partition p1 into(partition p1a values less than(12),partition p1b values less than maxvalue);
select count(*) as exact_rows from oos08_part where (id=11 and payload=cast(repeat('b2',4600) as bit varying)) or (id=12 and payload=cast(repeat('a1',5000) as bit varying));
insert into oos08_part values(12,cast(repeat('ff',6000) as bit varying));
select count(*) as exact_rows from oos08_part where (id=11 and payload=cast(repeat('b2',4600) as bit varying)) or (id=12 and payload=cast(repeat('a1',5000) as bit varying));
drop table oos08_part;
