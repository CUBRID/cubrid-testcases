/*
 * This is a test case to verify the CBRD-24371 issue.
 *
 * Verify the following three operations.
 *   - When executing the ALTER SYNONYM statement, only the comment can be changed without using the for clause.
 *   - In the ALTER SYNONYM statement, if there is no for clause and no comments are changed, an error should occur.
 *   - If the comment of synonym is changed to an empty string, it becomes NULL.
 * 
 */


/*
 * When executing the ALTER SYNONYM statement, only the comment can be changed without using the for clause.
 *
 */

/* Create synonyms for testing. */
drop synonym if exists s1;
create synonym s1 for t1;

select * from db_synonym where synonym_name = 's1';
alter synonym s1 comment 'Change comment without for clause.';
select * from db_synonym where synonym_name = 's1';

alter synonym s1 for t1_new comment 'Change comment with for clause.';
select * from db_synonym where synonym_name = 's1';

--err case
alter synonym s1 comment 'Change comment with for clause.' for t1_new;


/*
 * In the ALTER SYNONYM statement, if there is no for clause and no comments are changed, an error should occur.
 *
 */
--err case
alter synonym s1;
alter synonym s1 for;


/*
 * If the comment of synonym is changed to an empty string, it becomes NULL.
 *   - CREATE SYNONYM
 *
 */

drop synonym if exists s2_1;
drop synonym if exists s2_2;
drop synonym if exists s2_3;
drop synonym if exists s2_4;
drop synonym if exists s2_5;
create synonym s2_1 for t2;
create synonym s2_2 for t2 comment '';

--err case
create synonym s2_3 for t2 comment NULL;

create synonym s2_4 for t2 comment 'Dummy comment.';
create synonym s2_5 for t2 comment 'Dummy comment.';

select * from db_synonym where synonym_name in ('s2_1', 's2_2', 's2_3', 's2_4', 's2_5');
create or replace synonym s2_4 for t2_new comment '';
select * from db_synonym where synonym_name in ('s2_4', 's2_5');
create or replace synonym s2_5 for t2_new;
select * from db_synonym where synonym_name in ('s2_4', 's2_5');


/*
 * If the comment of synonym is changed to an empty string, it becomes null.
 *   - ALTER SYNONYM
 *
 */

drop synonym if exists s3;
create synonym s3 for t3 comment 'Dummy comment.';

select * from db_synonym where synonym_name = 's3';
alter synonym s3 for t3_new;
select * from db_synonym where synonym_name = 's3';

--err case
alter synonym s3 comment NULL;

alter synonym s3 comment '';
select * from db_synonym where synonym_name = 's3';
alter synonym s3 for t4 comment 'Dummy comment.';
select * from db_synonym where synonym_name = 's3';
alter synonym s3 for t4_new comment '';
select * from db_synonym where synonym_name = 's3';


drop synonym s1;
drop synonym s2_1;
drop synonym s2_2;
drop synonym s2_4;
drop synonym s2_5;
drop synonym s3;
