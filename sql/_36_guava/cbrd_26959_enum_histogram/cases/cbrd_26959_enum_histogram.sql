/**
 *  CBRD-26959: ENUM equality predicates receive histogram estimates.
 *
 *  histogram_get_equal_selectivity () maps DB_TYPE_ENUMERATION to the i64 key kind
 *  (the member index), so a skewed ENUM column estimates an equality with the MCV
 *  frequency of the probed member instead of the uniform 1/NDV guess.
 *
 *  The verification is plan-shape based via --@fullplan (CTP masks sel/cost numbers):
 *  col_a is 99% 'red' and 0.5% 'blue', with an index on col_a. Under the uniform
 *  1/NDV fallback both probes estimate 1/3 and take the sequential scan; with the
 *  histogram the 'blue' probe estimates ~0.005 and must switch to the index scan,
 *  while the 'red' probe (0.99) must stay on the sequential scan. Both probes read
 *  col_b so neither is index-covered (a covering count(*) would take the index scan
 *  regardless of selectivity), and the second uses a table alias so auto-parameterization
 *  cannot fold both statements onto one cached plan (the second dump would vanish).
 *  Each query also returns its count, so the answer stays self-checking.
 *
 *  The table is small enough that the single-scan reservoir keeps every row, so
 *  the collected histogram is exact and the plan choice deterministic.
 */

drop table if exists tenum;

create table tenum (col_a enum('red','blue','green'), col_b int);
insert into tenum select 'red', level from db_root connect by level <= 9900;
insert into tenum select 'blue', level from db_root connect by level <= 50;
insert into tenum select 'green', level from db_root connect by level <= 50;
create index i_tenum_cola on tenum (col_a);

update statistics on tenum with 100 buckets;

--@fullplan
select count(col_b) from tenum where col_a = 'red';
--@fullplan
select count(col_b) from tenum te where te.col_a = 'blue';

drop table tenum;
