autocommit off;
/* $Revision: 1.2 $ */
/* This is an interesting test because it generates nested sets in the 
 * server due to how the view is translated. dkh
 */
     create vclass ctest13_a(ctest13_a_set set_of(co_2_1)) as
       select y.co_1_2_ref1
       from co_1_2 y, co_2_1 x
       where x= some y.co_1_2_ref1
       group by y.co_1_2_ref1 ;
select * from ctest13_a;
rollback work;
rollback;
