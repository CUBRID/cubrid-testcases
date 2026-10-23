/*
 * CBRD-27482: COALESCE, GREATEST and LEAST with an ENUM column and a host variable.
 *
 * The common type of an ENUM argument and a host variable was left undetermined (MAYBE), so
 * the statement failed: a debug build asserted in the client at PREPARE, and a release build
 * failed at EXECUTE with 'Cannot coerce value of domain "enum" to domain "*variable*"'.
 * The common type is now VARCHAR, as with a string literal. Each prepared statement must
 * return the same value, type and collation as the same statement with a literal.
 */
drop table if exists t_27482;
create table t_27482 (k int primary key, e enum('c', 'a', 'b') collate utf8_en_ci, eb enum('a', 'b') collate utf8_bin);
insert into t_27482 values (1, 'a', 'a'), (2, 'b', 'b'), (3, 'c', null), (4, null, null);

-- the query of the report, with the result type and collation
prepare s from 'select k, coalesce(e, ?), typeof(coalesce(e, ?)), collation(coalesce(e, ?)) from t_27482 order by k';
execute s using 'x', 'x', 'x';
select k, coalesce(e, 'x'), typeof(coalesce(e, 'x')), collation(coalesce(e, 'x')) from t_27482 order by k;

-- an ENUM member, an integer and NULL bound to the same statement: the result is VARCHAR for every bind
execute s using 'a', 'a', 'a';
execute s using 1, 1, 1;
execute s using null, null, null;
deallocate prepare s;

-- the host variable first, and more than two arguments
prepare s from 'select k, coalesce(?, e), coalesce(e, ?, ''z''), coalesce(null, ?, e) from t_27482 order by k';
execute s using 'x', 'x', 'x';
select k, coalesce('x', e), coalesce(e, 'x', 'z'), coalesce(null, 'x', e) from t_27482 order by k;
deallocate prepare s;

-- GREATEST and LEAST
prepare s from 'select k, greatest(e, ?), least(e, ?) from t_27482 order by k';
execute s using 'b', 'b';
select k, greatest(e, 'b'), least(e, 'b') from t_27482 order by k;
deallocate prepare s;

-- an ENUM column with another collation keeps its collation
prepare s from 'select k, coalesce(eb, ?), collation(coalesce(eb, ?)) from t_27482 order by k';
execute s using 'x', 'x';
select k, coalesce(eb, 'x'), collation(coalesce(eb, 'x')) from t_27482 order by k;
deallocate prepare s;

-- a session variable is undetermined at compile time like a host variable
set @v_27482 = 'x';
select k, coalesce(e, @v_27482), greatest(e, @v_27482) from t_27482 order by k;
drop variable @v_27482;

drop table t_27482;
