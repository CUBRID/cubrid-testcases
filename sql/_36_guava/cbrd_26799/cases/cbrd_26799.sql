--
-- [CBRD-26799] parallel index build 이중 커서 desync 로 인한 인덱스 행 유실 회귀 검증
--
-- 무엇을: 평범한 CREATE INDEX 는 heap 페이지가 parallel_sort_page_threshold(기본 2048) 이상이면
--   offline 병렬 정렬(px, btree_sort_get_next_parallel) 경로로 인덱스를 만든다. 이 경로에서
--   nofit 과 heap page 전환이 한 호출 안에서 겹칠 때 빌드된 인덱스에서 heap page 한 장 분량
--   (~180~250건)이 누락되던 버그(fix: f57fe4393). heap scan 은 항상 정상, index skip scan 으로만
--   노출된다. 그래서 인덱스를 반복 재빌드하며 INDEX_SS count 가 매번 정확한지 확인한다.
--
-- 왜 2100000 행(3 블록): 700K(~1450 page)는 기본 config 에서 임계값 미만이라 serial 로 돌아
--   버그 경로를 안 탄다. 2100000 행(~4357 page > 2048)이면 기본 config 에서도 병렬 px 경로를
--   타므로, 특수 CI 설정 없이 표준 회귀에서 fix 경로를 실제로 검증한다.
--   (이슈 원본 700K 재현은 이미 _19_apricot/_03_index_skip_scan 의 _03_iss_700000(not null)/
--    _08_iss_700000_with_null(nullable) 로 존재하며, 그들은 특수 parallel-index CI 모드에서만 병렬.)
--
-- race 한계: fix 전 재현은 확률적(이슈 기준 ~6/100)이고 빠른 다중코어 환경에서는 관측이 어렵다.
--   반복(10회)으로 검출력을 높이지만 단일 실행에서 반드시 실패한다고 보장하지 않는다(best-effort).
--
-- 독립성: CI 는 하나의 공유 DB 에서 전체 SQL 을 수행하므로 끝에 t 를 drop 한다.
--


create table mille as select 0 as i from table({1,2,3,4,5,6,7,8,9,0}) t1, table({1,2,3,4,5,6,7,8,9,0}) t2, table({1,2,3,4,5,6,7,8,9,0}) t3, table({1,2,3,4,5,6,7,8,9,0}) t4, table({0,1,2,3,4,5,6,7,8,9}) t5;
create table t (i int not null, j int, k int, l int);
insert into t(i,j,k,l) select i+2, 2*((rownum-1)%50+1)-1+100,rownum, rownum from mille;
insert into t(i,j,k,l) select i+5, 2*((rownum-1)%50+1)-1+100,rownum, rownum from mille;
insert into t(i,j,k,l) select i+6, 2*((rownum-1)%50+1)-1+100,rownum, rownum from mille;
insert into t(i,j,k,l) select i+1, 2*((rownum-1)%50+1)-1+100,rownum, rownum from mille;
insert into t(i,j,k,l) select i+0, 2*((rownum-1)%50+1)  ,rownum, rownum from mille;
insert into t(i,j,k,l) select i+3, 2*((rownum-1)%50+1)  ,rownum, rownum from mille;
insert into t(i,j,k,l) select i+4, 2*((rownum-1)%50+1)  ,rownum, rownum from mille;
insert into t(i,j,k,l) select i+2, 2*((rownum-1)%50+1)-1+100,rownum, rownum from mille;
insert into t(i,j,k,l) select i+5, 2*((rownum-1)%50+1)-1+100,rownum, rownum from mille;
insert into t(i,j,k,l) select i+6, 2*((rownum-1)%50+1)-1+100,rownum, rownum from mille;
insert into t(i,j,k,l) select i+1, 2*((rownum-1)%50+1)-1+100,rownum, rownum from mille;
insert into t(i,j,k,l) select i+0, 2*((rownum-1)%50+1)  ,rownum, rownum from mille;
insert into t(i,j,k,l) select i+3, 2*((rownum-1)%50+1)  ,rownum, rownum from mille;
insert into t(i,j,k,l) select i+4, 2*((rownum-1)%50+1)  ,rownum, rownum from mille;
insert into t(i,j,k,l) select i+2, 2*((rownum-1)%50+1)-1+100,rownum, rownum from mille;
insert into t(i,j,k,l) select i+5, 2*((rownum-1)%50+1)-1+100,rownum, rownum from mille;
insert into t(i,j,k,l) select i+6, 2*((rownum-1)%50+1)-1+100,rownum, rownum from mille;
insert into t(i,j,k,l) select i+1, 2*((rownum-1)%50+1)-1+100,rownum, rownum from mille;
insert into t(i,j,k,l) select i+0, 2*((rownum-1)%50+1)  ,rownum, rownum from mille;
insert into t(i,j,k,l) select i+3, 2*((rownum-1)%50+1)  ,rownum, rownum from mille;
insert into t(i,j,k,l) select i+4, 2*((rownum-1)%50+1)  ,rownum, rownum from mille;
drop table mille;

