autocommit off;
DELETE FROM x_virtual_c2
       WHERE attr4_float_idx IS NULL;
COMMIT WORK;
