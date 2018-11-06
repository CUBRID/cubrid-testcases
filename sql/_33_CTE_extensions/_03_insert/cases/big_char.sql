drop table if exists `container`;
CREATE TABLE `container` (
  `container_id` decimal(38,0)  NOT NULL,
  `container_name` varchar(80) NOT NULL,
  `container_id_snr` decimal(38,0)  DEFAULT NULL,
  PRIMARY KEY (`container_id`),
  KEY `container_id_snr` (`container_id_snr`)
);

INSERT INTO `container` values
(10101000000000000000000000000001,'Cabinet #1',null),
(10101000000000000000000000000002,'Cabinet #2',null),
(10101000000000000000000000000003,'Shelf #1',10101000000000000000000000000001),
(10101000000000000000000000000004,'Shelf #2',10101000000000000000000000000002),
(10101000000000000000000000000005,'Box #1',10101000000000000000000000000003),
(10101000000000000000000000000006,'Box #2',10101000000000000000000000000004);

drop table if exists foo;
create table foo as
WITH RECURSIVE cte (l, container_id, container_name, container_id_snr, path)
AS (
  SELECT 1 AS l, container_id, container_name, container_id_snr, CAST(container.container_name AS CHAR(4000)) AS path
   FROM container
  WHERE container_id_snr IS NULL
UNION ALL
  SELECT l+1, container.container_id, container.container_name, container.container_id_snr, CONCAT(cte.path, '/', container.container_name) AS path
   FROM cte
  LEFT JOIN container ON (cte.container_id = container.container_id_snr)
WHERE container.container_id_snr IN ('10101000000000000000000000000001','10101000000000000000000000000003')
) SELECT  *
FROM cte
ORDER BY path;

select count(*) from foo;

insert into foo
WITH RECURSIVE cte (l, container_id, container_name, container_id_snr, path)
AS (
  SELECT 1 AS l, container_id, container_name, container_id_snr, CAST(container.container_name AS CHAR(4000)) AS path
   FROM container
  WHERE container_id_snr IS NULL
UNION ALL
  SELECT l+1, container.container_id, container.container_name, container.container_id_snr, CONCAT(cte.path, '/', container.container_name) A
   FROM cte
  LEFT JOIN container ON (cte.container_id = container.container_id_snr)
WHERE container.container_id_snr IN ('10101000000000000000000000000001','10101000000000000000000000000003')
) SELECT  *
FROM cte
ORDER BY path;
select count(*) from foo;

replace into foo
WITH RECURSIVE cte (l, container_id, container_name, container_id_snr, path)
AS (
  SELECT 1 AS l, container_id, container_name, container_id_snr, CAST(container.container_name AS CHAR(4000)) AS path
   FROM container
  WHERE container_id_snr IS NULL
UNION ALL
  SELECT l+1, container.container_id, container.container_name, container.container_id_snr, CONCAT(cte.path, '/', container.container_name) A
   FROM cte
  LEFT JOIN container ON (cte.container_id = container.container_id_snr)
WHERE container.container_id_snr IN ('10101000000000000000000000000001','10101000000000000000000000000003')
) SELECT  *
FROM cte
ORDER BY path;
select count(*) from foo;




WITH RECURSIVE cte (l, container_id, container_name, container_id_snr, path)
AS (
  SELECT 1 AS l, container_id, container_name, container_id_snr, CAST(container.container_name AS CHAR(4000)) AS path
   FROM container
  WHERE container_id_snr IS NULL
UNION ALL
  SELECT l+1, container.container_id, container.container_name, container.container_id_snr, CONCAT(cte.path, '/', container.container_name) A
   FROM cte
  LEFT JOIN container ON (cte.container_id = container.container_id_snr)
WHERE container.container_id_snr IN ('10101000000000000000000000000001','10101000000000000000000000000003')
) delete from foo where container_id in (
select  container_id from cte
);

select count(*) from foo;


replace into foo
WITH RECURSIVE cte (l, container_id, container_name, container_id_snr, path)
AS (
  SELECT 1 AS l, container_id, container_name, container_id_snr, CAST(container.container_name AS CHAR(4000)) AS path
   FROM container
  WHERE container_id_snr IS NULL
UNION ALL
  SELECT l+1, container.container_id, container.container_name, container.container_id_snr, CONCAT(cte.path, '/', container.container_name) A
   FROM cte
  LEFT JOIN container ON (cte.container_id = container.container_id_snr)
WHERE container.container_id_snr IN ('10101000000000000000000000000001','10101000000000000000000000000003')
) SELECT  *
FROM cte
ORDER BY path;
select count(*) from foo;



WITH RECURSIVE cte (l, container_id, container_name, container_id_snr, path)
AS (
  SELECT 1 AS l, container_id, container_name, container_id_snr, CAST(container.container_name AS CHAR(4000)) AS path
   FROM container
  WHERE container_id_snr IS NULL
UNION ALL
  SELECT l+1, container.container_id, container.container_name, container.container_id_snr, CONCAT(cte.path, '/', container.container_name) A
   FROM cte
  LEFT JOIN container ON (cte.container_id = container.container_id_snr)
WHERE container.container_id_snr IN ('10101000000000000000000000000001','10101000000000000000000000000003')
) update foo set l=l+10 where container_name in (
with cte2 as
(
SELECT 1 AS l, container_id, container_name, container_id_snr, CAST(container.container_name AS CHAR(4000)) AS path
   FROM container
  WHERE container_id_snr IS NULL
) select container_name from cte2

);
select l from foo;
