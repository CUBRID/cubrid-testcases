/**
 *  This test case verifies CBRD-28215: a nested-loop SEMI/ANTI join, or a join after a SEMI join, whose inner is
 *  a class hierarchy (ALL superclass) scans every class for each outer row, not only the class the previous
 *  outer row stopped on.
 *
 *  Coverage:
 *    Case 1: NL ANTI join (NOT EXISTS, NOT IN) over ALL superclass
 *    Case 2: NL SEMI join (EXISTS, IN) over ALL superclass
 *    Case 3: index scans on each class of the hierarchy
 *    Case 4: a class of the hierarchy has no heap (no row was ever inserted), and every class is empty
 *    Case 5: three-level hierarchy, ALL on the middle class, ALL ... (EXCEPT ...)
 *    Case 6: an inner or LEFT join that follows an unnested SEMI/ANTI join, whose inner is ALL superclass
 *    Case 7: DELETE / UPDATE with a SEMI/ANTI subquery over ALL superclass
 *    Each NL query is compared with the same query by hash join or by a UNION ALL derived table.
 */

drop table if exists sx, hxc, hx, hec, he, h3c, h3b, h3a, hc, hs, hu, hx2, gc, gb, ga, gq, gx, gd;


evaluate 'Case 1: NL ANTI join over ALL superclass';
create table sx (k int);
insert into sx values (2), (3), (4), (6), (9), (11);
create table hx (k int);
create table hxc under hx (y int);
insert into hx values (2), (4), (6);
insert into hxc (k) values (3), (6), (9);

select /*+ recompile USE_NL */ o.k from sx o where not exists (select 1 from all hx i where o.k = i.k) order by 1;
select /*+ recompile USE_NL */ o.k from sx o where o.k not in (select i.k from all hx i) order by 1;
select /*+ recompile */ o.k from sx o where not exists (select 1 from (select k from hx union all select k from hxc) i where o.k = i.k) order by 1;


evaluate 'Case 2: NL SEMI join over ALL superclass';
select /*+ recompile ORDERED USE_NL */ o.k from sx o where exists (select 1 from all hx i where o.k = i.k) order by 1;
select /*+ recompile USE_NL */ o.k from sx o where o.k in (select i.k from all hx i) order by 1;
select /*+ recompile */ o.k from sx o where exists (select 1 from (select k from hx union all select k from hxc) i where o.k = i.k) order by 1;


evaluate 'Case 3: index scans on each class of the hierarchy';
create index ix_hx on hx (k);
create index ix_hxc on hxc (k);
update statistics on sx, hx, hxc with fullscan;
select /*+ recompile USE_NL */ o.k from sx o where not exists (select 1 from all hx i where o.k = i.k) order by 1;
select /*+ recompile ORDERED USE_NL */ o.k from sx o where exists (select 1 from all hx i where o.k = i.k) order by 1;


evaluate 'Case 4: a class without a heap, and every class empty';
create table he (k int);
create table hec under he (y int);
insert into he values (2), (4), (6);
select /*+ recompile USE_NL */ o.k from sx o where not exists (select 1 from all he i where o.k = i.k) order by 1;
select /*+ recompile ORDERED USE_NL */ o.k from sx o where exists (select 1 from all he i where o.k = i.k) order by 1;

create table h3a (k int);
create table h3b under h3a (y int);
create table h3c under h3b (z int);
insert into h3b (k) values (3);
insert into h3c (k) values (6), (9);
select /*+ recompile USE_NL */ o.k from sx o where not exists (select 1 from all h3a i where o.k = i.k) order by 1;
select /*+ recompile ORDERED USE_NL */ o.k from sx o where exists (select 1 from all h3a i where o.k = i.k) order by 1;
delete from h3b;
delete from h3c;
select /*+ recompile USE_NL */ count (*) from sx o where not exists (select 1 from all h3a i where o.k = i.k);
select /*+ recompile ORDERED USE_NL */ count (*) from sx o where exists (select 1 from all h3a i where o.k = i.k);


evaluate 'Case 5: three-level hierarchy, ALL on the middle class, ALL EXCEPT';
create table ga (id int, k int);
create table gb under ga (b int);
create table gc under gb (c int);
insert into ga select level, mod (level, 50) from db_root connect by level <= 300;
insert into gb (id, k) select level + 1000, mod (level, 50) + 25 from db_root connect by level <= 300;
insert into gc (id, k) select level + 2000, mod (level, 50) + 60 from db_root connect by level <= 300;
create table gq (id int, k int, kb int);
insert into gq select level, mod (level * 7, 120), mod (level, 4) from db_root connect by level <= 3000;
create table gx (k2 int);
insert into gx select mod (level, 3) from db_root connect by level <= 30;
create index ix_ga on ga (k);
create index ix_gb on gb (k);
create index ix_gc on gc (k);
update statistics on ga, gb, gc, gq, gx with fullscan;

