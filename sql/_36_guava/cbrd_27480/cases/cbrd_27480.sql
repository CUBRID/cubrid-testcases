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

drop table t_fkc;
drop table t_pkc;
drop table t_fk;
drop table t_pk;
