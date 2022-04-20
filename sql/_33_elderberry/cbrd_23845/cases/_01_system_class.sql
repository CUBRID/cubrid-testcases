/*
 * test group #1: _db_synonym, db_synonym.
 *   - check system class
 *
 */


/*
 * check system class
 *   - SELECT * FROM _db_class
 *   - SELECT * FROM db_class
 *   - ;SChema
 *   - show create table
 *   - show create view
 *   - show columns
 *   - show index
 *   - SELECT
 *
 */

SELECT class_of, unique_name, class_name, owner.name FROM _db_class WHERE class_name LIKE '%db_synonym%';
SELECT * FROM db_class WHERE class_name LIKE '%db_synonym%';
DESCRIBE _db_synonym;
DESCRIBE db_synonym;
show create table _db_synonym;
show create view db_synonym;
show columns from _db_synonym;
show columns from db_synonym;
show index in _db_synonym;
select * from _db_synonym;
select * from db_synonym;