select /*+ recompile USE_NL */ count (*) from gq o where exists (select 1 from all ga i where i.k = o.k);
select /*+ recompile USE_HASH */ count (*) from gq o where exists (select 1 from all ga i where i.k = o.k);
select /*+ recompile USE_NL */ count (*) from gq o where not exists (select 1 from all ga i where i.k = o.k);
select /*+ recompile USE_HASH */ count (*) from gq o where not exists (select 1 from all ga i where i.k = o.k);
select /*+ recompile USE_NL */ count (*) from gq o where exists (select 1 from all ga i where i.k = o.k and i.id > 1000);
select /*+ recompile USE_HASH */ count (*) from gq o where exists (select 1 from all ga i where i.k = o.k and i.id > 1000);
select /*+ recompile USE_NL */ count (*) from gq o where not exists (select 1 from all gb i where i.k = o.k);
select /*+ recompile USE_HASH */ count (*) from gq o where not exists (select 1 from all gb i where i.k = o.k);
select /*+ recompile USE_NL */ count (*) from gq o where not exists (select 1 from all ga (except gb) i where i.k = o.k);
select /*+ recompile USE_HASH */ count (*) from gq o where not exists (select 1 from all ga (except gb) i where i.k = o.k);


evaluate 'Case 6: a join that follows a SEMI/ANTI join, inner is ALL superclass';
create table hs (id int, k int);
create table hc under hs (e int);
create table hu (id int, k int, kb int);
create table hx2 (k2 int);
insert into hs select level, mod (level, 10) from db_root connect by level <= 100;
insert into hc select level + 1000, mod (level, 10), 0 from db_root connect by level <= 100;
insert into hu select level, mod (level, 10), mod (level, 5) from db_root connect by level <= 20;
insert into hx2 select mod (level, 3) from db_root connect by level <= 50;
update statistics on hs, hc, hu, hx2 with fullscan;

select /*+ recompile USE_NL */ count (*) from hu t0 inner join all hs t1 on t0.k = t1.k where t0.kb in (select x.k2 from hx2 x);
select /*+ recompile USE_HASH */ count (*) from hu t0 inner join all hs t1 on t0.k = t1.k where t0.kb in (select x.k2 from hx2 x);
select /*+ recompile USE_NL */ count (*) from hu t0 inner join all hs t1 on t0.k = t1.k where exists (select 1 from hx2 x where x.k2 = t0.kb);
select /*+ recompile USE_NL */ count (*) from hu t0 inner join all hs t1 on t0.k = t1.k where t0.kb not in (select x.k2 from hx2 x);
select /*+ recompile USE_HASH */ count (*) from hu t0 inner join all hs t1 on t0.k = t1.k where t0.kb not in (select x.k2 from hx2 x);
select /*+ recompile USE_NL */ count (*), count (t1.id) from hu t0 left join all hs t1 on t0.k = t1.k and t1.id > 1095 where t0.kb in (select x.k2 from hx2 x);
select /*+ recompile USE_HASH */ count (*), count (t1.id) from hu t0 left join all hs t1 on t0.k = t1.k and t1.id > 1095 where t0.kb in (select x.k2 from hx2 x);
select /*+ recompile USE_NL */ count (*) from gq t0 inner join all ga t1 on t0.k = t1.k where t0.kb in (select k2 from gx);
select /*+ recompile USE_HASH */ count (*) from gq t0 inner join all ga t1 on t0.k = t1.k where t0.kb in (select k2 from gx);
select /*+ recompile USE_NL */ count (*), count (t1.id) from gq t0 left join all ga t1 on t0.k = t1.k where t0.kb in (select k2 from gx);
select /*+ recompile USE_HASH */ count (*), count (t1.id) from gq t0 left join all ga t1 on t0.k = t1.k where t0.kb in (select k2 from gx);


evaluate 'Case 7: DELETE / UPDATE with a SEMI/ANTI subquery over ALL superclass';
create table gd as select * from gq;
delete /*+ USE_NL */ from gd where not exists (select 1 from all ga i where i.k = gd.k);
select count (*) from gd;
update /*+ USE_NL */ gd set kb = 9 where exists (select 1 from all ga i where i.k = gd.k and i.id > 2000);
select count (*) from gd where kb = 9;


drop table if exists sx, hxc, hx, hec, he, h3c, h3b, h3a, hc, hs, hu, hx2, gc, gb, ga, gq, gx, gd;
