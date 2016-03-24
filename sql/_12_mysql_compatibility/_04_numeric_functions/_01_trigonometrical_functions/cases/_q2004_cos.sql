SELECT COS(0) from db_root;
SELECT COS(1) from db_root;
SELECT COS(-1) from db_root;
SELECT COS(PI()) from db_root;
SELECT COS(PI()*pi()) from db_root;
SELECT to_char(9223372036854775807, '9.999EEEE') from db_root;
SELECT to_char(-9223372036854775807, '9.999EEEE') from db_root;
SELECT COS(COS(COS(COS(COS(COS(COS(COS(COS(1))))))))) from db_root;
