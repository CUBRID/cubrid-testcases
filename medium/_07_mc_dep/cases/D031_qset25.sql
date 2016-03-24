--+ holdcas on;
SELECT COUNT(*) FROM virtual_c2
       WHERE attr1_int_unique_idx <> attr16_objpath.attr1_int_unique_idx
         AND attr16_objpath.attr1_int_unique_idx <> 
                    attr16_objpath.attr16_objpath.attr1_int_unique_idx
         AND attr16_objpath.attr16_objpath.attr1_int_unique_idx = 
                    attr11_int_2vals_idx;
SELECT attr1_int_unique_idx FROM base_c0
       WHERE attr1_int_unique_idx = attr16_objpath.attr1_int_unique_idx
         AND attr16_objpath.attr1_int_unique_idx = 
                    attr16_objpath.attr16_objpath.attr1_int_unique_idx
         AND attr16_objpath.attr6_longstr_noidx <> 
                   attr16_objpath.attr16_objpath.attr6_longstr_noidx order by 1;
