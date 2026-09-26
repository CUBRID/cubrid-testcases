--+ holdcas on;
-- workspace#364 (map #312, dpin-17g): a common value (COALESCE, NVL, IFNULL, NVL2, NULLIF, LEAST, GREATEST) over a
-- constant subtree - CAST(? AS T), a gate-dependent node inside it - is decided from the subtree's value once the gate
-- has evaluated it, as develop folds its operands' values: a NULL without a type drops out of the fold. Every answer
-- here is develop's except [ROW]: an operand a row gives keeps its plan domain for every row, where develop typed the
-- node by the first row's value, so that its answer followed the heap order (D-340-01).
drop table if exists cv_t;
drop table if exists cv_r;
create table cv_t (k int, d date, dt datetime);
insert into cv_t values (1, null, null), (2, date'2024-01-05', datetime'2024-01-05 10:00:00');
create index i_cv_t_k on cv_t (k);
create table cv_r (k int, d date, dt datetime);
insert into cv_r values (2, date'2024-01-05', datetime'2024-01-05 10:00:00'), (1, null, null);

-- [CAST] a NULL CAST operand, the type of the last argument
prepare q from 'select typeof(coalesce(cast(? as datetime), cast(? as datetime), ?)), coalesce(cast(? as datetime), cast(? as datetime), ?) from db_root';
execute q using null, null, 1, null, null, 1;
execute q using null, null, 3000000000, null, null, 3000000000;
execute q using null, null, 1.50, null, null, 1.50;
execute q using null, null, 1.5e0, null, null, 1.5e0;
execute q using null, null, '1.0', null, null, '1.0';
execute q using null, null, date'2024-01-02', null, null, date'2024-01-02';
execute q using null, null, time'10:00:01', null, null, time'10:00:01';
execute q using null, null, timestamp'2024-01-02 10:00:01', null, null, timestamp'2024-01-02 10:00:01';
execute q using null, null, datetime'2024-01-02 10:00:01.500', null, null, datetime'2024-01-02 10:00:01.500';
execute q using datetime'2024-01-02 10:00:01.500', null, 1, datetime'2024-01-02 10:00:01.500', null, 1;
execute q using null, null, null, null, null, null;
prepare q from 'select typeof(coalesce(cast(? as datetime), ?)), coalesce(cast(? as datetime), ?) from db_root';
execute q using null, 1, null, 1;
execute q using null, null, null, null;
prepare q from 'select typeof(nvl(cast(? as date), ?)), nvl(cast(? as date), ?) from db_root';
execute q using null, 1, null, 1;
prepare q from 'select typeof(nvl(cast(? as double), ?)), nvl(cast(? as double), ?) from db_root';
execute q using null, 1, null, 1;
execute q using 2.5e0, 1, 2.5e0, 1;
prepare q from 'select typeof(ifnull(cast(? as datetime), ?)), ifnull(cast(? as datetime), ?) from db_root';
execute q using null, date'2024-01-02', null, date'2024-01-02';
prepare q from 'select typeof(coalesce(cast(cast(? as date) as datetime), ?)), coalesce(cast(cast(? as date) as datetime), ?) from db_root';
execute q using null, 1, null, 1;
prepare q from 'select typeof(nvl2(cast(? as datetime), ?, 2)), nvl2(cast(? as datetime), ?, 2) from db_root';
execute q using null, 1, null, 1;
execute q using datetime'2024-01-02 10:00:01', 1, datetime'2024-01-02 10:00:01', 1;
prepare q from 'select typeof(coalesce(cast(? as char(5)), ?)), coalesce(cast(? as char(5)), ?) from db_root';
execute q using null, 'ab', null, 'ab';
execute q using 'x', 'ab', 'x', 'ab';

-- [NESTED] a gate-dependent node inside the constant subtree, chains of common values
prepare q from 'select typeof(coalesce(nullif(?, ?), 1)), coalesce(nullif(?, ?), 1) from db_root';
execute q using 'a', 'a', 'a', 'a';
execute q using 'a', 'b', 'a', 'b';
prepare q from 'select typeof(coalesce(cast(? as date), ?, ?)), coalesce(cast(? as date), ?, ?) from db_root';
execute q using null, null, 1, null, null, 1;
execute q using null, date'2024-01-02', 1, null, date'2024-01-02', 1;
prepare q from 'select typeof(coalesce(coalesce(cast(? as date), ?), ?)), coalesce(coalesce(cast(? as date), ?), ?) from db_root';
execute q using null, null, 1, null, null, 1;
prepare q from 'select typeof(coalesce(cast(? as int) + ?, ''a'')), coalesce(cast(? as int) + ?, ''a'') from db_root';
execute q using null, 1, null, 1;
execute q using 2, 1, 2, 1;
prepare q from 'select typeof(ifnull(upper(?), ?)), ifnull(upper(?), ?) from db_root';
execute q using null, 1, null, 1;
prepare q from 'select typeof(v), v from (select coalesce(cast(? as datetime), ?) v from db_root) t';
execute q using null, 1;

