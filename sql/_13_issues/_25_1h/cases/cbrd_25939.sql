-- Verified for CBRD-25939  
-- Issue: Fixed an issue where an existing synonym could be duplicated when changing the owner of the target class or vclass.  
-- Synonyms must be created using the unique_name of the target class or vclass. However, when the owner was changed using 'OWNER TO',   
-- a duplicate synonym with the same unique_name could be created. This fix applies to the ALTER statement for Class and Vclass, as well as the 'change_owner_method'. 

--Test for Changing the Owner of a Class/Vclass to the Same as Its SYNONYM.

CREATE USER u1;
CREATE USER u2;
CREATE USER u3;

CREATE TABLE u1.tbl (col1 int);
CREATE TABLE u2.tbl (col1 int);
CREATE VIEW u1.tbl_v as select * from u1.tbl;
CREATE VIEW u2.tbl_v as select * from u2.tbl;
CREATE SYNONYM dba.tbl for u1.tbl;
CREATE SYNONYM dba.tbl_v for u2.tbl_v;

evaluate '1. Error when creating a synonym with the same name as an existing Class/Vclass';
CREATE SYNONYM u1.tbl for u1.tbl;
CREATE SYNONYM u1.tbl_v for u1.tbl_v;

evaluate '2. Error when changing the owner to a non-existent user';
ALTER TABLE u1.tbl OWNER TO err_user;
ALTER VIEW u1.tbl_v OWNER TO err_user;
CALL change_owner ('u1.tbl', 'err_user') ON CLASS db_authorizations;
CALL change_owner ('u1.tbl_v', 'err_user') ON CLASS db_authorizations;

evaluate '3. Error when changing the owner using a synonym name';
ALTER TABLE dba.tbl OWNER TO u2;
ALTER VIEW dba.tbl_v OWNER TO u2;
CALL change_owner ('dba.tbl', 'u2') ON CLASS db_authorizations;
CALL change_owner ('dba.tbl_v', 'u2') ON CLASS db_authorizations;

evaluate '4. No-Op when changing the owner to the same owner (self-change)';
ALTER TABLE u1.tbl OWNER TO u1;
ALTER VIEW u1.tbl_v OWNER TO u1;
CALL change_owner ('u1.tbl', 'u1') ON CLASS db_authorizations;
CALL change_owner ('u1.tbl_v', 'u1') ON CLASS db_authorizations;

evaluate '5. Error when changing the owner of a Class/Vclass if a synonym with the same name exists';
ALTER TABLE u1.tbl OWNER TO dba;
ALTER VIEW u1.tbl_v OWNER TO dba;
CALL change_owner ('u1.tbl', 'dba') ON CLASS db_authorizations;
CALL change_owner ('u1.tbl_v', 'dba') ON CLASS db_authorizations;

evaluate '6. Error when changing the owner of a Class/Vclass if a Class/Vclass with the same name already exists';
ALTER TABLE u1.tbl OWNER TO u2;
ALTER VIEW u1.tbl_v OWNER TO u2;
CALL change_owner ('u1.tbl', 'u2') ON CLASS db_authorizations;
CALL change_owner ('u1.tbl_v', 'u2') ON CLASS db_authorizations;

evaluate '7. Error when changing the owner of a non-existent Class/Vclass';
ALTER TABLE u3.tbl OWNER TO u2;
ALTER VIEW u3.tbl_v OWNER TO u2;
CALL change_owner ('u3.tbl', 'u2') ON CLASS db_authorizations;
CALL change_owner ('u3.tbl_v', 'u2') ON CLASS db_authorizations;

evaluate '8. Success case';
ALTER TABLE u1.tbl OWNER TO u3;
ALTER VIEW u1.tbl_v OWNER TO u3;
--Even if the owner is changed, the target_owner_name in the synonym remains invalid, so the following case is not an issue
SELECT * FROM db_synonym WHERE synonym_name LIKE 'tbl%';
SELECT owner_name, class_name FROM db_class WHERE class_name LIKE 'tbl%';

CALL change_owner ('u3.tbl', 'u1') ON CLASS db_authorizations;
CALL change_owner ('u3.tbl_v', 'u1') ON CLASS db_authorizations;
--Even if the owner is changed, the target_owner_name in the synonym remains invalid, so the following case is not an issue
SELECT * FROM db_synonym WHERE synonym_name LIKE 'tbl%';
SELECT owner_name, class_name FROM db_class WHERE class_name LIKE 'tbl%';

DROP TABLE if exists u1.tbl;
DROP TABLE if exists u2.tbl;
DROP TABLE if exists u3.tbl;
DROP VIEW u1.tbl_v;
DROP VIEW u2.tbl_v;
DROP SYNONYM dba.tbl;
DROP SYNONYM dba.tbl_v;
DROP USER u1;
DROP USER u2;
DROP USER u3;
