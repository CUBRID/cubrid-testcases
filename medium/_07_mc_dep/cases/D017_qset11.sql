--+ holdcas on;
SELECT COUNT(*) FROM virtual_c2 a, base_c0 b
       WHERE (a.attr2_str_unique_idx = b.attr2_str_unique_idx)
         AND (a.attr2_str_unique_idx = 'A');
SELECT COUNT(*) FROM virtual_c1 a, base_c2 b
       WHERE (a.attr2_str_unique_idx = b.attr2_str_unique_idx)
         AND (b.attr2_str_unique_idx < 'ZA');
