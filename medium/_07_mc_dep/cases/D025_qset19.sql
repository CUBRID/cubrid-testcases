--+ holdcas on;
SELECT MIN(attr1_int_unique_noidx), (SELECT MAX(attr1_int_unique_idx)
                                            FROM virtual_c1)
       FROM base_c2;
SELECT attr2_str_unique_noidx, attr1_int_unique_idx
       FROM virtual_c0
       WHERE attr1_int_unique_idx = (SELECT MAX(attr1_int_unique_idx)
                                     FROM base_c1) order by 1;
SELECT attr2_str_unique_noidx, attr1_int_unique_idx
       FROM virtual_c2
       WHERE attr14_int_10vals_idx = SOME
             (SELECT attr14_int_10vals_idx FROM base_c0
                     WHERE attr15_int_50vals_noidx = 30) order by 1;
