-- ============================================
-- EXTENDED TESTS - INVISIBLE COLUMN
-- Range/List Partition / Column Order / Triggers
-- ============================================

-- NOTE:
-- These are additional test cases intended to supplement interactions
-- with surrounding features that were not covered in the existing tests 01–08.


-- ============================================
-- [1] RANGE / LIST PARTITION WITH INVISIBLE COLUMNS
-- ============================================

set trace on;

drop table if exists ip_range;
drop table if exists ip_list;

-- RANGE partition, partition key is INVISIBLE
create table ip_range (
    id int auto_increment invisible,
    pkey int invisible,
    v1 int
) 
partition by range (pkey) (
    partition p0 values less than (10),
    partition p1 values less than (20),
    partition p2 values less than maxvalue
);

create index idx_ip_range_id_pkey on ip_range (id,pkey);

insert into ip_range (pkey, v1) values
    (5,  100),
    (9,  101),
    (10, 200),
    (15, 201),
    (25, 300);

update statistics on ip_range;

-- partition pruning check (p0)
select v1 from ip_range where pkey < 10 order by v1;
show trace;

-- partition pruning check (p1)
select v1 from ip_range where pkey >= 10 and pkey < 20 order by v1;
show trace;

-- partition pruning check (p2)
select v1 from ip_range where pkey >= 20 order by v1;
show trace;

-- err: cannot drop invisible partition key column
/* err */ alter table ip_range drop column pkey;

-- remove partitioning and ensure structure is preserved
alter table ip_range remove partitioning;
desc ip_range;

update statistics on ip_range;

select id, pkey, v1 from ip_range order by id;
show trace;

drop table if exists ip_range;


-- LIST partition, partition key is INVISIBLE
create table ip_list (
    id int auto_increment invisible,
    region varchar(10) invisible,
    val int
)
partition by list (region) (
    partition kr values in ('KR'),
    partition us values in ('US'),
    partition etc values in ('JP', 'CN', 'ETC')
);

create index idx_ip_list_id_region on ip_list (id,region);


insert into ip_list (region, val) values
    ('KR', 1),
    ('US', 2),
    ('JP', 3),
    ('CN', 4),
    ('ETC', 5);

update statistics on ip_list;

select val from ip_list where id < 3 and region = 'KR' order by val;
show trace;
select val from ip_list where region in ('JP', 'CN') order by val;
show trace;

alter table ip_list remove partitioning;

alter table ip_list drop column region;

desc ip_list;

update statistics on ip_list;


select id, region, val from ip_list order by id;
show trace;

drop table if exists ip_list;


-- ============================================
-- [2] COLUMN ORDER / MULTI-COLUMN ALTER
-- ============================================

drop table if exists col_order;

create table col_order (
    c1 int,
    c2 int invisible,
    c3 int,
    c4 int invisible
);

-- initial order check
desc col_order;

-- add visible column after invisible
alter table col_order add column c5 int after c2;
desc col_order;

-- move invisible column using CHANGE ... AFTER ...
alter table col_order change column c4 c4 int invisible after c1;
desc col_order;

-- multi-column ALTER: change visibility and order together
alter table col_order 
    modify column c1 int invisible,
    modify column c3 int visible;

desc col_order;

drop table if exists col_order;


-- ============================================
-- [3] TRIGGERS WITH INVISIBLE COLUMNS (UPDATE/DELETE)
-- ============================================

drop table if exists ip_trg;

create table ip_trg (
    id int auto_increment invisible primary key,
    val int,
    mod_count int invisible default 0
);

insert into ip_trg(val) values (10), (20), (30);

-- BEFORE DELETE trigger: prevent delete when invisible counter is 0
create trigger ip_trg_bd before delete on ip_trg
    if obj.mod_count = 0 execute reject;

-- err: first row has mod_count = 0, delete must be rejected
/* err */ delete from ip_trg where id = 1;

-- rows with mod_count > 0 can be deleted
delete from ip_trg where mod_count > 0;
select id, val, mod_count from ip_trg order by id;

drop trigger ip_trg_bd;
drop table if exists ip_trg;


-- ============================================
-- END OF FILE
-- ============================================

