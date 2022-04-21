--create table
DROP TABLE IF EXISTS ta,tb,tc,td,te;
CREATE TABLE ta AS
SELECT rownum c_a,
       rownum c_b
FROM   db_class a,
       db_class b,
       db_class c,
       db_class d,
       db_class e,
       db_class f,
       db_class g limit 30;
CREATE TABLE tb AS
SELECT rownum mod 300000 c_a,
       rownum            c_b
FROM   db_class a,
       db_class b,
       db_class c,
       db_class d,
       db_class e,
       db_class f,
       db_class g limit 600;
CREATE TABLE tc AS
SELECT rownum c_a,
       rownum c_b
FROM   db_class a,
       db_class b,
       db_class c,
       db_class d,
       db_class e,
       db_class f,
       db_class g limit 20;
CREATE TABLE td AS
SELECT rownum c_a,
       rownum c_b
FROM   db_class a,
       db_class b,
       db_class c,
       db_class d,
       db_class e,
       db_class f,
       db_class g limit 20;
CREATE TABLE te AS
SELECT rownum c_a,
       rownum c_b
FROM   db_class a,
       db_class b,
       db_class c,
       db_class d,
       db_class e,
       db_class f,
       db_class g limit 30;
CREATE INDEX idx_a
ON ta  (c_a,c_b);         
CREATE INDEX idx_b
ON tb  (c_a,c_b);
ALTER TABLE tc ADD CONSTRAINT PRIMARY KEY(c_a);
ALTER TABLE td ADD CONSTRAINT PRIMARY KEY(c_a);
ALTER TABLE te ADD CONSTRAINT PRIMARY KEY(c_a);

SELECT /*+ recompile */ count(*)
-- unnecessary select list
FROM   (SELECT a.c_a,
               b.c_b,
               (SELECT 'unnecessary'
                FROM   tc
                WHERE  c_a = a.c_a) AS unnecessary1
        FROM   ta a,
               tb b,
               tc c,
               td d,
               te e
        WHERE  a.c_a = b.c_a
-- unnecessary join table
               AND b.c_b = c.c_a(+)
               AND b.c_b = d.c_a(+) 
               AND b.c_b = e.c_a(+) 
-- unnecessary order by 
	ORDER  BY 1,
                  2,
                  3 
       );
SELECT /*+ recompile */ max(ca)
FROM   (SELECT a.c_a ca,
               b.c_b cb,
               (SELECT 'unnecessary'
                FROM   tc
                WHERE  c_a = a.c_a) AS unnecessary1
        FROM   ta a,
               tb b,
               tc c,
               td d,
               te e
        WHERE  a.c_a = b.c_a
-- unnecessary join table
               AND b.c_b = c.c_a(+)
               AND b.c_b = d.c_a(+) 
               AND b.c_b = e.c_a(+)
-- unnecessary order by
        ORDER  BY 1,
                  2,
                  3 
       ); 
SELECT /*+ recompile */ group_concat(cb)
FROM   (SELECT a.c_a ca,
               b.c_b cb,
               (SELECT 'unnecessary'
                FROM   tc
                WHERE  c_a = a.c_a) AS unnecessary1
        FROM   ta a,
               tb b,
               tc c,
               td d,
               te e
        WHERE  a.c_a = b.c_a
-- unnecessary join table
               AND b.c_b = c.c_a(+) 
               AND b.c_b = d.c_a(+)
               AND b.c_b = e.c_a(+)
-- unnecessary order by
        ORDER  BY 1,
                  2,
                  3 
       ); 
SELECT /*+ recompile */ max(ca)
FROM   (SELECT a.c_a ca ,
               b.c_b cb ,
               (SELECT 'unnecessary'
                FROM   tc
                WHERE  c_a = a.c_a) AS unnecessary1
        FROM    ta a,
                tb b,
                tc c,
                td d,
                te e
        WHERE   a.c_a = b.c_a
-- unnecessary join table
                AND b.c_b = c.c_a(+) 
                AND b.c_b = d.c_a(+) 
                AND b.c_b = e.c_a(+) 
                ORDER BY 1,
                         2,
                         3 limit 3 );
DROP TABLE ta,tb,tc,td,te;
