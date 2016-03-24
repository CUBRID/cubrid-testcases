--+ holdcas on;
SELECT attr6_longstr_idx from virtual_c2
       WHERE attr6_longstr_idx    LIKE 'A%' order by 1;
SELECT attr6_longstr_noidx from base_c0
       WHERE attr6_longstr_noidx  LIKE '%A' order by 1;
SELECT COUNT(*) from virtual_c1
       WHERE  attr1_int_unique_idx = 3
         AND  attr6_longstr_idx   LIKE 'A%' order by 1;
SELECT COUNT(attr1_int_unique_noidx) from base_c2
       WHERE  attr1_int_unique_noidx = 3
         AND  attr6_longstr_noidx LIKE 'A%' order by 1;
