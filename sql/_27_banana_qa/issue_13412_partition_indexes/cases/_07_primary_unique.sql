drop table if exists `products`;
drop table if exists `products_to_categories`;
CREATE TABLE `products` (
  `product_id` int  NOT NULL auto_increment,
  `url` varchar(100) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `visible` int  NOT NULL default '1',
  PRIMARY KEY  (`product_id`),
  UNIQUE KEY `url` (`url`),
  KEY `visible` (`visible`)
);

CREATE TABLE `products_to_categories` (
  `product_id` int NOT NULL,
  `category_id` int NOT NULL,
  PRIMARY KEY  (`product_id`,`category_id`)
);
SHOW INDEXES FROM products;
SHOW INDEXES FROM `products`;
alter table products partition by range(product_id)(
partition p0 values less than(50),
partition p1 values less than(100));
alter table products drop constraint url;
alter table products add constraint url_id unique(url,product_id);
alter table products partition by range(product_id)(
partition p0 values less than(50),
partition p1 values less than(100));
insert into products_to_categories select rownum-1,rownum*10 from db_root connect by level<101;
update statistics on all classes with fullscan;
show index from products__p__p0;
show index from products__p__p1;

alter table products_to_categories partition by range(product_id)(
partition p0 values less than(50),
partition p1 values less than(100));
update statistics on all classes with fullscan;
show index from products_to_categories__p__p0;
show index from products_to_categories__p__p1;
show index from products_to_categories;


alter table products_to_categories drop partition p1;
alter table products_to_categories promote partition p0;
drop table  products_to_categories__p__p0;
alter table products_to_categories partition by range(category_id)(
partition p1 values less than(50),
partition p2 values less than(100));
update statistics on all classes with fullscan;
show index from products_to_categories__p__p1;
show index from products_to_categories__p__p2;
drop table products;
drop table  products_to_categories;
