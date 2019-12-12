--+ holdcas on;

drop table if exists aa;


CREATE TABLE [aa] ([promote] CHARACTER(10)) COLLATE utf8_bin;

select * from db_attribute where class_name='aa';

alter table aa collate iso88591_bin;

show create table aa;

drop table if exists aa;

drop table if exists aa1;

CREATE TABLE aa1( a char COLLATE iso88591_bin ) COLLATE iso88591_bin ;

show create table aa1;

alter table aa1 collate utf8_bin;

show create table aa1;

SELECT  a.attr_name,    a.attr_type,    a.from_class_name,    a.[data_type],    a.prec,    a.scale,    a.is_nullable,    a.code_set,    a.domain_class_name,    a.default_value,    a.def_order,   x.coll_name  FROM    db_attribute a,   (    SELECT cls.class_name, attr.attr_name, d.code_set, d.collation_id    FROM _db_attribute attr, _db_domain d, _db_class cls    WHERE attr = d.object_of AND attr.class_of = cls   ) coll LEFT OUTER JOIN _db_collation x ON coll.collation_id = x.coll_id  WHERE    coll.attr_name = a.attr_name   AND   coll.class_name = a.class_name   AND    a.class_name ='aa1'  ORDER BY a.def_order;

drop table if exists aa1;

--+ holdcas off;
commit;
