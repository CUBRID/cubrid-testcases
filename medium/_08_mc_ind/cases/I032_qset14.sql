--+ holdcas on;
SELECT COUNT(*) FROM x_base_c0 a, x_virtual_c1 b, x_base_c2 c
       WHERE (a.attr2_str_unique_idx = b.attr2_str_unique_idx)
         AND (b.attr1_int_unique_idx = c.attr1_int_unique_idx)
         AND (b.attr1_int_unique_idx < 10);
