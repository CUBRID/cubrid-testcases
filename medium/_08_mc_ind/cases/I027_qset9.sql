--+ holdcas on;
SELECT COUNT(*) FROM x_base_c0 a, x_virtual_c1 b
       WHERE a.attr1_int_unique_idx = b.attr1_int_unique_idx;
SELECT COUNT(*) FROM x_base_c2 a, x_virtual_c0 b
       WHERE (a.attr1_int_unique_idx = b.attr1_int_unique_idx)
         AND (a.attr1_int_unique_idx = 10);
