-- Verification for CBRD-27794
-- Join elimination of a LEFT OUTER JOIN must not treat a unique column as unique
-- when the ON condition converts it to a type where distinct values become equal.
--   1) '7' and '07' are both 7 as a number
--   2) BIGINT values above 2^53 are equal as DOUBLE, and 1e-20 + 1 = 0 + 1 as DOUBLE
--   3) 'a' and 'A' are equal in a case insensitive collation
--   4) a NUMERIC sum with more than 40 digits is rounded
-- Each query is compared with the same query under the NO_ELIMINATE_JOIN hint.

drop table if exists ro, ru, tbl, rn, rk, rt, rq;
create table ro (k int, ks varchar(10), kd double, kd1 double, kn numeric(10,1), kci varchar(10) collate utf8_en_ci, kb bigint);
create table ru (code varchar(10) unique, n int unique, b bigint unique, d double unique, nm numeric(10,2) unique, cs varchar(10) collate utf8_bin unique, cd varchar(10) unique);
insert into ro values (7, '7', 9007199254740992, 1, 1.2, 'a', 1);
insert into ro values (8, '8', 1, 2, 1.3, 'b', 2);
insert into ru values ('7', 7, 9007199254740993, 1e-20, 1.24, 'a', 'a');
insert into ru values ('07', 8, 9007199254740992, 0, 1.15, 'A', 'A');
insert into ru values ('8', 9, 2, 5, 1.31, 'b', 'b');

-- The right-hand table must NOT be removed
evaluate 'Case 1 : varchar unique + 0 = int';
select /*+ recompile */ count(*) from ro o left join ru u on u.code + 0 = o.k;
select /*+ recompile no_eliminate_join */ count(*) from ro o left join ru u on u.code + 0 = o.k;

evaluate 'Case 2 : varchar unique = int (implicit cast)';
select /*+ recompile */ count(*) from ro o left join ru u on u.code = o.k;
select /*+ recompile no_eliminate_join */ count(*) from ro o left join ru u on u.code = o.k;

evaluate 'Case 3 : varchar unique + 0 = constant';
select /*+ recompile */ count(*) from ro o left join ru u on u.code + 0 = 7;
select /*+ recompile no_eliminate_join */ count(*) from ro o left join ru u on u.code + 0 = 7;

evaluate 'Case 4 : bigint unique = double';
select /*+ recompile */ count(*) from ro o left join ru u on u.b = o.kd;
select /*+ recompile no_eliminate_join */ count(*) from ro o left join ru u on u.b = o.kd;

evaluate 'Case 5 : double unique + 1 = double';
select /*+ recompile */ count(*) from ro o left join ru u on u.d + 1 = o.kd1;
select /*+ recompile no_eliminate_join */ count(*) from ro o left join ru u on u.d + 1 = o.kd1;

evaluate 'Case 6 : utf8_bin unique = utf8_en_ci';
select /*+ recompile */ count(*) from ro o left join ru u on u.cs = o.kci;
select /*+ recompile no_eliminate_join */ count(*) from ro o left join ru u on u.cs = o.kci;

evaluate 'Case 7 : utf8_bin unique || x = utf8_en_ci || x';
select /*+ recompile */ count(*) from ro o left join ru u on u.cs || 'x' = o.kci || 'x';
select /*+ recompile no_eliminate_join */ count(*) from ro o left join ru u on u.cs || 'x' = o.kci || 'x';

evaluate 'Case 8 : default collation unique = utf8_en_ci';
select /*+ recompile */ count(*) from ro o left join ru u on u.cd = o.kci;
select /*+ recompile no_eliminate_join */ count(*) from ro o left join ru u on u.cd = o.kci;

-- Same type or exact conversion: the right-hand table can be removed
evaluate 'Case 9 : int unique + 1 = int';
select /*+ recompile */ count(*) from ro o left join ru u on u.n + 1 = o.k;
select /*+ recompile no_eliminate_join */ count(*) from ro o left join ru u on u.n + 1 = o.k;

evaluate 'Case 10 : varchar unique || x = varchar || x';
select /*+ recompile */ count(*) from ro o left join ru u on u.code || 'x' = o.ks || 'x';
select /*+ recompile no_eliminate_join */ count(*) from ro o left join ru u on u.code || 'x' = o.ks || 'x';

evaluate 'Case 11 : numeric unique + 0 = numeric';
select /*+ recompile */ count(*) from ro o left join ru u on u.nm + 0 = o.kn;
select /*+ recompile no_eliminate_join */ count(*) from ro o left join ru u on u.nm + 0 = o.kn;

evaluate 'Case 12 : int unique = varchar (the varchar side is cast)';
select /*+ recompile */ count(*) from ro o left join ru u on u.n = o.ks;
select /*+ recompile no_eliminate_join */ count(*) from ro o left join ru u on u.n = o.ks;

evaluate 'Case 13 : bigint unique = bigint';
select /*+ recompile */ count(*) from ro o left join ru u on u.b = o.kb;
select /*+ recompile no_eliminate_join */ count(*) from ro o left join ru u on u.b = o.kb;

-- CBRD-26415 reproduction
create table tbl (cola int, colb int);
create unique index idx on tbl (cola, colb);
insert into tbl values (1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, null);
evaluate 'Case 14 : mod';
select /*+ recompile */ count(*) from tbl a left outer join tbl b on a.colb = mod(b.colb, 3) and a.cola = b.cola;

evaluate 'Case 15 : numeric(38,38) unique + 38 digits = numeric(38,0) (rounded sum)';
create table rn (n numeric(38,38) unique);
insert into rn values (0.0001), (0.0002);
create table rk (k numeric(38,0));
insert into rk values (10000000000000000000000000000000000000);
select /*+ recompile */ count(*) from rk o left join rn u on u.n + 10000000000000000000000000000000000000 = o.k;
select /*+ recompile no_eliminate_join */ count(*) from rk o left join rn u on u.n + 10000000000000000000000000000000000000 = o.k;

-- Conversions that keep every value: the right-hand table can be removed, except INT to FLOAT
create table rt (dte date unique, f float unique, s smallint unique, i int unique);
create table rq (kdt datetime, kd double, kf float);
insert into rt values (date'2020-01-01', 0.1, 1, 16777216);
insert into rt values (date'2020-01-02', 0.2, 2, 16777217);
insert into rq values (datetime'2020-01-01 00:00:00', cast(cast(0.1 as float) as double), 16777216);
insert into rq values (datetime'2020-01-02 00:00:00', 2, 2);

evaluate 'Case 16 : date unique = datetime';
select /*+ recompile */ count(*) from rq o left join rt u on u.dte = o.kdt;
select /*+ recompile no_eliminate_join */ count(*) from rq o left join rt u on u.dte = o.kdt;

evaluate 'Case 17 : float unique = double';
select /*+ recompile */ count(*) from rq o left join rt u on u.f = o.kd;
select /*+ recompile no_eliminate_join */ count(*) from rq o left join rt u on u.f = o.kd;

evaluate 'Case 18 : smallint unique = float';
select /*+ recompile */ count(*) from rq o left join rt u on u.s = o.kf;
select /*+ recompile no_eliminate_join */ count(*) from rq o left join rt u on u.s = o.kf;

evaluate 'Case 19 : int unique = float (2^24 and 2^24 + 1 are equal as FLOAT, the join is kept)';
select /*+ recompile */ count(*) from rq o left join rt u on u.i = o.kf;
select /*+ recompile no_eliminate_join */ count(*) from rq o left join rt u on u.i = o.kf;

drop table if exists ro, ru, tbl, rn, rk, rt, rq;
