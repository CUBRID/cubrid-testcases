create table tinyint_test (i tinyint, t TINYINT);

show columns in tinyint_test;

insert into tinyint_test values(10, 10);

insert into tinyint_test values(100000000, 100000000);

ALTER TABLE tinyint_test ADD COLUMN new_col tinyint FIRST;

show columns in tinyint_test;

drop table tinyint_test;

select if (cast(2.3 as tinyint) = 2,'ok','nok');

CREATE FUNCTION "my_func"("i" TINYINT) RETURN TINYINT AS LANGUAGE JAVA NAME 'myClass.myFuncB(java.lang.Short) return short';

select return_type from db_stored_procedure where sp_name = 'my_func';

select data_type from db_stored_procedure_args where sp_name = 'my_func';

drop function my_func;




create table mediumint_test (i mediumint, t MEDIUMINT);

show columns in mediumint_test;

insert into mediumint_test values(10, 10);

insert into mediumint_test values(10000000000, 10000000000);

ALTER TABLE mediumint_test ADD COLUMN new_col mediumint FIRST;

show columns in mediumint_test;

drop table mediumint_test;

select if (cast(2.3 as mediumint) = 2,'ok','nok');

CREATE FUNCTION "my_func"("i" MEDIUMINT) RETURN MEDIUMINT AS LANGUAGE JAVA NAME 'myClass.myFuncB(java.lang.Integer) return integer';

select return_type from db_stored_procedure where sp_name = 'my_func';

select data_type from db_stored_procedure_args where sp_name = 'my_func';

drop function my_func;




create table integerpadd_test (i integer(32), t int(32));

show columns in integerpadd_test;

insert into integerpadd_test values(10, 10);

select * from integerpadd_test;

ALTER TABLE integerpadd_test ADD COLUMN new_col1 integer(12) FIRST;

ALTER TABLE integerpadd_test ADD COLUMN new_col2 int(12) FIRST;

show columns in integerpadd_test;

drop table integerpadd_test;

select if (cast(2.3 as integer(5)) = 2,'ok','nok');

select if (cast(2.3 as int(5)) = 2,'ok','nok');

select cast(2.3 as int(-1));

CREATE FUNCTION "my_func"("i" INTEGER(4)) RETURN INTEGER(10) AS LANGUAGE JAVA NAME 'myClass.myFuncB(java.lang.Integer) return integer';

select return_type from db_stored_procedure where sp_name = 'my_func';

select data_type from db_stored_procedure_args where sp_name = 'my_func';

drop function my_func;
