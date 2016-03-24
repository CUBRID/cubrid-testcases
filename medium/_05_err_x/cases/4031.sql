autocommit off;

set trigger trace on;
create class p_c_data
(total integer, costly integer, neg integer, most_expensive monetary)
 method upd_mon(string, monetary) integer function upd_mon,
   class get_p() p_c_data function get_p
 file 'trigger_meth.o'
;
create class p_c
(
  product_code integer,
  descr string,
  price monetary 
)
  method cmp_mon(string, monetary) integer function cmp_mon,
         upd_mon(string, monetary) integer function upd_mon,
         del_p_c() integer function del_p_c,
    class ins_p_c(integer, string, monetary)  p_c function ins_p_c
  file 'trigger_meth.o'
;
create trigger t0
priority 1.0
after insert on p_c
if cmp_mon(obj, 'price', $0) < 0
execute update p_c_data set neg = neg + 1;
insert into p_c
(product_code, descr, price) values
(0, 'nogood', -$3.95);
rollback;
