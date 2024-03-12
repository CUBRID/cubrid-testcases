-- This test case verifies the following issue: CBRD-25216.
-- A core dump occurs in queries with long select-list title without alias 
-- Ensure the core is no longer dumped and the expected query result is returned

/* ----------------------------------------
 *
 * Test case 1 - Test that the buffer is sufficient to copy the user-specified name in the pt_get_name_without_current_user_name function.
 *   => No core dump should occur.
 *
 * ---------------------------------------- */

select *
from (
       select dummy || 'c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c__4'
       from dual
);


/* ----------------------------------------
 *
 * test case 2,3 - Test that even if the name of the auto-increment serial exceeds 254 bytes, it is not truncated to 254 bytes when changing the owner of the table.
 *   => No error should occur in the last query.
 *   Note: the unique name column of db_serial adds 5 extra characters to divide users, tables and columns. 
 * ---------------------------------------- */

/* Test case 2 - Truncation Check test
 * length of the table name: 200c
 * length of the column name: 46c
 */
create table t_______10t_______20t_______30t_______40t_______50t_______60t_______70t_______80t_______90t______100t______110t______120t______130t______140t______150t______160t______170t______180t______190t______200 (
    c_______10c_______20c_______30c_______40c____6 int auto_increment
);

/* length = 200c(table) + 46c(column) + 3(user:dba) + 5(extras) = 254c */
select length (unique_name), unique_name from db_serial;

/* length of the user name: 4 */
create user u__4;

alter table t_______10t_______20t_______30t_______40t_______50t_______60t_______70t_______80t_______90t______100t______110t______120t______130t______140t______150t______160t______170t______180t______190t______200 owner to u__4;

/* length = 100c(table) + 46c(column) + 3c(user: u__4) + 5c(extras) = 255c */
select length (unique_name), unique_name from db_serial;

alter table u__4.t_______10t_______20t_______30t_______40t_______50t_______60t_______70t_______80t_______90t______100t______110t______120t______130t______140t______150t______160t______170t______180t______190t______200 modify column c_______10c_______20c_______30c_______40c____6 bigint auto_increment;

drop table if exists t_______10t_______20t_______30t_______40t_______50t_______60t_______70t_______80t_______90t______100t______110t______120t______130t______140t______150t______160t______170t______180t______190t______200;
drop table u__4.t_______10t_______20t_______30t_______40t_______50t_______60t_______70t_______80t_______90t______100t______110t______120t______130t______140t______150t______160t______170t______180t______190t______200;


/* Test case 3 - Maximum length test
 * length of the table name: 222c
 * length of the column name: 254c
 */
create table t_______10t_______20t_______30t_______40t_______50t_______60t_______70t_______80t_______90t______100t______110t______120t______130t______140t______150t______160t______170t______180t______190t______200t______210t______220t2 (
    c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c__4 int auto_increment
);

/* length = 222c(table) + 254c(column) + 3(user:dba) + 5(extras) = 484c */
select length (unique_name), unique_name from db_serial;

/* length of the user name: 31 */
create user u_______10u_______20u_______30u;

alter table t_______10t_______20t_______30t_______40t_______50t_______60t_______70t_______80t_______90t______100t______110t______120t______130t______140t______150t______160t______170t______180t______190t______200t______210t______220t2 owner to u_______10u_______20u_______30u;

/* length = 222c(table) + 254c(column) + 31c(user) + 5c(extras) = 512c */
select length (unique_name), unique_name from db_serial;

alter table u_______10u_______20u_______30u.t_______10t_______20t_______30t_______40t_______50t_______60t_______70t_______80t_______90t______100t______110t______120t______130t______140t______150t______160t______170t______180t______190t______200t______210t______220t2 modify column c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c__4 bigint auto_increment;

drop table if exists t_______10t_______20t_______30t_______40t_______50t_______60t_______70t_______80t_______90t______100t______110t______120t______130t______140t______150t______160t______170t______180t______190t______200t______210t______220t2;
drop table u_______10u_______20u_______30u.t_______10t_______20t_______30t_______40t_______50t_______60t_______70t_______80t_______90t______100t______110t______120t______130t______140t______150t______160t______170t______180t______190t______200t______210t______220t2;


-- Drop users
drop user u__4;
drop user u_______10u_______20u_______30u;