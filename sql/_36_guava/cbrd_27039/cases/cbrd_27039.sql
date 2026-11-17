/*
 * This test case verifies CBRD-27039 : histogram-consumption defects in the
 * optimizer's selectivity estimation (and the CBRD-27059 crash its fix caused).
 *
 * Background: since CBRD-26202 a term's selectivity is probed from the column
 * histogram (UPDATE STATISTICS builds one per column by default). The
 * estimators in query_planner.c consumed those probes incorrectly:
 *  (1) qo_comp_selectivity (): for 'const OP attr' the (is_ge, include_equal)
 *      flags were complemented instead of mirrored, so "5 < a" was priced as
 *      "a >= 5" and "5 <= a" as "a > 5" -- boundary rows flipped sides.
 *  (2) qo_equal_selectivity (): 'const = attr' fell through to the host-variable
 *      case and read host_var.index out of a PT_VALUE node.
 *  (3) qo_like_selectivity () received the head of the OR (or_next) chain and
 *      re-walked the whole chain, so every non-LIKE sibling was counted once by
 *      itself and once more as a failed LIKE probe (the LIKE default 0.1 each):
 *      "cs LIKE 'abc%' OR ck IN (1,2)" was estimated ~20% instead of ~0.3%.
 *  (4) the x(1 - null_frequency) restoration of a histogram (non-null
 *      conditional) selectivity used the columns of the chain HEAD for every
 *      sibling. A 99%-NULL column behind a null-free head kept its conditional
 *      selectivity (1.0 instead of 0.002), and the estimate depended on the
 *      operand order.
 *  (5) a transient histogram fetch failure aborted the query (concurrency only,
 *      not reproducible in a sequential SQL case).
 * CBRD-27059 (regression of this fix): the per-node null restoration of (4)
 * dereferenced info.expr.arg2 of a constant-folded PT_VALUE sibling, e.g. the
 * "(5<7 or 5>9)" that equality propagation of "a = 5" leaves inside an OR chain,
 * and crashed the client in qo_expr_selectivity (). Fixed by a PT_IS_EXPR_NODE
 * guard.
 *
 * Only plan SHAPE is asserted (CTP masks cost/card). Every query also returns
 * its count so the answer is self-checking. Statements carry the recompile hint
 * so the plan cache cannot serve a plan compiled for another literal.
 *
 * t_dir: 10,000 rows. a = 5 on 9,960 rows, a in 1..4 on 5 rows each (20 rows,
 * 0.2%), a in 6..9 on 5 rows each (20 rows, 0.2%), index ix_dir_a. With 10,000
 * rows the single-scan reservoir keeps every row and every value becomes an
 * MCV, so the histogram is exact. count(pad) (pad is not indexed) keeps the
 * index from being a covering index.
 *   Case 1 (defect 1): "a > 5" / "5 < a" and "a < 5" / "5 > a" select 0.2% of
 *           the rows -> all four must be iscan ix_dir_a, "a >= 5" / "5 <= a" and
 *           "a <= 5" / "5 >= a" select 99.8% -> all four must be sscan. With
 *           the inverted flags the reversed forms would have picked the plan of
 *           their mirror ("5 < a" sscan, "5 <= a" iscan).
 *   Case 2 (defect 2): "a = 7" / "7 = a" (5 rows) -> iscan ix_dir_a,
 *           "a = 5" / "5 = a" (99.6%) -> sscan. Reversed equality must give the
 *           plan of its mirror.
 *   Case 3 (defect 3): a nested-loop join with t_ref (10,000 rows, pk id,
 *           f = 0 on 500 rows = 5%). The OR chain
 *           "(d.cs like 'abc%' or d.ck in (1,2))" matches 30 rows of t_dir
 *           (0.3%). The optimizer puts the smaller filtered node on the outer
 *           side, so t_dir (30) must be the OUTER of the idx-join and t_ref the
 *           inner probed through pk_t_ref_id. The double-counted estimate (~20%
 *           = 2,000 rows) made t_ref (500) the outer. Both operand orders of the
 *           OR chain must produce the same join order. Hints use_nl /
 *           no_use_hash keep hash join out so only the order is compared.
 *   Case 4 (defect 4): same join with "(d.ck >= 990 or d.cn <= 100)": ck is
 *           null-free (ck >= 990 ~1%), cn is NULL on 99.8% of the rows and 1 on
 *           the other 20, so "cn <= 100" is 100% conditional but 0.2% of all
 *           rows. The chain estimates ~1.2% (120 rows) -> t_dir must be the
 *           OUTER. With the head's (ck's) null fraction applied to cn the chain
 *           estimated ~100% and t_ref became the outer, swapping the operands
 *           changed the plan. Both orders must give the same join order.
 *   Case 5 (CBRD-27059): OR chains that equality propagation folds into
 *           PT_VALUE siblings -- "a = 5 and (a < 7 or a > 9)" becomes
 *           "(5<7 or 5>9)" -- with and without a LIKE sibling. They must
 *           compile (no crash) and return the right counts: 9960 / 9 / 5 / 19.
 */
drop table if exists t_dir, t_ref;

create table t_dir (id int primary key, a int, cs varchar(20), cn int, ck int, pad varchar(100));
insert into t_dir
select level,
       case when level <= 5 then 1 when level <= 10 then 2 when level <= 15 then 3 when level <= 20 then 4
            when level > 9995 then 9 when level > 9990 then 8 when level > 9985 then 7 when level > 9980 then 6
            else 5 end,
       case when mod (level, 1000) = 0 then 'abc' || level else 'v' || mod (level, 100) end,
       case when mod (level, 500) = 0 then 1 else null end,
       mod (level, 1000),
       lpad ('x', 100, 'x')
