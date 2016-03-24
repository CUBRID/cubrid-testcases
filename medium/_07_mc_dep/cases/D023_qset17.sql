--+ holdcas on;
SELECT attr12_int_4vals_noidx, attr15_int_50vals_idx, COUNT(*)
       FROM base_c1
       GROUP BY attr12_int_4vals_noidx, attr15_int_50vals_idx
       ORDER BY attr12_int_4vals_noidx;
SELECT attr15_int_50vals_idx      FROM virtual_c2
       GROUP BY attr15_int_50vals_idx
       HAVING COUNT(*) > 1;
SELECT COUNT(attr10_money_idx)    FROM base_c0
       WHERE attr3_smallint_idx BETWEEN 1 and 999
         AND not (attr4_float_idx BETWEEN -320000 and 320000)
         AND attr5_double_idx > 600000000
         AND attr10_money_idx < -50000000;
SELECT COUNT(*) from virtual_c1
       WHERE attr11_int_2vals_idx    = 2
         AND attr11_int_2vals_noidx  = 2
         AND attr14_int_10vals_idx   = 3
         AND attr14_int_10vals_noidx = 3;
SELECT COUNT(*) from base_c2
       WHERE attr11_int_2vals_idx = 2 
         AND NOT attr14_int_10vals_idx = 3;
