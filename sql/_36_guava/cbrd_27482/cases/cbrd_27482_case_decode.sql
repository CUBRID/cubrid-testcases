/*
 * CBRD-27482 (CBRD-27573): CASE, DECODE and IF with an ENUM column and a host variable.
 *
 * The common type of an ENUM branch and a host variable branch was taken as ENUM, and coercing
 * the host variable to ENUM failed: a debug build asserted in the client at PREPARE, and a
 * release build failed at PREPARE with "Internal error- reporting semantic error.".
 * The common type is now VARCHAR, as with a string literal, so a host variable value that is
 * not an ENUM member ('z') is returned as is. Each prepared statement must return the same
 * value, type and collation as the same statement with a literal.
 */
drop table if exists t_27482_c;
create table t_27482_c (k int primary key, e enum('a', 'b') collate utf8_bin, eb enum('a', 'b') collate utf8_en_ci);
insert into t_27482_c values (1, 'a', 'a'), (2, 'b', 'b'), (3, null, null);

-- the queries of CBRD-27573: the host variable in the ELSE branch, in the THEN branch, and in DECODE
prepare s from 'select k, case when k = 1 then e else ? end from t_27482_c order by k';
execute s using 'z';
execute s using 'a';
deallocate prepare s;
prepare s from 'select k, case when k = 1 then ? else e end from t_27482_c order by k';
execute s using 'z';
deallocate prepare s;
prepare s from 'select k, decode(k, 1, e, ?) from t_27482_c order by k';
execute s using 'z';
deallocate prepare s;
select k, case when k = 1 then e else 'z' end, case when k = 1 then 'z' else e end, decode(k, 1, e, 'z') from t_27482_c order by k;

-- a simple CASE with three branches
prepare s from 'select k, case k when 1 then e when 2 then ? else ''z'' end from t_27482_c order by k';
execute s using 'y';
select k, case k when 1 then e when 2 then 'y' else 'z' end from t_27482_c order by k;
deallocate prepare s;

-- the result type and collation, and an integer and NULL bound to the same statement
prepare s from 'select k, case when k = 1 then e else ? end, typeof(case when k = 1 then e else ? end), collation(case when k = 1 then e else ? end) from t_27482_c order by k';
execute s using 'z', 'z', 'z';
execute s using 1, 1, 1;
execute s using null, null, null;
select k, case when k = 1 then e else 'z' end, typeof(case when k = 1 then e else 'z' end), collation(case when k = 1 then e else 'z' end) from t_27482_c order by k;
deallocate prepare s;

-- an ENUM column with another collation keeps its collation
prepare s from 'select k, case when k = 1 then eb else ? end, collation(case when k = 1 then eb else ? end) from t_27482_c order by k';
execute s using 'z', 'z';
select k, case when k = 1 then eb else 'z' end, collation(case when k = 1 then eb else 'z' end) from t_27482_c order by k;
deallocate prepare s;

-- IF, which takes the type of the other branch for a host variable branch
prepare s from 'select k, if(k = 1, e, ?), if(k = 1, ?, e), typeof(if(k = 1, e, ?)) from t_27482_c order by k';
execute s using 'z', 'z', 'z';
select k, if(k = 1, e, 'z'), if(k = 1, 'z', e), typeof(if(k = 1, e, 'z')) from t_27482_c order by k;
deallocate prepare s;

drop table t_27482_c;
