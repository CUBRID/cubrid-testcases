/**
 *  This test case verifies the definition of the db_class view.
 *
 *  It runs the query that defines db_class directly on _db_class and then
 *  selects the same columns from db_class, so that the two lists of classes can be compared.
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  the defining query of db_class run on _db_class lists the classes the user can see
 *    Case 2:  db_class lists the same classes
 */

evaluate 'Case 1: the defining query of db_class run on _db_class lists the classes the user can see';
SELECT c.class_name, 
       CAST(c.owner.name AS VARCHAR(255)), 
       CASE c.class_type 
         WHEN 0 THEN 'CLASS' 
         WHEN 1 THEN 'VCLASS' 
         WHEN 2 THEN 'PROXY' 
         ELSE 'UNKNOW' END, 
       CASE 
         WHEN c.is_system_class = 1 THEN 'YES' 
         ELSE 'NO' END, 
       CASE 
         WHEN c.sub_classes IS NULL THEN 'NO' 
         ELSE NVL((SELECT 'YES' 
                   FROM _db_partition p 
                   WHERE p.class_of = c and p.pname IS NULL), 'NO') 
                   END 
FROM _db_class c  
WHERE CURRENT_USER = 'DBA' 
      OR {c.owner.name} 
      SUBSETEQ (  SELECT SET{CURRENT_USER} + COALESCE(SUM(SET{t.g.name}), SET{})  
                  FROM _db_user u, TABLE(groups) AS t(g)  
                  WHERE u.name = CURRENT_USER) 
                        OR {c} SUBSETEQ (  SELECT SUM(SET{au.object_of})  
                                           FROM _db_auth au  
                                           WHERE {au.grantee.name} 
                                           SUBSETEQ (  SELECT SET{CURRENT_USER} + COALESCE(SUM(SET{t.g.name}), SET{})  
                                                       FROM _db_user u, TABLE(groups) AS t(g)  
                                                       WHERE u.name = CURRENT_USER) 
                                                       AND  au.auth_type = 'SELECT')
                                                       order by 1;
                                                       
evaluate 'Case 2: db_class lists the same classes';
select class_name, owner_name, class_type, is_system_class, tde_algorithm, partitioned, is_reuse_oid_class, collation, comment from db_class order by 1;
