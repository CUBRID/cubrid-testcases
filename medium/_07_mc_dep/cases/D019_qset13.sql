--+ holdcas on;
SELECT COUNT(*) FROM base_c2 a, virtual_c0 b, base_c1 c
       WHERE (a.attr1_int_unique_idx = b.attr1_int_unique_idx)
         AND (b.attr1_int_unique_idx = c.attr1_int_unique_idx)
         AND (a.attr1_int_unique_idx < 10);
