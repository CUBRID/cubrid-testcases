--+ holdcas on;
drop table if exists jobs;
CREATE TABLE jobs(id INT, start_at timestamp DEFAULT timestamp'2011-2-3 18:49:32'); 
INSERT INTO jobs VALUES(1,default); 

--good
SELECT COUNT(j.id), DATE(j.start_at) AS `date`
FROM jobs j group by id
ORDER BY `date`;

--error
SELECT COUNT(j.id), DATE(j.start_at) AS `date`
FROM jobs j
GROUP BY `date`;

--error
SELECT COUNT(j.id), DATE(j.start_at) AS `date`
FROM jobs j
GROUP BY `date` HAVING `date` IS NULL;

drop table if exists jobs;
--+ holdcas off;
commit;
