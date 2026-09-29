--+ holdcas on;
-- workspace#342 (map #312, dpin-16): an index scan carries its B-tree's key domain, and the scan open matches it with
-- the B-tree's root header before the key plan is used. OBJECT keys (the root header keeps OBJECT, the key values are
-- OIDs), partitions, a class hierarchy, and function, unique, primary key and descending indexes, each index scan
-- paired with the same query on USING INDEX NONE. The DROP TABLE statements at the end delete the tables' grants
-- through the single-column OBJECT index of the authorization catalog. Every answer here is develop's.
drop table if exists okc;
drop table if exists okp;
drop table if exists okpt;
drop table if exists okph;
drop table if exists oksub;
drop table if exists oksup;
drop table if exists okf;

-- [OBJECT] a typed and a generic OBJECT column, alone and with another column (a referable class keeps its OIDs)
create table okp (a int primary key, n varchar(10)) dont_reuse_oid;
insert into okp values (1, 'one');
insert into okp values (2, 'two');
insert into okp values (3, 'three');
create table okc (k int, r okp, o object);
insert into okc select a, okp, okp from okp;
insert into okc values (4, null, null);
create index okc_r on okc (r);
create index okc_o on okc (o);
create index okc_rk on okc (r, k);
select k from okc where r = (select okp from okp where a = 2) using index okc_r order by 1;
select k from okc where r = (select okp from okp where a = 2) using index none order by 1;
select k from okc where o in (select okp from okp where a >= 2) using index okc_o order by 1;
select k from okc where o in (select okp from okp where a >= 2) using index none order by 1;
select k from okc where r = (select okp from okp where a = 3) and k > 0 using index okc_rk order by 1;
select k from okc where r = (select okp from okp where a = 3) and k > 0 using index none order by 1;
select k from okc where r is null using index okc_r order by 1;
select k from okc where r is null using index none order by 1;
select c.k, p.n from okp p, okc c where c.r = p and p.a < 3 using index c.okc_r order by 1;
select c.k, p.n from okp p, okc c where c.r = p and p.a < 3 using index none order by 1;

-- [PARTITION] range and hash partitions: each partition's B-tree has its own root header
create table okpt (a int, b varchar(10), c numeric(6,2)) partition by range (a)
  (partition p0 values less than (10), partition p1 values less than maxvalue);
create index okpt_ab on okpt (a, b);
create index okpt_c on okpt (c);
insert into okpt values (1, 'a', 1.5);
insert into okpt values (5, 'b', 2.5);
insert into okpt values (15, 'c', 3.5);
insert into okpt values (25, 'd', 4.5);
select a, b from okpt where a = 15 and b = 'c' using index okpt_ab order by 1;
select a, b from okpt where a = 15 and b = 'c' using index none order by 1;
select a, c from okpt where c > 2 using index okpt_c order by 1;
select a, c from okpt where c > 2 using index none order by 1;
select a from okpt where a between 3 and 20 and b > 'a' using index okpt_ab order by 1;
select a from okpt where a between 3 and 20 and b > 'a' using index none order by 1;
select a from okpt where a = 5.0 and b = 'b' using index okpt_ab order by 1;
select a from okpt where a = 5.0 and b = 'b' using index none order by 1;
create table okph (a int, s varchar(20)) partition by hash (a) partitions 3;
create index okph_s on okph (s);
insert into okph values (1, 'x');
insert into okph values (2, 'y');
insert into okph values (3, 'z');
insert into okph values (4, 'x');
select a from okph where s = 'x' using index okph_s order by 1;
select a from okph where s = 'x' using index none order by 1;
select a from okph where s > 'x' and s < 'zz' using index okph_s order by 1;
select a from okph where s > 'x' and s < 'zz' using index none order by 1;

-- [HIERARCHY] a superclass index scanned over its subclass too
create table oksup (a int, v varchar(10));
create table oksub under oksup (b int);
create index oksup_a on oksup (a);
insert into oksup values (1, 'p');
insert into oksup values (2, 'q');
insert into oksub values (1, 'r', 10);
insert into oksub values (3, 's', 30);
select a, v from all oksup where a = 1 using index oksup_a order by 2;
select a, v from all oksup where a = 1 using index none order by 2;
select a, v from all oksup where a >= 1.5 using index oksup_a order by 1, 2;
select a, v from all oksup where a >= 1.5 using index none order by 1, 2;

-- [KINDS] primary key, unique, function and descending indexes
create table okf (i int, s varchar(30), d datetime, primary key (i));
create unique index okf_s on okf (s);
create index okf_fn on okf (lower (s));
create index okf_desc on okf (d desc, i);
insert into okf values (1, 'Alpha', datetime'2024-01-01 10:00:00');
insert into okf values (2, 'beta', datetime'2024-01-02 10:00:00');
insert into okf values (3, 'Gamma', datetime'2024-01-03 10:00:00');
select i from okf where i = 2.0 using index pk_okf_i order by 1;
select i from okf where i = 2.0 using index none order by 1;
select i from okf where s = 'beta' using index okf_s order by 1;
select i from okf where s = 'beta' using index none order by 1;
select i from okf where lower (s) = 'gamma' using index okf_fn order by 1;
select i from okf where lower (s) = 'gamma' using index none order by 1;
select i from okf where d > '2024-01-01 12:00:00' using index okf_desc order by 1;
select i from okf where d > '2024-01-01 12:00:00' using index none order by 1;
select i from okf where d > date'2024-01-02' and i > 0 using index okf_desc order by 1;
select i from okf where d > date'2024-01-02' and i > 0 using index none order by 1;
select i from okf where d = datetime'2024-01-02 10:00:00' and i = 2.0 using index okf_desc order by 1;
select i from okf where d = datetime'2024-01-02 10:00:00' and i = 2.0 using index none order by 1;

drop table okc;
drop table okp;
drop table okpt;
drop table okph;
drop table oksub;
drop table oksup;
drop table okf;
--+ holdcas off;
commit;
