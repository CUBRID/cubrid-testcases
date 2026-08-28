/*
 * test group #1: _db_synonym, db_synonym.
 *   - check system class
 *
 */

SELECT class_of, IF (is_system_class = 0, CONCAT (LOWER (owner.name), '.', class_name), class_name) as unique_name, class_name, owner.name FROM _db_class WHERE class_name LIKE '%db_synonym%';
select class_name, owner_name, class_type, is_system_class, tde_algorithm, partitioned, is_reuse_oid_class, collation, comment from db_class WHERE class_name LIKE '%db_synonym%';
DESCRIBE _db_synonym;
DESCRIBE db_synonym;
show create table _db_synonym;
show create view db_synonym;
show columns from _db_synonym;
show columns from db_synonym;
show index in _db_synonym;
select CONCAT (LOWER (owner.name), '.', name) as unique_name, name, owner, is_public, (select IF (c.is_system_class = 0, CONCAT (LOWER (c.owner.name), '.', c.class_name), c.class_name) from _db_class c where c.class_name = target_name and c.owner = target_owner) as target_unique_name, target_name, target_owner, comment from _db_synonym;
select synonym_name, synonym_owner_name, is_public_synonym, target_name, target_owner_name, comment from db_synonym;
