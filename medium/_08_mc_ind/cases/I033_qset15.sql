--+ holdcas on;
SELECT COUNT(*) FROM x_virtual_c1 a, x_base_c2 b, x_virtual_c0 c
       WHERE (a.attr1_int_unique_idx = b.attr1_int_unique_idx)
         AND (b.attr1_int_unique_idx = c.attr1_int_unique_idx)
         AND (b.attr1_int_unique_idx = 10)
         AND (b.attr10_money_noidx   = $2340.23);
