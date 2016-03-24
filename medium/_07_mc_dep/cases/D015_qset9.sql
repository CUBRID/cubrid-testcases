--+ holdcas on;
SELECT COUNT(*) FROM base_c0 a, virtual_c1 b
       WHERE a.attr1_int_unique_idx = b.attr1_int_unique_idx;
SELECT COUNT(*) FROM base_c2 a, virtual_c0 b
       WHERE (a.attr1_int_unique_idx = b.attr1_int_unique_idx)
         AND (a.attr1_int_unique_idx = 10);
