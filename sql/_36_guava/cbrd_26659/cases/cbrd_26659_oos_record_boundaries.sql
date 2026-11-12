-- Work456/12: exact 16KiB physical-record and B-tree key neighbors.
-- Independent logical invocation. Per-row flags/owner/key-overflow evidence
-- belongs to the separate contained shell fixtures, not this JDBC execution.
-- Source formulas: 16112 fixed bytes +124 max-MVCC/layout/stubs =16236;
-- next input byte16113 ->16237 rejects ER_HEAP_OOS_OVERPASS_MAXOBJ_SIZE -1384.
-- Index VARBIT uses unaligned N+5 bytes:2037/2038 ->2042/2043.
-- Both supported key sizes must succeed; crossing2043 is overflow, not rejection.
-- Full equality compares every input byte, including different halves/tails.
drop table if exists r12_at;

drop table if exists r12_next;

drop table if exists r12_keys;

create table r12_at(id int,note int,ballast bit(128896),c1 bit varying,c2 bit varying,c3 bit varying);

insert into r12_at values(1,101,B'1',cast(concat(repeat('31',500),repeat('32',498),'3334') as bit varying),cast(concat(repeat('44',550),repeat('45',548),'4647') as bit varying),cast(concat(repeat('57',600),repeat('58',598),'595a') as bit varying));

select count(*) as n,sum(case when id=1 and note=101 and ballast=cast(B'1' as bit(128896)) and c1=cast(concat(repeat('31',500),repeat('32',498),'3334') as bit varying) and c2=cast(concat(repeat('44',550),repeat('45',548),'4647') as bit varying) and c3=cast(concat(repeat('57',600),repeat('58',598),'595a') as bit varying) then 1 else 0 end) as exact_rows from r12_at;

create table r12_next(id int,note int,ballast bit(128904),c1 bit varying,c2 bit varying,c3 bit varying);

insert into r12_next values(2,202,B'0',cast(concat(repeat('31',500),repeat('32',498),'3334') as bit varying),cast(concat(repeat('44',550),repeat('45',548),'4647') as bit varying),cast(concat(repeat('57',600),repeat('58',598),'595a') as bit varying));

select count(*) as n from r12_next;

create table r12_keys(id int primary key,note int,k bit varying storage force_outline);

insert into r12_keys values(1,101,cast(concat(repeat('31',1018),repeat('32',1017),'3334') as bit varying));

insert into r12_keys values(2,202,cast(concat(repeat('31',1019),repeat('32',1017),'3334') as bit varying));

insert into r12_keys values(3,303,cast(concat(repeat('31',2553),repeat('32',2552),'3334') as bit varying));

create unique index r12_keys_k on r12_keys(k);

select id,octet_length(k) as octets,case when (id=1 and note=101 and k=cast(concat(repeat('31',1018),repeat('32',1017),'3334') as bit varying)) or (id=2 and note=202 and k=cast(concat(repeat('31',1019),repeat('32',1017),'3334') as bit varying)) or (id=3 and note=303 and k=cast(concat(repeat('31',2553),repeat('32',2552),'3334') as bit varying)) then 1 else 0 end as exact_value from r12_keys order by id;

drop table r12_at;

drop table r12_next;

drop table r12_keys;
