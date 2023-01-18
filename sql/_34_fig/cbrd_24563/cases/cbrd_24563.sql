-- CBRD-24563 : system parameter regexp_engine is added.
-- Can choose the regexp library as 're2' or 'cppstd'.
-- Verifies system parmeter in same session.

-- positive case
-- verify value : re2
set system parameters 'regexp_engine=re2';
select ('aabbb' rlike 'ab{0,49995}$');
select ('aabbb' rlike 'ab{-1,3}$');

-- verify value : cppstd
set system parameters 'regexp_engine=cppstd';
select ('aabbb' rlike 'ab{0,49995}$');
select ('aabbb' rlike 'ab{-1,3}$');

-- verify value : default (re2)
set system parameters 'regexp_engine=default';
select ('aabbb' rlike 'ab{0,49995}$');
select ('aabbb' rlike 'ab{-1,3}$');

-- negative case
-- CUBRID ignore if the value is empty string.
set system parameters 'regexp_engine=' '';
set system parameters 'regexp_engine= ';

set system parameters 'regexp_engine=123';
set system parameters 'regexp_engine=re';
set system parameters 'regexp_engine=re@';

set system parameters 'regexp_engine=default';
