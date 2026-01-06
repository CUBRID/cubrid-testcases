drop table if exists track, album;
CREATE TABLE album( id_1 char(10) , CONSTRAINT "pk_album_id" PRIMARY KEY (id_1));
CREATE TABLE track( album_1 char(10) , FOREIGN KEY (album_1) REFERENCES album(id_1));
select class_of, attr_name, attr_type, from_class_of, from_attr_name, def_order, data_type, default_value, domains, is_nullable, comment from _db_attribute where class_of.class_name = 'album' order by 1;
select attr_name, class_name,owner_name, attr_type,def_order, from_class_name, from_owner_name, from_attr_name, data_type, prec, scale, charset, collation, domain_class_name, domain_owner_name, default_value, is_nullable, comment from db_attribute where class_name = 'album' order by 1;
drop table if exists track, album;

drop table if exists foo;
create table foo( id int primary key, d double, vc varchar(128) );
alter table foo rename attribute vc as vch, rename attribute d as d2;
select attr_name, class_name,owner_name, attr_type,def_order, from_class_name, from_owner_name, from_attr_name, data_type, prec, scale, charset, collation, domain_class_name, domain_owner_name, default_value, is_nullable, comment from db_attribute where class_name = 'foo' order by attr_name;
drop table if exists foo;

drop table if exists doo;
create table doo (a int);
alter table doo add attribute b int;
select attr_name, class_name,owner_name, attr_type,def_order, from_class_name, from_owner_name, from_attr_name, data_type, prec, scale, charset, collation, domain_class_name, domain_owner_name, default_value, is_nullable, comment from db_attribute where class_name = 'doo' order by 1;
drop doo;

drop table if exists father,child;
create table father (a int);
create table child (b int) ;
alter table child add superclass father;
alter table father add attribute c int;
select attr_name, class_name,owner_name, attr_type,def_order, from_class_name, from_owner_name, from_attr_name, data_type, prec, scale, charset, collation, domain_class_name, domain_owner_name, default_value, is_nullable, comment from db_attribute where class_name = 'child' order by 1;
drop father,child;

drop table if exists father_fk,father_pk,child;
create table father_pk (a int primary key,b varchar(10));
create table father_fk (b int, c int, FOREIGN KEY (c) REFERENCES father_pk(a)) ;
create table child(d varchar(20)); 
alter table child add superclass father_fk;
alter table father_fk add attribute c int;
select attr_name, class_name,owner_name, attr_type,def_order, from_class_name, from_owner_name, from_attr_name, data_type, prec, scale, charset, collation, domain_class_name, domain_owner_name, default_value, is_nullable, comment from db_attribute where class_name = 'child' order by 1;
drop table if exists father_fk,father_pk,child;


drop table if exists father1,father2,child;
create table father1 (a1 int);
create table father2 (a2 int);
create table child (b int) ;
alter table child add superclass father1,father2;
alter table father1 add attribute c int;
select attr_name, class_name,owner_name, attr_type,def_order, from_class_name, from_owner_name, from_attr_name, data_type, prec, scale, charset, collation, domain_class_name, domain_owner_name, default_value, is_nullable, comment from db_attribute where class_name = 'child' order by 1;
drop table if exists father1,father2,child;

drop table if exists father1,father2,child;
create table father1 (a int);
create table father2 (a int);
create table child (a int) ;
alter table child add superclass father1,father2 inherit a of father1 as purpose,a of father2 as alias ;
select attr_name, class_name,owner_name, attr_type,def_order, from_class_name, from_owner_name, from_attr_name, data_type, prec, scale, charset, collation, domain_class_name, domain_owner_name, default_value, is_nullable, comment from db_attribute where class_name = 'child' order by 1;
drop table if exists father1,father2,child;


drop table if exists father,child;
create table father (a int);
create table child under father ;
select attr_name, class_name,owner_name, attr_type,def_order, from_class_name, from_owner_name, from_attr_name, data_type, prec, scale, charset, collation, domain_class_name, domain_owner_name, default_value, is_nullable, comment from db_attribute where class_name = 'child' order by 1;
drop father,child;

