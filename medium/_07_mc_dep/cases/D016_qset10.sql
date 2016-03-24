--+ holdcas on;
SELECT COUNT(*) FROM virtual_c2 a, base_c0 b
       WHERE (a.attr1_int_unique_idx = b.attr1_int_unique_idx)
         AND (a.attr1_int_unique_idx < 10)
         AND (b.attr1_int_unique_idx < 10);
SELECT COUNT(*) FROM virtual_c1 a, base_c2 b
       WHERE (a.attr1_int_unique_idx = b.attr1_int_unique_idx)
         AND (a.attr1_int_unique_idx < 10);
