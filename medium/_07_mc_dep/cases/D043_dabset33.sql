autocommit off;
DELETE FROM virtual_c2
       WHERE attr4_float_idx IS NULL;
ROLLBACK WORK;
