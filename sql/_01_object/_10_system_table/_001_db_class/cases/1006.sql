--Check definition of the virtual db_class


SELECT c.class_name, 
       CAST(c.owner.name AS VARCHAR(255)), 
       CASE c.class_type 
         WHEN 0 THEN 'CLASS' 
         WHEN 1 THEN 'VCLASS' 
         WHEN 2 THEN 'PROXY' 
         ELSE 'UNKNOW' END, 
       CASE 
         WHEN MOD(c.is_system_class, 2) = 1 THEN 'YES' 
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
                  FROM db_user u, TABLE(groups) AS t(g)  
                  WHERE u.name = CURRENT_USER) 
                        OR {c} SUBSETEQ (  SELECT SUM(SET{au.class_of})  
                                           FROM _db_auth au  
                                           WHERE {au.grantee.name} 
                                           SUBSETEQ (  SELECT SET{CURRENT_USER} + COALESCE(SUM(SET{t.g.name}), SET{})  
                                                       FROM db_user u, TABLE(groups) AS t(g)  
                                                       WHERE u.name = CURRENT_USER) 
                                                       AND  au.auth_type = 'SELECT')
                                                       order by 1;
                                                       
select * from db_class order by 1;
