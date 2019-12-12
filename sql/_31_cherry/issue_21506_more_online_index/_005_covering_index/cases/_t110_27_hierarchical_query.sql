--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
CREATE TABLE tree(ID INT, MgrID INT, Name VARCHAR(32), BirthYear INT);
 
INSERT INTO tree VALUES (1,NULL,'Kim', 1963);
INSERT INTO tree VALUES (2,NULL,'Moy', 1958);
INSERT INTO tree VALUES (3,1,'Jonas', 1976);
INSERT INTO tree VALUES (4,1,'Smith', 1974);
INSERT INTO tree VALUES (5,2,'Verma', 1973);
INSERT INTO tree VALUES (6,2,'Foster', 1972);
INSERT INTO tree VALUES (7,6,'Brown', 1981);

create index i_tree_id_mgrid on tree(id, mgrid) with online;

SELECT /*+ recompile */ id, mgrid FROM tree  where id>0 START WITH id>0 and mgrid IS NULL CONNECT BY prior id=mgrid order by id;

drop table tree;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
