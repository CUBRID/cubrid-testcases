--+ holdcas on;
SELECT COUNT(attr1_int_unique_idx), COUNT(attr11_int_2vals_idx)
       FROM base_c1
           WHERE attr11_int_2vals_idx     >= 0 order by 1,2;
SELECT attr1_int_unique_idx, attr14_int_10vals_idx  FROM virtual_c2
        WHERE attr14_int_10vals_idx    > 2
          AND attr14_int_10vals_idx    < 8 order by 1,2;
SELECT attr1_int_unique_idx, attr13_int_5vals_idx     FROM base_c0
        WHERE attr13_int_5vals_idx     = 0 order by 1,2;
SELECT attr1_int_unique_idx, attr14_int_10vals_noidx  FROM virtual_c1
        WHERE attr14_int_10vals_noidx  = 0 order by 1,2;
SELECT attr1_int_unique_idx, attr15_int_50vals_idx   FROM base_c2
        WHERE attr15_int_50vals_idx   = 0 order by 1,2;
