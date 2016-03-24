--+ holdcas on;
SELECT COUNT(*) FROM base_c0
       WHERE attr1_int_unique_idx = attr16_objpath.attr1_int_unique_idx
         AND attr1_int_unique_idx = 10;
SELECT COUNT(*) FROM virtual_c1
       WHERE (attr1_int_unique_idx = attr16_objpath.attr1_int_unique_idx)
         AND (attr1_int_unique_idx < 10)
         AND (attr16_objpath.attr1_int_unique_idx < 10);