-- heap scan 은 항상 무결(참조): 2100000
select count(*) from t;


-- ---- iteration 1/10 : 병렬 재빌드 후 INDEX_SS count (기대 600000/450000) ----
create index idx on t(i,j,k);
update statistics on t;
--@queryplan
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 151 and 199) tt;
--@queryplan
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 2 and 50) tt;
drop index idx on t;

-- ---- iteration 2/10 : 병렬 재빌드 후 INDEX_SS count (기대 600000/450000) ----
create index idx on t(i,j,k);
update statistics on t;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 151 and 199) tt;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 2 and 50) tt;
drop index idx on t;

-- ---- iteration 3/10 : 병렬 재빌드 후 INDEX_SS count (기대 600000/450000) ----
create index idx on t(i,j,k);
update statistics on t;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 151 and 199) tt;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 2 and 50) tt;
drop index idx on t;

-- ---- iteration 4/10 : 병렬 재빌드 후 INDEX_SS count (기대 600000/450000) ----
create index idx on t(i,j,k);
update statistics on t;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 151 and 199) tt;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 2 and 50) tt;
drop index idx on t;

-- ---- iteration 5/10 : 병렬 재빌드 후 INDEX_SS count (기대 600000/450000) ----
create index idx on t(i,j,k);
update statistics on t;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 151 and 199) tt;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 2 and 50) tt;
drop index idx on t;

-- ---- iteration 6/10 : 병렬 재빌드 후 INDEX_SS count (기대 600000/450000) ----
create index idx on t(i,j,k);
update statistics on t;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 151 and 199) tt;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 2 and 50) tt;
drop index idx on t;

-- ---- iteration 7/10 : 병렬 재빌드 후 INDEX_SS count (기대 600000/450000) ----
create index idx on t(i,j,k);
update statistics on t;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 151 and 199) tt;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 2 and 50) tt;
drop index idx on t;

-- ---- iteration 8/10 : 병렬 재빌드 후 INDEX_SS count (기대 600000/450000) ----
create index idx on t(i,j,k);
update statistics on t;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 151 and 199) tt;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 2 and 50) tt;
drop index idx on t;

-- ---- iteration 9/10 : 병렬 재빌드 후 INDEX_SS count (기대 600000/450000) ----
create index idx on t(i,j,k);
update statistics on t;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 151 and 199) tt;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 2 and 50) tt;
drop index idx on t;

-- ---- iteration 10/10 : 병렬 재빌드 후 INDEX_SS count (기대 600000/450000) ----
create index idx on t(i,j,k);
update statistics on t;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 151 and 199) tt;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 2 and 50) tt;
drop index idx on t;

-- ---- cleanup (파일 독립성) ----
drop table t;
