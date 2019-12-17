--+ holdcas on;
autocommit off;
select *
  from shipment_c s
 where product.product_code = 3;
   
insert into shipment_c(shipment_id, product,quantity, to_location)
values( 4, (select product_c from product_c where product_code = 3),
        25, 'milan');
        
select *
  from shipment_c s
 where product.product_code = 3;
           
rollback work;
select * from employees_v
insert into employees_v(ssn, name, dept_no, salary)
select ssn, name, dept_no, 1000
  from employee_c;
select * from employees_v
insert into employees_v (ssn, name, dept_no, salary, location)
values (555555555, 'douglas adams', 5, $50000, 'birmingham');
select * from employees_v
rollback work;
/**********************************************************************/
/*                                                                    */
/*              Schema of Test Database                               */
/*                                                                    */
/*                                                                    */
/*   1.Description                                                    */
/*                                                                    */
/* The design of the schema for the test database is driven to        */
/* provide "rich" schema of sufficient size and complexity to allow   */
/* complete testing.  The  design allow easy extension to test new    */
/* and modified functionality and easily understood by programmer     */
/* writing code to perform testing.  The design also satisfy          */
/* a modularized schema and a standardized naming convention.         */
/*                                                                    */
/*   2.Strategy                                                       */
/*                                                                    */
/* 1) sub_schema tests inheritance over many levels of subclasses     */
/*    and reslution                                                   */
/* 2) sub_schema tests composition depth                              */
/* 3) sub_schema tests multiple inheritance                           */
/*                                                                    */
/*   3.Scope                                                          */
/*                                                                    */
/* 1) class : 88                                                      */
/* 2) attribute : integer, float, double, string, set, monetary,      */
/*                time, date, sets, fbo                               */
/*                                                                    */
/**********************************************************************/
/**********************************************************************/
/*              Create class , attribute, method                      */
/**********************************************************************/
/**********************************************************************/
/*                   ****  SUBSCHEMA 1  ****                          */
/*   Subschema to test inheritance over many levels of subclasses     */
/*   and  resolution                                                  */
/**********************************************************************/ 
create class iv_0_c
(iv_0_str  string default 'Its',
 iv_0_shared_flt float shared 100.0,
 class iv_0_class_int integer default 0)
method iv_0_met(string) string 
function impl_iv_0_met                   
file 'impl_test_methods.o'; 
create class iv_1_1_c as subclass of iv_0_c
  (iv_1_1_int  integer default 1000);
create class iv_1_2_c as subclass of iv_0_c
  (iv_1_2_int  integer default 2000);
create class iv_1_3_c as subclass of iv_0_c
  (iv_1_3_int   integer default 2147483647)
method class iv_1_3_met
function impl_iv_1_3_cls_met
file 'impl_test_methods.o';
create class iv_1_4_c as subclass of iv_0_c
  (iv_1_4_int   integer default 2147483647,
   iv_1_4_utm  timestamp);
create class iv_1_5_c as subclass of iv_0_c
  (iv_1_5_int   integer default 2147483647); 
create class iv_2_1_c as subclass of iv_1_2_c
  (iv_2_1_fbo   glo,
   iv_2_1_int   integer default -2147483647,
   iv_2_1_dub   double default 1.79e+308, 
   res_test     float /* default 34028.0*/);
create class iv_2_2_c  as subclass of iv_1_3_c 
  (/* iv_2_2_fbo   elo, */
   iv_2_2_int   integer default -2147483647,
   iv_2_2_dub   double default 1.79e+308,
   res_test     float default 34028.0);
create class iv_2_3_c as subclass of iv_1_4_c
  (/* iv_2_3_fbo   elo, */
   iv_2_3_int  integer default -2147483647,
   iv_2_3_dub   double default 1.79e+308);
create class iv_3_1_c as subclass of iv_2_1_c, iv_1_1_c
  (iv_3_1_set   set_of integer);
create class iv_3_2_c as subclass of iv_2_2_c
  (iv_3_2_set   set_of integer);
create class iv_3_3_c as subclass of iv_2_3_c
  (iv_3_3_set   set_of integer);
create class iv_4_2_c as subclass of iv_3_3_c
  (iv_4_2_str   string);
create class iv_4_1_c as subclass of iv_2_1_c, iv_3_2_c, iv_4_2_c
  (iv_4_1_str   string)
inherit res_test of iv_2_1_c;
create class iv_5_1_c as subclass of iv_4_1_c
  (iv_5_1_flt   float default 34028.0,
   iv_5_1_tme   time default TIME '12:00:00',
   iv_5_1_chr   char(128));
