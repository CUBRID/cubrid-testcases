autocommit off;
DELETE FROM x_base_c1 
       WHERE  attr15_int_50vals_idx < 12
         AND  attr16_objpath.attr12_int_4vals_idx = 0;
DELETE FROM x_virtual_c2 
       WHERE  attr15_int_50vals_idx < 24
         AND  attr16_objpath.attr12_int_4vals_idx = 1;
DELETE FROM x_base_c0 
       WHERE  attr15_int_50vals_idx < 36
         AND  attr16_objpath.attr12_int_4vals_idx = 2;
DELETE FROM x_virtual_c1 
       WHERE  attr15_int_50vals_idx < 50
         AND  attr16_objpath.attr12_int_4vals_idx = 3;
COMMIT WORK;
