autocommit off;
DELETE FROM base_c1 
       WHERE  attr15_int_50vals_idx < 12
         AND  attr16_objpath.attr12_int_4vals_idx = 0;
DELETE FROM virtual_c2 
       WHERE  attr15_int_50vals_idx < 24
         AND  attr16_objpath.attr12_int_4vals_idx = 1;
DELETE FROM base_c0 
       WHERE  attr15_int_50vals_idx < 36
         AND  attr16_objpath.attr12_int_4vals_idx = 2;
DELETE FROM virtual_c1 
       WHERE  attr15_int_50vals_idx < 50
         AND  attr16_objpath.attr12_int_4vals_idx = 3;
ROLLBACK WORK;
