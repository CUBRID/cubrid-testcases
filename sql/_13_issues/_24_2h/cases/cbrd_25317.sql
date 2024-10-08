-- This test case verifies the following issue: CBRD-25317.
-- Validate that the query optimizer rewrites Oracle-style LEFT OUTER JOIN as an INNER JOIN after the host variable is bound during the EXECUTE phase, 
-- i.e. when there is a method call and host variables are used in the WHERE clause.

drop if exists tbl;
create table tbl (col_a int, col_b int);

create or replace function hello (i int) return int
as language java
name 'SpCubrid.hello(int) return int';

set trace on;

evaluate '1. A non-ANSI outer join can be rewritten as an inner join';
-- No bind variables are used.
-- Java stored procedure is not used.

prepare q1 from 'select /*+ recompile */ ''q1: ''  || a.col_b from tbl a, tbl b where a.col_a = b.col_a(+) and b.col_b = 1';
execute q1;
show trace;

select 'q1: ' || a.col_b from tbl a, tbl b where a.col_a = b.col_a(+) and b.col_b = 1;


evaluate '2. An ANSI outer join can be rewritten as an inner join';
-- No bind variables are used.
-- Java stored procedure is not used.

prepare q2 from 'select /*+ recompile */ ''q2: ''  || a.col_b from tbl a left outer join tbl b on a.col_a = b.col_a where b.col_b = 1';
execute q2;
show trace;

select 'q2: ' || a.col_b from tbl a left outer join tbl b on a.col_a = b.col_a where b.col_b = 1;


evaluate '3. A non-ANSI outer join can be rewritten as an inner join';
-- Bind variables are used.
-- Java stored procedure is not used.

prepare q3 from 'select /*+ recompile */ ''q3: ''  || a.col_b from tbl a, tbl b where a.col_a = b.col_a(+) and b.col_b = ?';
execute q3 using 1;
show trace;


evaluate '4. An ANSI outer join can be rewritten as an inner join';
-- Bind variables are used.
-- Java stored procedure is not used.

prepare q4 from 'select /*+ recompile */ ''q4: ''  || a.col_b from tbl a left outer join tbl b on a.col_a = b.col_a where b.col_b = ?';
execute q4 using 1;
show trace;


evaluate '5. A non-ANSI outer join can be rewritten as an inner join';
-- No bind variables are used.
-- Java stored procedure is used.

prepare q5 from 'select ''q5: ''  || hello (a.col_b) from tbl a, tbl b where a.col_a = b.col_a(+) and b.col_b = 1';
execute q5;
show trace;

select 'q5: ' || hello (a.col_b) from tbl a, tbl b where a.col_a = b.col_a(+) and b.col_b = 1;


evaluate '6. An ANSI outer join can be rewritten as an inner join';
-- No bind variables are used.
-- Java stored procedure is used.

prepare q6 from 'select ''q6: ''  || hello (a.col_b) from tbl a left outer join tbl b on a.col_a = b.col_a where b.col_b = 1';
execute q6;
show trace;

select 'q6: ' || hello (a.col_b) from tbl a left outer join tbl b on a.col_a = b.col_a where b.col_b = 1;


evaluate '7. A non-ANSI outer join can be rewritten as an inner join';
-- Bind variables are used.
-- Java stored procedure is used.

prepare q7 from 'select ''q7: ''  || hello (a.col_b) from tbl a, tbl b where a.col_a = b.col_a(+) and b.col_b = ?';
execute q7 using 1;
show trace;


evaluate '8. An ANSI outer join can be rewritten as an inner join';
-- Bind variables are used.
-- Java stored procedure is used.

prepare q8 from 'select ''q8: ''  || hello (a.col_b) from tbl a left outer join tbl b on a.col_a = b.col_a where b.col_b = ?';
execute q8 using 1;
show trace;


evaluate '9. A non-ANSI outer join can be rewritten as an inner join';
-- Joined with another table using inner join.
-- Bind variables are used.
-- Java stored procedure is used.

prepare q9 from 'select ''q9: ''  || hello (a.col_b) from tbl a, tbl b, tbl c where a.col_a = b.col_a(+) and b.col_b = ? and a.col_a = c.col_a';
execute q9 using 1;
show trace;


evaluate '10. A non-ANSI outer join can be rewritten as an inner join';
-- Joined with another table using non-ANSI outer join.
-- Bind variables are used.
-- Java stored procedure is used.

prepare q10 from 'select ''q10: ''  || hello (a.col_b) from tbl a, tbl b, tbl c where a.col_a(+) = b.col_a and a.col_b = ? and b.col_a(+) = c.col_a';
execute q10 using 1;
show trace;


evaluate '11. A non-ANSI outer join can be rewritten as an inner join';
-- Joined with another table using cross join.
-- Bind variables are used.
-- Java stored procedure is used.

prepare q11 from 'select ''q11: '' || hello (a.col_b) from tbl a, tbl b, tbl c where a.col_a = b.col_a(+) and b.col_b = ?';
execute q11 using 1;
show trace;

set trace off;

drop table if exists tbl;
