--+ holdcas on;
set names binary;
create table 테이블(칼럼1 int, index 색인(칼럼1) );
select class_of, unique_name, class_name, class_type, flags, owner, inst_attr_count, class_attr_count, shared_attr_count, inst_meth_count, class_meth_count, collation_id, tde_algorithm, sub_classes, super_classes, inst_attrs, class_attrs, shared_attrs, inst_meths, class_meths, meth_files, query_specs, indexes, comment, partition from _db_class where class_name like'테%';

drop table 테이블;
set names utf8;
commit;
--+ holdcas off;