from db_root connect by level <= 10000;
create index ix_dir_a on t_dir (a);

create table t_ref (id int primary key, f int, pad varchar(100));
insert into t_ref select level, mod (level, 20), lpad ('y', 100, 'y') from db_root connect by level <= 10000;

update statistics on t_dir with fullscan;
update statistics on t_ref with fullscan;

-- data shape checks
select a, count(*) from t_dir group by a order by a;
select count(*) from t_dir where cn is not null;
select count(*) from t_dir where cs like 'abc%';
select count(*) from t_ref where f = 0;

evaluate '[1] reversed comparison: const OP attr must be priced like its mirror attr OP const';
evaluate '[1-1] a > 5 (0.2%) -> iscan ix_dir_a';
--@queryplan
select /*+ recompile */ count(pad) from t_dir where a > 5;
evaluate '[1-2] 5 < a -> same plan as a > 5 (iscan)';
--@queryplan
select /*+ recompile */ count(pad) from t_dir d where 5 < d.a;
evaluate '[1-3] a >= 5 (99.8%) -> sscan';
--@queryplan
select /*+ recompile */ count(pad) from t_dir where a >= 5;
evaluate '[1-4] 5 <= a -> same plan as a >= 5 (sscan)';
--@queryplan
select /*+ recompile */ count(pad) from t_dir d where 5 <= d.a;
evaluate '[1-5] a < 5 (0.2%) -> iscan ix_dir_a';
--@queryplan
select /*+ recompile */ count(pad) from t_dir where a < 5;
evaluate '[1-6] 5 > a -> same plan as a < 5 (iscan)';
--@queryplan
select /*+ recompile */ count(pad) from t_dir d where 5 > d.a;
evaluate '[1-7] a <= 5 (99.8%) -> sscan';
--@queryplan
select /*+ recompile */ count(pad) from t_dir where a <= 5;
evaluate '[1-8] 5 >= a -> same plan as a <= 5 (sscan)';
--@queryplan
select /*+ recompile */ count(pad) from t_dir d where 5 >= d.a;

evaluate '[2] reversed equality: const = attr must be priced like attr = const';
evaluate '[2-1] a = 7 (5 rows) -> iscan ix_dir_a';
--@queryplan
select /*+ recompile */ count(pad) from t_dir where a = 7;
evaluate '[2-2] 7 = a -> iscan ix_dir_a';
--@queryplan
select /*+ recompile */ count(pad) from t_dir d where 7 = d.a;
evaluate '[2-3] a = 5 (99.6%) -> sscan';
--@queryplan
select /*+ recompile */ count(pad) from t_dir where a = 5;
evaluate '[2-4] 5 = a -> sscan';
--@queryplan
select /*+ recompile */ count(pad) from t_dir d where 5 = d.a;

evaluate '[3] LIKE inside an OR chain: non-LIKE siblings must be counted once';
evaluate '[3-1] (cs like OR ck in) matches 30 rows -> t_dir is the OUTER, t_ref inner via pk_t_ref_id';
--@queryplan
select /*+ recompile use_nl no_use_hash */ count(*) from t_dir d, t_ref r
where d.id = r.id and r.f = 0 and (d.cs like 'abc%' or d.ck in (1, 2));
evaluate '[3-2] operands swapped (ck in OR cs like) -> same join order';
--@queryplan
select /*+ recompile use_nl no_use_hash */ count(*) from t_dir dd, t_ref rr
where dd.id = rr.id and rr.f = 0 and (dd.ck in (1, 2) or dd.cs like 'abc%');

evaluate '[4] NULL restoration must use the CURRENT node''s column, not the chain head';
evaluate '[4-1] (ck >= 990 OR cn <= 100), cn 99.8% NULL behind null-free ck -> t_dir is the OUTER';
--@queryplan
select /*+ recompile use_nl no_use_hash */ count(*) from t_dir d, t_ref r
where d.id = r.id and r.f = 0 and (d.ck >= 990 or d.cn <= 100);
evaluate '[4-2] operands swapped (cn <= 100 OR ck >= 990) -> same join order';
--@queryplan
select /*+ recompile use_nl no_use_hash */ count(*) from t_dir dd, t_ref rr
where dd.id = rr.id and rr.f = 0 and (dd.cn <= 100 or dd.ck >= 990);

evaluate '[5] CBRD-27059: constant-folded PT_VALUE siblings in an OR chain must not crash the compile';
evaluate '[5-1] a = 5 and (a < 7 or a > 9) -> (5<7 or 5>9) -> 9960';
select /*+ recompile */ count(*) from t_dir where a = 5 and (a < 7 or a > 9);
evaluate '[5-2] folded siblings around a LIKE node -> 9';
select /*+ recompile */ count(*) from t_dir where a = 5 and (a < 3 or cs like 'abc%' or a > 9);
evaluate '[5-3] LIKE head with a folded tail -> 5';
select /*+ recompile */ count(*) from t_dir where a = 7 and (cs like 'v%' or a > 100);
evaluate '[5-4] folded siblings around IS NOT NULL on the nullable column -> 19 (row 10000 has a = 9)';
select /*+ recompile */ count(*) from t_dir where a = 5 and (a > 100 or cn is not null or a < 0);

drop table t_dir, t_ref;
