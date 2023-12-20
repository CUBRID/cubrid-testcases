create table t(a char(10),b varchar(10));
create index idx1 on t(b,a);
create index idx2 on t(lower(b),a);
SELECT class_of.class_name,index_name,filter_expression,have_function ,SEQUENCE(SELECT key_attr_name,key_order,func

                                     FROM _db_index_key k

                                     WHERE k in i.key_attrs)

FROM _db_index i

WHERE class_of.class_name ='t';
ALTER  INDEX idx1 on t REBUILD;
SELECT class_of.class_name,index_name,filter_expression,have_function ,SEQUENCE(SELECT key_attr_name,key_order,func

                                     FROM _db_index_key k

                                     WHERE k in i.key_attrs)

FROM _db_index i

WHERE class_of.class_name ='t';
drop table t;
