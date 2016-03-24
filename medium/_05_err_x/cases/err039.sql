autocommit off;

create vclass vsd_0_c on ldb udb
(vsd_0_str  string default 'Its')
method vsd_0_met(string) string
function impl_vsd_0_met
file 'impl_test_methods.o'
as
  select vsd_0_str
    from vsd_0;
create vclass vsd_1_1_c on ldb udb /* as subclass of vsd_0_c */
  (vsd_0_str  string default 'Its',
   vsd_1_1_int  integer default 1000,
   res_test integer)
as
  select vsd_0_str,
         vsd_1_1_int, res_test
    from vsd_1_1;
create vclass vsd_1_2_c on ldb udb /* as subclass of vsd_0_c */
  (vsd_0_str  string default 'Its',
   vsd_1_2_int  integer default 2000)
as
  select vsd_0_str,
         vsd_1_2_int
    from vsd_1_2;
create vclass vsd_2_1_c on ldb udb /* as subclass of vsd_1_2_c */
  (/* vsd_2_1_fbo   elo,  */
   vsd_0_str  string default 'Its',
   vsd_1_2_int  integer default 2000,
   vsd_2_1_int   integer default -2147483647,
   vsd_2_1_dub   double default 1.797693e+308,
   res_test     float default 3402823.000000)
as
  select vsd_0_str,
         vsd_1_2_int,
         vsd_2_1_int, vsd_2_1_dub, res_test
    from vsd_2_1;
create vclass vsd_3_1_c on ldb udb /* as subclass of vsd_2_1_c, vsd_1_1_c */
  (vsd_0_str  string default 'Its',
   vsd_1_2_int  integer default 2000,
   vsd_2_1_int   integer default -2147483647,
   vsd_2_1_dub   double default 1.797693e+308,
   vsd_2_1_res_test  float default 34028234.000000,
   vsd_1_1_res_test integer,
   vsd_1_1_int  integer default 1000,
   vsd_3_1_set   set_of integer)
as
  select vsd_0_str,
         vsd_1_2_int,
         vsd_2_1_int, vsd_2_1_dub, vsd_2_1_res_test,
         vsd_1_1_res_test, vsd_1_1_int,
         vsd_3_1_set
    from vsd_3_1;
create vclass vsd_0
(vsd_0_str  string default 'Its'
/* vsd_0_shared_flt float shared 100.0,
 class vsd_0_class_int integer default 0 */ )
method vsd_0_met(string) string
function impl_vsd_0_met
file 'impl_test_methods.o'
as
  select vsd_0_str
    from vsd_0_c;
create vclass vsd_1_1 as subclass of vsd_0
  (vsd_1_1_int  integer default 1000,
   res_test integer)
as
  select vsd_0_str,
         vsd_1_1_int, res_test
    from vsd_1_1_c;
create vclass vsd_1_2 as subclass of vsd_0
  (vsd_1_2_int  integer default 2000)
as
  select vsd_0_str,
         vsd_1_2_int
    from vsd_1_2_c;
create vclass vsd_2_1 as subclass of vsd_1_2
  (/* vsd_2_1_fbo   elo,  */
   vsd_2_1_int   integer default -2147483647,
   vsd_2_1_dub   double default 1.797693e+308,
   res_test     float default 34028234.000000)
as
  select vsd_0_str,
         vsd_1_2_int,
         vsd_2_1_int, vsd_2_1_dub, res_test
    from vsd_2_1_c;
create vclass vsd_3_1 as subclass of vsd_2_1 /*, vsd_1_1 */
  (vsd_3_1_set   set_of integer)
inherit  res_test of vsd_1_1 as vsd_1_1_res_test,
         res_test of vsd_2_1 as vsd_2_1_res_test
as
  select vsd_0_str,
         vsd_1_2_int,
         vsd_2_1_int, vsd_2_1_dub, vsd_2_1_res_test,
         /* vsd_1_1_int, vsd_1_1_res_test, */
         vsd_3_1_set
    from vsd_3_1_c;
rollback;
