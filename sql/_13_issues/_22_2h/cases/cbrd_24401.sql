SELECT *
FROM   (SELECT  1
        FROM   db_class
        WHERE  class_name IN (SELECT 1
                              FROM   db_root
                              UNION
                              SELECT 1,
                                     2
                              FROM   db_root)); 
