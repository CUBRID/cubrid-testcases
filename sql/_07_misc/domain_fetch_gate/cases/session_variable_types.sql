--+ holdcas on;
-- workspace#366 (map #312, dpin-17h): a session variable the statement reads holds one type for the statement - its
-- value's type when the execution starts and the types its assignments give it (a column that is NULL in a row still
-- assigns the column's type). Another type without a cast is an error before any row (U3), and strings of one codeset
-- and collation are one type whatever their length (U4). A string's class is the one the variable's value gives when
-- the execution starts. Every other answer here is develop's.
drop table if exists sv_t;
drop table if exists sv_u;
create table sv_t (k int primary key, a int, s varchar(10) collate utf8_bin, c char(5), d double, dt date);
insert into sv_t values (1, NULL, NULL, NULL, NULL, NULL);
insert into sv_t values (2, 10, 'ab', 'cd', 1.5, date'2024-01-02');
insert into sv_t values (3, 20, 'xyz', 'ef', 2.5, date'2024-01-03');
create table sv_u (k int, v int);
insert into sv_u values (1, 0), (2, 0), (3, 0);

-- [U1] a statement that only assigns the variable, one that only reads it
set @sv_a = 1;
select @sv_a := 'abc' from db_root;
select @sv_a, typeof(@sv_a) from db_root;
set @sv_b = 'abc';
select @sv_b, typeof(@sv_b), @sv_b || 'x' from db_root;

-- [U2] a column assigns its type in a row where it is NULL, a variable without a type takes the assignment's type
set @sv_c = NULL;
select k, @sv_c := a, @sv_c + a from sv_t order by k;
set @sv_d = 5;
select @sv_d := NULL, @sv_d + 1 from db_root;
set @sv_e = NULL;
select k, @sv_e := ifnull(@sv_e, 0) + 1 from sv_t order by k;
select k, @sv_f := @sv_f + 1 from sv_t, (select @sv_f := 0) z order by k;

drop variable @sv_a, @sv_b, @sv_c, @sv_d, @sv_e, @sv_f;

-- [U3] another type without a cast is an error before any row, and the variable keeps its value
set @sv_g = 0;
select k, @sv_g := @sv_g + d from sv_t order by k;
select @sv_g from db_root;
set @sv_g = 0;
select k, @sv_g := cast(@sv_g + ifnull(d, 0) as int) from sv_t order by k;
set @sv_h = 'a';
select @sv_h := 1, @sv_h + 1 from db_root;
set @sv_i = 0;
select k, @sv_i := @sv_i + cast(k as bigint) from sv_t order by k;
set @sv_j = 100;
update sv_u set v = (@sv_j := @sv_j + 1) order by k desc;
update sv_u set v = (@sv_j := @sv_j + 0.5) order by k desc;
select k, v, @sv_j from sv_u order by k;

drop variable @sv_g, @sv_h, @sv_i, @sv_j;

-- [U4] strings of one codeset and collation are one type, another collation is another type
set @sv_k = '';
select k, @sv_k := concat(@sv_k, ifnull(s, '-')) from sv_t order by k;
set @sv_l = 'x';
select k, @sv_l := @sv_l || ifnull(c, 'zz') from sv_t order by k;
set @sv_m = 'a';
select @sv_m := s collate utf8_en_ci, @sv_m from sv_t order by k;

-- [READ] the consumers over a read: a comparison, IN, a sort key, GROUP BY, an analytic
set @sv_n = 2;
select k from sv_t where k >= @sv_n order by k;
select k from sv_t where k in (@sv_n, 3) order by k;
select k, k * @sv_n as v from sv_t order by k * @sv_n desc;
select k mod 2 as g, sum(ifnull(a, 0) + @sv_n) from sv_t group by k mod 2 order by 1;
select k, sum(ifnull(a, 0) + @sv_n) over (order by k) from sv_t order by k;

-- [CLASS] a string's class is the one the variable's value gives when the execution starts
set @sv_o = '1.5';
select median(@sv_o) from sv_t;
select median(@sv_o) from (select (@sv_o := '01:00:00') x from db_root) d, sv_t;

drop variable @sv_k, @sv_l, @sv_m, @sv_n, @sv_o;
drop table sv_t;
drop table sv_u;
--+ holdcas off;
