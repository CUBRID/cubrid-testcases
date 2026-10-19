/*
 * CBRD-27480: the composite FK-PK join selectivity floor (CBRD-27186) must also apply
 * when some FK columns are fixed to the same constant on both sides instead of joined.
 */
drop table if exists t_fk;
drop table if exists t_pk;

create table t_pk (region varchar(8), id int, primary key (region, id));
insert into t_pk values ('KR', 1), ('US', 2), ('US', 3), ('US', 4);

create table t_fk (fid int, region varchar(8), id int, foreign key (region, id) references t_pk (region, id));
insert into t_fk values (1, 'KR', 1), (2, 'KR', 1), (3, 'KR', 1), (4, 'US', 2), (5, 'US', 3), (6, 'US', 4);

update statistics on t_pk, t_fk with fullscan;

evaluate '[1] both sides fixed to the same constant: count = 3';
--@queryplan
select /*+ recompile */ count(*), max(t_pk.region) from t_fk, t_pk
where t_fk.id = t_pk.id and t_fk.region = 'KR' and t_pk.region = 'KR';

evaluate '[2] join term plus a constant on one side: count = 3';
--@queryplan
select /*+ recompile */ count(*), max(t_pk.region) from t_fk, t_pk
where t_fk.region = t_pk.region and t_fk.id = t_pk.id and t_fk.region = 'KR';

evaluate '[3] different constants on each side, floor not applied: count = 0';
--@queryplan
select /*+ recompile */ count(*), max(t_pk.region) from t_fk, t_pk
where t_fk.id = t_pk.id and t_fk.region = 'KR' and t_pk.region = 'US';

evaluate '[4] trailing space differs in a VARCHAR column, floor not applied: count = 0';
--@queryplan
select /*+ recompile */ count(*), max(t_pk.region) from t_fk, t_pk
where t_fk.id = t_pk.id and t_fk.region = 'KR ' and t_pk.region = 'KR';

evaluate '[5] constant longer than the column, floor not applied: count = 0';
--@queryplan
select /*+ recompile */ count(*), max(t_pk.region) from t_fk, t_pk
where t_fk.id = t_pk.id and t_fk.region = 'KRKRKRKRKR' and t_pk.region = 'KRKRKRKRKR';

evaluate '[6] pk constant in the ON condition of a left join, floor not applied: count = 3';
--@queryplan
select /*+ recompile */ count(*), max(t_pk.region) from t_fk left outer join t_pk
on t_fk.id = t_pk.id and t_pk.region = 'KR' where t_fk.region = 'KR';

drop table if exists t_fkc;
drop table if exists t_pkc;

create table t_pkc (region char(4), id int, primary key (region, id));
insert into t_pkc values ('KR', 1), ('US', 2);

create table t_fkc (fid int, region char(4), id int, foreign key (region, id) references t_pkc (region, id));
insert into t_fkc values (1, 'KR', 1), (2, 'KR', 1), (3, 'US', 2);

update statistics on t_pkc, t_fkc with fullscan;

evaluate '[7] trailing space is ignored in a CHAR column: count = 2';
--@queryplan
select /*+ recompile */ count(*), max(t_pkc.region) from t_fkc, t_pkc
where t_fkc.id = t_pkc.id and t_fkc.region = 'KR ' and t_pkc.region = 'KR';

/*
 * [8]-[12] check the plan instead of the count: cost and card are masked in the answer,
 * so the join order shows whether the floor raised the FK-PK join estimate.
 * Each PK table has 2,000 rows in 100 regions and each FK table 20,000 rows; the region
 * constant keeps 200 FK rows, but without the floor the FK-PK join is estimated at 2 rows.
 * t_x keeps 60 rows. With the floor (200 rows) t_x drives the join; without it the
 * FK-PK join drives it and probes t_x.
 */
drop table if exists t_x;
drop table if exists t_fkv;
drop table if exists t_pkv;
drop table if exists t_fkch;
drop table if exists t_pkch;

create table t_pkv (region varchar(8), id int, pad varchar(20), primary key (region, id));
insert into t_pkv select 'R' || mod (level, 100), level, 'p' || level from db_root connect by level <= 2000;
create table t_fkv (fid int primary key, region varchar(8), id int, foreign key (region, id) references t_pkv (region, id));
insert into t_fkv select level, 'R' || mod (mod (level, 2000) + 1, 100), mod (level, 2000) + 1 from db_root connect by level <= 20000;

create table t_pkch (region char(4), id int, pad varchar(20), primary key (region, id));
insert into t_pkch select region, id, pad from t_pkv;
create table t_fkch (fid int primary key, region char(4), id int, foreign key (region, id) references t_pkch (region, id));
insert into t_fkch select fid, region, id from t_fkv;

create table t_x (k int primary key, v int, w int);
insert into t_x select level, mod (level, 100), mod (level / 100, 10) from db_root connect by level <= 20000;
create index ix_x_vw on t_x (v, w);

update statistics on t_pkv, t_fkv, t_pkch, t_fkch, t_x with fullscan;

evaluate '[8] both sides fixed to the same constant, t_x drives the join: count = 60';
--@queryplan
select /*+ recompile */ count(*), max(t_pkv.pad) from t_fkv, t_pkv, t_x
where t_fkv.id = t_pkv.id and t_fkv.region = 'R5' and t_pkv.region = 'R5'
and t_x.k = t_fkv.fid and t_x.v = 4 and t_x.w < 3;

evaluate '[9] join term plus a constant on one side, t_x drives the join: count = 60';
--@queryplan
select /*+ recompile */ count(*), max(t_pkv.pad) from t_fkv, t_pkv, t_x
where t_fkv.region = t_pkv.region and t_fkv.id = t_pkv.id and t_fkv.region = 'R5'
and t_x.k = t_fkv.fid and t_x.v = 4 and t_x.w < 3;

evaluate '[10] trailing space is ignored in a CHAR column, t_x drives the join: count = 60';
--@queryplan
select /*+ recompile */ count(*), max(t_pkch.pad) from t_fkch, t_pkch, t_x
where t_fkch.id = t_pkch.id and t_fkch.region = 'R5 ' and t_pkch.region = 'R5'
and t_x.k = t_fkch.fid and t_x.v = 4 and t_x.w < 3;

evaluate '[11] different constants on each side, floor not applied, t_x is probed: count = 0';
--@queryplan
select /*+ recompile */ count(*), max(t_pkv.pad) from t_fkv, t_pkv, t_x
where t_fkv.id = t_pkv.id and t_fkv.region = 'R5' and t_pkv.region = 'R6'
and t_x.k = t_fkv.fid and t_x.v = 4 and t_x.w < 3;

evaluate '[12] trailing space differs in a VARCHAR column, floor not applied, t_x is probed: count = 0';
--@queryplan
select /*+ recompile */ count(*), max(t_pkv.pad) from t_fkv, t_pkv, t_x
where t_fkv.id = t_pkv.id and t_fkv.region = 'R5 ' and t_pkv.region = 'R5'
and t_x.k = t_fkv.fid and t_x.v = 4 and t_x.w < 3;

drop table t_x;
drop table t_fkch;
drop table t_pkch;
drop table t_fkv;
drop table t_pkv;
drop table t_fkc;
drop table t_pkc;
drop table t_fk;
drop table t_pk;