create class iv_5_2_c as subclass of iv_4_2_c
  (iv_5_2_flt   float default 34028.0,
   iv_5_2_tme   time,
   iv_5_2_chr   char(32));
create class iv_6_1_c as subclass of iv_5_2_c
  (iv_6_1_dte   date default '10/22/57' )
method iv_6_1_met(timestamp,date)timestamp
function impl_iv_6_1_met
file 'impl_test_methods.o';
create class iv_7_1_c as subclass of iv_6_1_c
  (iv_7_1_mon monetary default $34028.0,
   iv_7_1_mlt multiset_of (integer,string));
create class iv_8_1_c as subclass of iv_7_1_c
  (iv_8_1_ref1   object); 
/**********************************************************************
 *                                                                    *
 *  The following schema contains the vclass definitions for all      *
 *  the above classes.                                                *
 *                                                                    *
 **********************************************************************/
/**********************************************************************
 *              Create vclass, attribute, method                      *
 **********************************************************************/
/**********************************************************************
 *                   ****  SUBSCHEMA 1  ****                          *
 *   Subschema to test inheritance over many levels of subclasses     *
 *   and  resolution                                                  *
 **********************************************************************/
create vclass iv_0
class attribute (iv_0_class_int integer default 0)
(iv_0_str  string default 'Its',
 iv_0_shared_flt float shared 100.0)
method iv_0_met(string) string 
function impl_iv_0_met                   
file 'impl_test_methods.o'
as
  select iv_0_str, NA
    from iv_0_c; 
create vclass iv_1_1 as subclass of iv_0
  (iv_1_1_int  integer default 1000)
as
  select iv_0_str, NA,
         iv_1_1_int
    from iv_1_1_c; 
create vclass iv_1_2 as subclass of iv_0
  (iv_1_2_int  integer default 2000)
as
  select iv_0_str, NA,
         iv_1_2_int
    from iv_1_2_c;
create vclass iv_1_3 as subclass of iv_0
  (iv_1_3_int   integer default 2147483647)
method class iv_1_3_met
function impl_iv_1_3_cls_met
file 'impl_test_methods.o'
as
  select iv_0_str, NA,
         iv_1_3_int
    from iv_1_3_c;
create vclass iv_1_4 as subclass of iv_0
  (iv_1_4_int   integer default 2147483647,
   iv_1_4_utm  timestamp)
as
  select iv_0_str, NA,
         iv_1_4_int, iv_1_4_utm
    from iv_1_4_c;
create vclass iv_1_5 as subclass of iv_0
  (iv_1_5_int   integer default 2147483647)
as
  select iv_0_str, NA,
         iv_1_5_int
    from iv_1_5_c;
create vclass iv_2_1 as subclass of iv_1_2
  (iv_2_1_fbo   glo,
   iv_2_1_int   integer default -2147483647,
   iv_2_1_dub   double default 1.79e+308, 
   res_test     float /* default 34028.0*/)
as
  select iv_0_str, NA,
         iv_1_2_int,
         iv_2_1_fbo, iv_2_1_int, iv_2_1_dub, res_test
    from iv_2_1_c;
create vclass iv_2_2  as subclass of iv_1_3
  (/* iv_2_2_fbo   elo, */
   iv_2_2_int   integer default -2147483647,
   iv_2_2_dub   double default 1.79e+308,
   res_test     float default 34028.0)
method class    find_glo(string) object
function impl_find_glo
file 'test_methods.o'
as
  select iv_0_str, NA,
         iv_1_3_int,
         iv_2_2_int, iv_2_2_dub, res_test
    from iv_2_2_c;
create vclass iv_2_3 as subclass of iv_1_4
  (/* iv_2_3_fbo   elo, */
   iv_2_3_int  integer default -2147483647,
   iv_2_3_dub   double default 1.79e+308)
as
  select iv_0_str, NA,
         iv_1_4_int, iv_1_4_utm,
         iv_2_3_int, iv_2_3_dub
    from iv_2_3_c;
create vclass iv_3_1 as subclass of iv_2_1, iv_1_1
  (iv_3_1_set   set_of integer) 
as
  select iv_0_str, NA,
         iv_1_2_int,
         iv_2_1_fbo, iv_2_1_int, iv_2_1_dub, res_test,
         iv_1_1_int,
         iv_3_1_set
    from iv_3_1_c;
create vclass iv_3_2 as subclass of iv_2_2
  (iv_3_2_set   set_of integer) 
as
  select iv_0_str, NA,
         iv_1_3_int,
         iv_2_2_int, iv_2_2_dub, res_test,
         iv_3_2_set
    from iv_3_2_c;
