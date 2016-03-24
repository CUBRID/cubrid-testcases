autocommit off;
SET TRANSACTION ISOLATION LEVEL
    REPEATABLE READ CLASS, READ COMMITTED INSTANCES;
UPDATE base_c0
         SET attr11_int_2vals_idx = 0
       WHERE attr11_int_2vals_idx = 1;
UPDATE virtual_c1
         SET attr12_int_4vals_idx = - attr12_int_4vals_idx
       WHERE attr12_int_4vals_idx = 0;
UPDATE base_c2
         SET attr13_int_5vals_idx = 0
       WHERE attr13_int_5vals_idx = 4;
UPDATE virtual_c0
         SET attr14_int_10vals_idx = 3
       WHERE attr14_int_10vals_idx = 4
          OR attr14_int_10vals_idx = 9;
UPDATE base_c1
         SET attr15_int_50vals_idx = attr15_int_50vals_idx + 50
       WHERE attr15_int_50vals_idx = 1
          OR attr15_int_50vals_idx = 17
          OR attr15_int_50vals_idx = 25
          OR attr15_int_50vals_idx = 37
          OR attr15_int_50vals_idx = 48;
ROLLBACK WORK;
