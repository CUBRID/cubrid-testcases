--+ holdcas on;
SELECT COUNT(*) FROM x_base_c0
        WHERE attr15_int_50vals_idx  = 24
          AND attr14_int_10vals_idx  > 2
          AND attr11_int_2vals_idx   < 1;
SELECT attr1_int_unique_idx, attr2_str_unique_idx FROM x_virtual_c1
        WHERE attr1_int_unique_idx > 10
          AND attr11_int_2vals_idx = 0
          AND attr2_str_unique_idx > 'A' order by 1;
SELECT * FROM x_base_c2
        WHERE (attr1_int_unique_idx     = 1
               AND attr2_str_unique_idx = 'A')
           OR (attr1_int_unique_idx     = 100
               AND attr2_str_unique_idx = 'WD') order by 1;
SELECT attr1_int_unique_idx FROM x_virtual_c0
        WHERE attr1_int_unique_idx NOT BETWEEN 100 AND 1100
          AND attr10_money_idx     < $2211.38 order by 1;
