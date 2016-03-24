--+ holdcas on;
set system parameters 'compat_mode=mysql';

SELECT ASIN(0.2) from db_root;
        
SELECT ASIN('foo') from db_root;

SELECT ASIN('12') from db_root;

SELECT ASIN(NULL) from db_root;

select asin(123456789012345.12345) from db_root;

set system parameters 'compat_mode=cubrid';
commit;
--+ holdcas off;
