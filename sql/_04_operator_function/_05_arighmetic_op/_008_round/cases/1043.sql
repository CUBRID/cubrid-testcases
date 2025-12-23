--create table,insert data to the table,crerate views based on created table,select data from db_attribute with order by keyword,drop views and table

create table a_tbl (
a int ,
b int 
) ;

insert into a_tbl values ( 1, 2 ) ;
insert into a_tbl values ( 2, 3 ) ;

create view a_view as select a av1  , a av2 , a av3   from a_tbl ;
create view b_view as select a av1  , a av2 , b av3   from a_tbl ;
create view c_view as select a av1  , a av2 , b from a_tbl;
create view d_view as select a , a av2 , a av3   , b av4, b from a_tbl ;

select attr_name, class_name,owner_name, attr_type,def_order, from_class_name, from_owner_name, from_attr_name, data_type, prec, scale, charset, collation, domain_class_name, domain_owner_name, default_value, is_nullable, comment from db_attribute where class_name = 'a_view' order by 1,2,3;
select attr_name, class_name,owner_name, attr_type,def_order, from_class_name, from_owner_name, from_attr_name, data_type, prec, scale, charset, collation, domain_class_name, domain_owner_name, default_value, is_nullable, comment from db_attribute where class_name = 'b_view' order by 1,2,3;
select attr_name, class_name,owner_name, attr_type,def_order, from_class_name, from_owner_name, from_attr_name, data_type, prec, scale, charset, collation, domain_class_name, domain_owner_name, default_value, is_nullable, comment from db_attribute where class_name = 'c_view' order by 1,2,3;
select attr_name, class_name,owner_name, attr_type,def_order, from_class_name, from_owner_name, from_attr_name, data_type, prec, scale, charset, collation, domain_class_name, domain_owner_name, default_value, is_nullable, comment from db_attribute where class_name = 'd_view' order by 1,2,3;


drop view a_view, b_view, c_view, d_view;
drop a_tbl;