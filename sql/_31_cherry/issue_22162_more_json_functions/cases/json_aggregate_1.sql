
DROP TABLE IF EXISTS product;
CREATE TABLE product (
  id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(120) DEFAULT NULL,
  manufacturer varchar(120) DEFAULT NULL,
  price int(11) DEFAULT NULL,
  PRIMARY KEY (id)
);
INSERT INTO product VALUES (1, 'LED Desk Lamp', 'X', 26),
(2, 'Laptop', 'Y', 800),(3, 'Grill', 'Z', 300);

DROP TABLE IF EXISTS t_attribute;
CREATE TABLE t_attribute (
  id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(120) DEFAULT NULL,
  description varchar(256) DEFAULT NULL,
  PRIMARY KEY (id)
);
INSERT INTO t_attribute(id, name) VALUES(1, 'color'),
(2, 'material'),(3, 'style'),(4, 'bulb_type'),
(5, 'usage'),(6, 'cpu_type'),(7, 'cpu_speed'),
(8, 'weight'),(9, 'battery_life'),(10, 'fuel_type');

DROP TABLE IF EXISTS t_value;
CREATE TABLE t_value (
  prod_id int(11) NOT NULL,
  attribute_id int(11) NOT NULL,
  val varchar(200),
  PRIMARY KEY (prod_id,attribute_id)
);
INSERT INTO t_value VALUES 
(1, 1, 'black'),(1, 2, 'plastic'),(1, 3, 'classic'),(1, 4, 'LED'),(1, 5, 'Indoor use only'),
(2, 1, 'blue'),(2, 6, 'quad core'),(2, 7, '3400 mhz'),(2, 8, '2,1 kg'),(2, 9, '9h'),
(3, 1, 'black'),(3, 8, '5 kg'),(3, 10, 'gas');

SELECT json_pretty(
    JSON_OBJECT('key', p.id,
            'title', p.name,
            'manufacturer', p.manufacturer,
            'price', p.price,
            'specifications', JSON_OBJECTAGG(a.name, v.val)
    )) as product
FROM product as p JOIN t_value as v ON p.id=v.prod_id
     JOIN t_attribute as a ON a.id=v.attribute_id
GROUP BY v.prod_id 
order by product;

SELECT p.id, JSON_ARRAYAGG(a.name) as product_attributes
FROM product as p JOIN t_value as v ON p.id=v.prod_id
     JOIN t_attribute as a ON a.id=v.attribute_id
GROUP BY v.prod_id 
order by product_attributes;

DROP TABLE IF EXISTS complete_product;
CREATE TABLE complete_product AS
(SELECT p.id, p.name, p.manufacturer, p.price,
        JSON_OBJECTAGG(a.name, v.val) as semi_structured_data
 FROM product as p JOIN t_value as v ON p.id=v.prod_id
      JOIN t_attribute as a ON a.id=v.attribute_id
 GROUP BY v.prod_id) 
SELECT * FROM complete_product order by 1;

SELECT p.id,
       CAST(CONCAT('[',
              GROUP_CONCAT(JSON_QUOTE(a.name))
              , ']')
            AS JSON) AS product_attributes
FROM product as p JOIN t_value AS v ON p.id=v.prod_id
JOIN t_attribute as a ON a.id=v.attribute_id GROUP BY v.prod_id;
 
SELECT json_pretty(
    JSON_OBJECT('key', p.id,
               'title', p.name,
               'manufacturer', p.manufacturer,
               'price', p.price,
               'specifications',
               CAST(CONCAT('{',
                           GROUP_CONCAT(CONCAT(JSON_QUOTE(a.name),
                                               ':',
                                               JSON_QUOTE(v.val))),
                           '}')
                    AS JSON)
        )) AS product
FROM product AS p JOIN t_value AS v ON p.id=v.prod_id
  JOIN t_attribute AS a ON a.id=v.attribute_id
GROUP BY v.prod_id;

-- http://jira.cubrid.org/browse/CBRD-22599
select t.product->'$.price' from (
SELECT json_pretty(
    JSON_OBJECT('key', p.id,
               'title', p.name,
               'manufacturer', p.manufacturer,
               'price', p.price,
               'specifications',
               CAST(CONCAT('{',
                           GROUP_CONCAT(CONCAT(JSON_QUOTE(a.name),
                                               ':',
                                               JSON_QUOTE(v.val))),
                           '}')
                    AS JSON)
        )) AS product
FROM product AS p JOIN t_value AS v ON p.id=v.prod_id
  JOIN t_attribute AS a ON a.id=v.attribute_id
GROUP BY v.prod_id) as t
where t.product->'$.price' > 300;

DROP TABLE IF EXISTS product,t_attribute,t_value,complete_product;



