autocommit off;
SET TRANSACTION ISOLATION LEVEL
    REPEATABLE READ CLASS, READ COMMITTED INSTANCES;
DELETE FROM base_c0
       WHERE attr11_int_2vals_idx = 1;
DELETE FROM virtual_c1
       WHERE attr12_int_4vals_idx = 0;
DELETE FROM base_c2
       WHERE attr13_int_5vals_idx = 3;
DELETE FROM virtual_c0
       WHERE attr14_int_10vals_idx = 4
          OR attr14_int_10vals_idx = 9;
DELETE FROM base_c1
       WHERE attr15_int_50vals_idx = 1
          OR attr15_int_50vals_idx = 18
          OR attr15_int_50vals_idx = 27
          OR attr15_int_50vals_idx = 44
          OR attr15_int_50vals_idx = 47;
ROLLBACK WORK;
