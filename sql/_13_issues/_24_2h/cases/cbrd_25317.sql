-- This test case verifies the following issue: CBRD-25317.
-- Validate that the query optimizer rewrites Oracle-style LEFT OUTER JOIN as an INNER JOIN after the host variable is bound during the EXECUTE phase, 
-- i.e. when there is a method call and host variables are used in the WHERE clause.

drop if exists tbl;
create table tbl (col_a int, col_b int);
insert into tbl values (1, 1), (2, 2), (3, 3);

-- function, returns int + 1
create or replace function test_fc(i int) RETURN int 
as language java 
name 'SpTest.testInt(int) return int';

set trace on;

evaluate '1. A non-ANSI outer join can be rewritten as an inner join (bind X, sp X)';
-- No bind variables are used.
-- Java stored procedure is not used.

prepare q1 from 'select /*+ recompile */ ''q1: ''  || a.col_b from tbl a, tbl b where a.col_a = b.col_a(+) and b.col_b = 1';
execute q1;
deallocate prepare q1;
show trace;

select /*+ recompile */ 'q1: ' || a.col_b from tbl a, tbl b where a.col_a = b.col_a(+) and b.col_b = 1;
show trace;


evaluate '2. An ANSI outer join can be rewritten as an inner join (bind X, sp X)';
-- No bind variables are used.
-- Java stored procedure is not used.

prepare q2 from 'select /*+ recompile */ ''q2: ''  || a.col_b from tbl a left outer join tbl b on a.col_a = b.col_a where b.col_b = 1';
execute q2;
deallocate prepare q2;
show trace;

select /*+ recompile */ 'q2: ' || a.col_b from tbl a left outer join tbl b on a.col_a = b.col_a where b.col_b = 1;
show trace;


evaluate '3. A non-ANSI outer join can be rewritten as an inner join (bind O, sp X)';
-- Bind variables are used.
-- Java stored procedure is not used.

prepare q3 from 'select /*+ recompile */ ''q3: ''  || a.col_b from tbl a, tbl b where a.col_a = b.col_a(+) and b.col_b = ?';
execute q3 using 1;
deallocate prepare q3;
show trace;


evaluate '4. An ANSI outer join can be rewritten as an inner join (bind O, sp X)';
-- Bind variables are used.
-- Java stored procedure is not used.

prepare q4 from 'select /*+ recompile */ ''q4: ''  || a.col_b from tbl a left outer join tbl b on a.col_a = b.col_a where b.col_b = ?';
execute q4 using 1;
deallocate prepare q4;
show trace;


evaluate '5. A non-ANSI outer join can be rewritten as an inner join (bind X, sp O)';
-- No bind variables are used.
-- Java stored procedure is used.

prepare q5 from 'select /*+ recompile */ ''q5: ''  || test_fc (a.col_b) from tbl a, tbl b where a.col_a = b.col_a(+) and b.col_b = 1';
execute q5;
deallocate prepare q5;
show trace;

select /*+ recompile */ 'q5: ' || test_fc (a.col_b) from tbl a, tbl b where a.col_a = b.col_a(+) and b.col_b = 1;
show trace;


evaluate '6. An ANSI outer join can be rewritten as an inner join (bind X, sp O)';
-- No bind variables are used.
-- Java stored procedure is used.

prepare q6 from 'select /*+ recompile */ ''q6: ''  || test_fc (a.col_b) from tbl a left outer join tbl b on a.col_a = b.col_a where b.col_b = 1';
execute q6;
deallocate prepare q6;
show trace;

select /*+ recompile */ 'q6: ' || test_fc (a.col_b) from tbl a left outer join tbl b on a.col_a = b.col_a where b.col_b = 1;
show trace;


evaluate '7. A non-ANSI outer join can be rewritten as an inner join (bind O, sp O)';
-- Bind variables are used.
-- Java stored procedure is used.

prepare q7 from 'select /*+ recompile */ ''q7: ''  || test_fc (a.col_b) from tbl a, tbl b where a.col_a = b.col_a(+) and b.col_b = ?';
execute q7 using 1;
deallocate prepare q7;
show trace;


evaluate '8. An ANSI outer join can be rewritten as an inner join (bind O, sp O)';
-- Bind variables are used.
-- Java stored procedure is used.

prepare q8 from 'select /*+ recompile */ ''q8: ''  || test_fc (a.col_b) from tbl a left outer join tbl b on a.col_a = b.col_a where b.col_b = ?';
execute q8 using 1;
deallocate prepare q8;
show trace;


evaluate '9. A non-ANSI outer join can be rewritten as an inner join ([non-where-clause] bind O , sp O)';
-- Bind variables are used, with the bind variable placed in different positions.
-- Java stored procedure is used.

prepare q9 from 'select ''q9: ''  || test_fc (?) from tbl a, tbl b where a.col_a = b.col_a(+) and b.col_b = 1';
execute q9 using 1;
deallocate prepare q9;
show trace;


evaluate '10. An ANSI outer join can be rewritten as an inner join ([non-where-clause] bind O , sp O)';
-- Bind variables are used, with the bind variable placed in different positions.
-- Java stored procedure is used.

prepare q10 from 'select ''q10: '' || test_fc (?) from tbl a left outer join tbl b on a.col_a = b.col_a where b.col_b = 1';
execute q10 using 1;
deallocate prepare q10;
show trace;


evaluate '11. A non-ANSI outer join (w/ another table) can be rewritten as an inner join (bind O, sp O)';
-- Joined with another table using inner join.
-- Bind variables are used.
-- Java stored procedure is used.

prepare q11 from 'select /*+ recompile */ ''q11: ''  || test_fc (a.col_b) from tbl a, tbl b, tbl c where a.col_a = b.col_a(+) and b.col_b = ? and a.col_a = c.col_a';
execute q11 using 1;
deallocate prepare q11;
show trace;


evaluate '12. A non-ANSI outer join (w/ another table) can be rewritten as an inner join (bind O, sp O)';
-- Joined with another table using non-ANSI outer join.
-- Bind variables are used.
-- Java stored procedure is used.

prepare q12 from 'select /*+ recompile */ ''q12: ''  || test_fc (a.col_b) from tbl a, tbl b, tbl c where a.col_a(+) = b.col_a and a.col_b = ? and b.col_a(+) = c.col_a';
execute q12 using 1;
deallocate prepare q12;
show trace;


evaluate '13. A non-ANSI outer join (w/ another table via cross join) can be rewritten as an inner join (bind O, sp O)';
-- Joined with another table using cross join.
-- Bind variables are used.
-- Java stored procedure is used.

prepare q13 from 'select /*+ recompile */ ''q13: '' || test_fc (a.col_b) from tbl a, tbl b, tbl c where a.col_a = b.col_a(+) and b.col_b = ?';
execute q13 using 1;
deallocate prepare q13;
show trace;

set trace off;

drop table if exists tbl;
drop function test_fc;