-- [CONSUMER] a node, a term, a key and an aggregate over a common value that waits for its constant subtree
prepare q from 'select typeof(coalesce(cast(? as datetime), ?) + 1), coalesce(cast(? as datetime), ?) + 1 from db_root';
execute q using null, 1, null, 1;
prepare q from 'select k from cv_t where coalesce(cast(? as date), ?) = k order by k';
execute q using null, 2;
prepare q from 'select k from cv_t where k = coalesce(cast(? as date), ?) order by k';
execute q using null, 2;
execute q using null, '2';
prepare q from 'select k, typeof(coalesce(cast(? as datetime), ?, k)), coalesce(cast(? as datetime), ?, k) from cv_t where coalesce(cast(? as datetime), ?, k) = 1 order by k';
execute q using null, null, null, null, null, null;
execute q using null, 1, null, 1, null, 1;
prepare q from 'select k, typeof(least(coalesce(cast(? as date), ?, k), ?)), least(coalesce(cast(? as date), ?, k), ?) from cv_t order by k';
execute q using null, null, 2, null, null, 2;
prepare q from 'select typeof(max(coalesce(cast(? as date), ?, k))), max(coalesce(cast(? as date), ?, k)), sum(coalesce(cast(? as date), ?, k)) from cv_t';
execute q using null, null, null, null, null, null;

-- [SAME] the operator's result is NULL, an arithmetic NULL, a NULL literal, bare slots, a constant with a value
prepare q from 'select typeof(nullif(cast(? as double), ?)), nullif(cast(? as double), ?), typeof(least(cast(? as double), ?)), least(cast(? as double), ?), typeof(greatest(cast(? as datetime), ?)), greatest(cast(? as datetime), ?) from db_root';
execute q using null, 1, null, 1, null, 1, null, 1, null, date'2024-01-02', null, date'2024-01-02';
prepare q from 'select typeof(coalesce(? + 1.5, 1)), coalesce(? + 1.5, 1) from db_root';
execute q using null, null;
prepare q from 'select typeof(coalesce(cast(null as datetime), ?)), coalesce(cast(null as datetime), ?) from db_root';
execute q using 1, 1;
prepare q from 'select typeof(coalesce(?, ?)), coalesce(?, ?) from db_root';
execute q using null, 1, null, 1;
prepare q from 'select typeof(coalesce(cast(? as double), ?)), coalesce(cast(? as double), ?) from db_root';
execute q using 1.5e0, 1, 1.5e0, 1;

-- [ROW] an operand a row gives: the plan's domain in either heap order
prepare q from 'select k, typeof(coalesce(cast(? as datetime), dt, ?)), coalesce(cast(? as datetime), dt, ?) from cv_t order by k';
execute q using null, 1, null, 1;
execute q using null, date'2024-01-02', null, date'2024-01-02';
prepare q from 'select k, typeof(coalesce(cast(? as datetime), dt, ?)), coalesce(cast(? as datetime), dt, ?) from cv_r order by k';
execute q using null, 1, null, 1;
execute q using null, date'2024-01-02', null, date'2024-01-02';

-- [PX] a parallel heap scan over a term whose side waits for its constant subtree (131072 rows)
create table cv_p (k int, v int);
insert into cv_p values (1, 1);
insert into cv_p select k + 1, v from cv_p;
insert into cv_p select k + 2, v from cv_p;
insert into cv_p select k + 4, v from cv_p;
insert into cv_p select k + 8, v from cv_p;
insert into cv_p select k + 16, v from cv_p;
insert into cv_p select k + 32, v from cv_p;
insert into cv_p select k + 64, v from cv_p;
insert into cv_p select k + 128, v from cv_p;
insert into cv_p select k + 256, v from cv_p;
insert into cv_p select k + 512, v from cv_p;
insert into cv_p select k + 1024, v from cv_p;
insert into cv_p select k + 2048, v from cv_p;
insert into cv_p select k + 4096, v from cv_p;
insert into cv_p select k + 8192, v from cv_p;
insert into cv_p select k + 16384, v from cv_p;
insert into cv_p select k + 32768, v from cv_p;
insert into cv_p select k + 65536, v from cv_p;
update statistics on cv_p;
prepare q from 'select count(*), min(coalesce(cast(? as date), ?, k)), max(typeof(coalesce(cast(? as date), ?, k))) from cv_p where coalesce(cast(? as date), ?, k) = k';
execute q using null, null, null, null, null, null;
execute q using null, 1, null, 1, null, 1;

deallocate prepare q;
drop table cv_t;
drop table cv_r;
drop table cv_p;
--+ holdcas off;
