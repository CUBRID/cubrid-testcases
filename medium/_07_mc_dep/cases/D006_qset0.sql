--+ holdcas on;
SELECT COUNT(*) FROM virtual_c2
       WHERE attr1_int_unique_idx >= 0;
SELECT COUNT(*) FROM base_c0
       WHERE attr1_int_unique_noidx >= 50;
SELECT COUNT(*) FROM virtual_c1
       WHERE attr4_float_idx  IS NULL
         AND attr8_date_noidx IS NOT NULL;
SELECT COUNT(*) FROM base_c2
       WHERE attr9_utime_noidx IS NULL
         AND attr10_money_idx  IS NULL;