create vclass iv_3_3 as subclass of iv_2_3
  (iv_3_3_set   set_of integer)
as
  select iv_0_str, NA,
         iv_1_4_int, iv_1_4_utm,
         iv_2_3_int, iv_2_3_dub,
         iv_3_3_set
    from iv_3_3_c;
create vclass iv_4_2 as subclass of iv_3_3
  (iv_4_2_str   string)
as
  select iv_0_str, NA,
         iv_1_4_int, iv_1_4_utm,
         iv_2_3_int, iv_2_3_dub,
         iv_3_3_set,
         iv_4_2_str
    from iv_4_2_c;
create vclass iv_4_1 as subclass of iv_2_1, iv_3_2, iv_4_2
  (iv_4_1_str   string)
inherit res_test of iv_2_1
as
  select iv_0_str, NA,
         iv_1_2_int,
         iv_2_1_fbo, iv_2_1_int, iv_2_1_dub, res_test,
         iv_1_3_int,
         iv_2_2_int, iv_2_2_dub,
         iv_3_2_set,
         iv_1_4_int, iv_1_4_utm,
         iv_2_3_int, iv_2_3_dub,
         iv_3_3_set,
         iv_4_2_str,
         iv_4_1_str
    from iv_4_1_c;
create vclass iv_5_1 as subclass of iv_4_1
  (iv_5_1_flt   float default 34028.0,
   iv_5_1_tme   time default TIME '12:00:00',
   iv_5_1_chr   char(128))
as
  select iv_0_str, NA,
         iv_1_2_int,
         iv_2_1_fbo, iv_2_1_int, iv_2_1_dub, res_test,
         iv_1_3_int,
         iv_2_2_int, iv_2_2_dub,
         iv_3_2_set,
         iv_1_4_int, iv_1_4_utm,
         iv_2_3_int, iv_2_3_dub,
         iv_3_3_set,
         iv_4_2_str,
         iv_4_1_str,
         iv_5_1_flt, iv_5_1_tme, iv_5_1_chr
    from iv_5_1_c;
create vclass iv_5_2 as subclass of iv_4_2
  (iv_5_2_flt   float default 34028.0,
   iv_5_2_tme   time,
   iv_5_2_chr   char(32))
as
  select iv_0_str, NA,
         iv_1_4_int, iv_1_4_utm,
         iv_2_3_int, iv_2_3_dub,
         iv_3_3_set,
         iv_4_2_str,
         iv_5_2_flt, iv_5_2_tme, iv_5_2_chr
    from iv_5_2_c;
create vclass iv_6_1 as subclass of iv_5_2
  (iv_6_1_dte   date default '10/22/57' )
method iv_6_1_met(timestamp,date) timestamp
function impl_iv_6_1_met
file 'impl_test_methods.o'
as
  select iv_0_str, NA,
         iv_1_4_int, iv_1_4_utm,
         iv_2_3_int, iv_2_3_dub,
         iv_3_3_set,
         iv_4_2_str,
         iv_5_2_flt, iv_5_2_tme, iv_5_2_chr,
         iv_6_1_dte
    from iv_6_1_c;
create vclass iv_7_1 as subclass of iv_6_1
  (iv_7_1_mon   monetary /*$34028.0*/,
   iv_7_1_mlt multiset_of (integer,string))
as
  select iv_0_str, NA,
         iv_1_4_int, iv_1_4_utm,
         iv_2_3_int, iv_2_3_dub,
         iv_3_3_set,
         iv_4_2_str,
         iv_5_2_flt, iv_5_2_tme, iv_5_2_chr,
         iv_6_1_dte,
         iv_7_1_mon, iv_7_1_mlt
    from iv_7_1_c;
create vclass iv_8_1 as subclass of iv_7_1
  (iv_8_1_ref1   object)
as
  select iv_0_str, NA,
         iv_1_4_int, iv_1_4_utm,
         iv_2_3_int, iv_2_3_dub,
         iv_3_3_set,
         iv_4_2_str,
         iv_5_2_flt, iv_5_2_tme, iv_5_2_chr,
         iv_6_1_dte,
         iv_7_1_mon, iv_7_1_mlt,
         iv_8_1_ref1
    from iv_8_1_c; 
insert into iv_8_1 (iv_1_4_int, iv_2_3_int)
values (5, 100);
select * from iv_8_1;
rollback work;
/* allow interpreter variables in select statements */
create class vc(i integer, f float);
insert into vc values(7, 3.1415);
select f into v from vc;
select * from vc where i > v;
select * from vc where i < v;
select i into f from vc;
select f, :f from vc where :f = 7;
rollback work;
rollback;

--+ holdcas off;
