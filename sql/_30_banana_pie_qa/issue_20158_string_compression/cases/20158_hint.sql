--+ holdcas on;

-- INDEX_SS
drop table if exists t1;

drop table if exists t2;

CREATE TABLE t1 (id int PRIMARY KEY, a string, b string, c string);

CREATE TABLE t2 (id int PRIMARY KEY, a string, b string, c string);

CREATE INDEX i_t1_ac ON t1(a,c);

CREATE INDEX i_t2_ac ON t2(a,c);

insert into t1 values (1, repeat('a',300), repeat('b',300), repeat('c',300));

insert into t1 values (2, repeat('a',300), repeat('b',300), repeat('c',300));

insert into t1 values (3, repeat('a',300), repeat('b',300), repeat('c',300));

insert into t2 values (10, repeat('a1',300), repeat('b1',300), repeat('c',300));

insert into t2 values (11, repeat('a1',300), repeat('b1',300), repeat('c',300));

insert into t2 values (12, repeat('a1',300), repeat('b1',300), repeat('c',300));


SELECT /*+ recompile INDEX_SS */ * FROM t1, t2 WHERE t1.b<'d' AND t1.c<'m' AND t2.c<'m' USING INDEX i_t1_ac, i_t2_ac order by t1.id,t2.id limit 1;

SELECT /*+ recompile INDEX_SS(t1) */ * FROM t1, t2 WHERE t1.b<'d' AND t1.c<'m' AND t2.c<'m' USING INDEX i_t1_ac, i_t2_ac order by t1.id,t2.id limit 1;

SELECT /*+ recompile INDEX_SS(t1,t2) */ * FROM t1, t2 WHERE t1.b<'d' AND t1.c<'m' AND t2.c<'m' USING INDEX i_t1_ac, i_t2_ac order by t1.id,t2.id limit 2;

drop t1,t2;


-- INDEX_LS 
drop table if exists t1;

create table t1(id int primary key auto_increment, a varchar collate iso88591_en_cs, b string,c int,d int, e int,f string,g int,h varchar);

insert into t1 (a,b,c,d,e,f,g,h) values (null, null, null, null, null, null, null, null);

insert into t1 (a,b,c,d,e,f,g,h) values ('a', 'b', 1, 1, 1, 'c', 1, 'd');

insert into t1 (a,b,c,d,e,f,g,h) values (repeat('a',300), repeat('b',300), 1, 1, 1, repeat('c',300), 1, repeat('d',300));

create index i_t1_all on t1(a,b,c,d,e,f,g,h);

select /*+ recompile INDEX_LS */ a from t1 where a>_iso88591'a' collate iso88591_en_cs group by a collate iso88591_en_ci;

drop t1;


-- sort limit
drop table if exists u;

drop table if exists t;

CREATE TABLE t(i string PRIMARY KEY, j string, k string);

CREATE TABLE u(i string, j string, k string);

ALTER TABLE u ADD constraint fk_t_u_i FOREIGN KEY(i) REFERENCES t(i);

CREATE INDEX i_u_j ON u(j);

insert into t values(repeat('a',300), repeat('b',300), repeat('c',300));

insert into t values(repeat('a1',300), repeat('b',300), repeat('c',300));

insert into t values(repeat('a2',300), repeat('b',300), repeat('c',300));

insert into t values(repeat('a3',300), repeat('b',300), repeat('c',300));

insert into t values(repeat('a4',300), repeat('b',300), repeat('c',300));

insert into t values(repeat('a5',300), repeat('b',300), repeat('c',300));

insert into u values(repeat('a',300), repeat('b',300), repeat('c',300));

insert into u values(repeat('a1',300), repeat('b',300), repeat('c',300));

insert into u values(repeat('a2',300), repeat('b',300), repeat('c',300));

insert into u values(repeat('a3',300), repeat('b',300), repeat('c',300));

insert into u values(repeat('a4',300), repeat('b',300), repeat('c',300));

insert into u values(repeat('a5',300), repeat('b',300), repeat('c',300));

SELECT /*+ RECOMPILE */ * FROM u, t WHERE u.i = t.i AND u.j > 'a' ORDER BY u.j LIMIT 2;

drop u;

drop t;


-- group by
drop table if exists u;

CREATE TABLE u(i string, j string, k string);

insert into u values(repeat('a',300), repeat('b',300), repeat('c',300));

insert into u values(repeat('a1',300), repeat('b1',300), repeat('c1',300));

insert into u values(repeat('a',300), repeat('b',300), repeat('c',300));

insert into u values(repeat('a1',300), repeat('b1',300), repeat('c1',300));

insert into u values(repeat('a',300), repeat('b',300), repeat('c',300));

insert into u values(repeat('a1',300), repeat('b1',300), repeat('c1',300));

select /*+ recompile */* from u where i>'a' group by i,j order by 1;

CREATE INDEX i_u_a_b_c ON u(i, j, k);

SELECT /*+ recompile */i, MIN(j), k, MAX(k) FROM u WHERE i > 18 GROUP BY i, j order by 1;

drop u;



-- USE_DESC_IDX
drop table if exists t;

CREATE TABLE t(i string);

insert into t values(repeat('a',300));

insert into t values(repeat('a',300));

insert into t values(repeat('a',300));

create index idx_t1 on t(i);

SELECT  /*+ RECOMPILE */* FROM t WHERE i > 0 LIMIT 3;

SELECT  /*+ RECOMPILE USE_DESC_IDX */* FROM t WHERE i > 0 LIMIT 3;

SELECT  /*+ RECOMPILE */* FROM t WHERE i > 0 order by i desc LIMIT 3;

drop t;


-- USE_NL
drop table if exists t;

CREATE TABLE t(i string);

insert into t values(repeat('a',300));

insert into t values(repeat('a',300));

insert into t values(repeat('a',300));

create index idx_t on t(i);

SELECT /*+ RECOMPILE USE_NL(t1, t2) */ * FROM t t1 INNER JOIN t t2 ON t1.i=t2.i order by t1.i limit 1; 

drop t;


drop table if exists t1;

create table t1(i1 int,s1 varchar,s2 nchar varying);

insert into t1 values(1,'a',n'a');

insert into t1 values(1,repeat('a',300),repeat(n'a',300));

insert into t1 values(1,repeat('b',300),repeat(n'b',300));

insert into t1 values(1,repeat('a',300),repeat(n'a',300));

insert into t1 values(1,repeat('b',300),repeat(n'b',300));

insert into t1 values(1,repeat('a',300),repeat(n'a',300));

insert into t1 values(1,repeat('b',300),repeat(n'b',300));

insert into t1 values(1,repeat('a',300),repeat(n'a',300));

insert into t1 values(1,repeat('b',300),repeat(n'b',300));

create index idx_t1 on t1(s1,s2);

select i1,max(s1) from t1 group by s2 order by 1,2;

select i1,max(s2) from t1 group by s2,s1 having min(s1) > 'a' order by 1,2;

select /*+ no_hash_aggregation */ i1, count(s2) from t1 group by s1 order by 1,2;

drop t1;


--+ holdcas off;