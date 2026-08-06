/* 10. Verify TO_NUMBER behavior */

-- Verify scale/format parsing boundary and overflow behavior.

-- ===========================================================================
-- Section 1: Valid conversions
-- ===========================================================================
evaluate '1. valid conversions';
drop table if exists foo;
SELECT TO_NUMBER('99999999999999999999999999999999999999');

SELECT TO_NUMBER('9999999999999999999999999999999999999999999',
                 '99999999999999999999999999999999999999999999');

SELECT TO_NUMBER('9999999999999999999999999999999999999999999',
                 '99999999999999999999999999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000');

SELECT TO_NUMBER('-9999999999999999999999999999999999999999999',
                 '99999999999999999999999999999999999999999999');

SELECT TO_NUMBER('-9999999999999999999999999999999999999999999',
                 '99999999999999999999999999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000');

SELECT TO_NUMBER('0.000000000000001','9.999999999999999');

-- ===========================================================================
-- Section 2: Format mismatch / overflow
-- ===========================================================================
evaluate '2. format mismatch / overflow (error)';
-- Expect format mismatch error
SELECT TO_NUMBER('999999999999999999999999999999999999999');

-- Expect numeric overflow (scale/precision overflow)
SELECT TO_NUMBER('0.0000000000000001','9.9999999999999999');


-- ===========================================================================
-- Section 3: Class-based tests
-- ===========================================================================
evaluate '3. class-based tests';
create class foo(f varchar(10));
insert into foo values('1');
insert into foo values('2');
insert into foo values('3');
insert into foo values('4');
insert into foo values('5');

select /*+ recompile */ to_number(f) from foo;
select /*+ recompile */ to_number(f) from foo order by 1;
select /*+ recompile */ to_number(f) from foo order by 1 desc;

-- Known bug on develop: format mask as numeric literal
select /*+ recompile */ to_number(f,99999999999999999999999999999999999999) from foo order by 1;

drop table if exists foo;

select 
  *
from (
SELECT 
TO_NUMBER('-9999999999999999999999999999999999999999999',
                 '99999999999999999999999999999999999999999999')
UNION ALL				 
SELECT TO_NUMBER('99999999999999999999999999999999999999')
UNION ALL	
SELECT TO_NUMBER('9999999999999999999999999999999999999999999',
                 '99999999999999999999999999999999999999999999')
)
order by 1;
drop table if exists foo;
