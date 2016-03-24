autocommit off;
create class nest_ap(nest_ap_int int, nest_ap_str string);
create class nest_bp(nest_bp_int int, nest_bp_str string);
create class nest_cp(nest_cp_int int, nest_cp_str string);
create class nest_a(nest_a_int int, nest_a_str string, nest_a_ref nest_ap);
create class nest_b(nest_b_int int, nest_b_str string, nest_b_ref nest_bp);
create class nest_c(nest_c_int int, nest_c_str string, nest_c_ref nest_cp)
	method class set_cost(string, string) function qo_set_cost;
insert into nest_ap(nest_ap_int, nest_ap_str) values(0, 'bat') into :a0;
insert into nest_ap(nest_ap_int, nest_ap_str) values(1, 'cat') into :a1; 
insert into nest_ap(nest_ap_int, nest_ap_str) values(2, 'cow') into :a2;
insert into nest_ap(nest_ap_int, nest_ap_str) values(3, 'dog') into :a3;
insert into nest_ap(nest_ap_int, nest_ap_str) values(4, 'eel') into :a4;
insert into nest_ap(nest_ap_int, nest_ap_str) values(5, 'emu') into :a5;
insert into nest_ap(nest_ap_int, nest_ap_str) values(6, 'gnu') into :a6;
insert into nest_ap(nest_ap_int, nest_ap_str) values(7, 'hog') into :a7;
insert into nest_ap(nest_ap_int, nest_ap_str) values(8, 'pig') into :a8;
insert into nest_ap(nest_ap_int, nest_ap_str) values(9, 'rat') into :a9;
insert into nest_bp(nest_bp_int, nest_bp_str) values(9, 'cow') into :b0;
insert into nest_bp(nest_bp_int, nest_bp_str) values(7, 'cat') into :b1; 
insert into nest_bp(nest_bp_int, nest_bp_str) values(5, 'dog') into :b2;
insert into nest_bp(nest_bp_int, nest_bp_str) values(3, 'emu') into :b3;
insert into nest_bp(nest_bp_int, nest_bp_str) values(1, 'eel') into :b4;
insert into nest_bp(nest_bp_int, nest_bp_str) values(2, 'hog') into :b5;
insert into nest_bp(nest_bp_int, nest_bp_str) values(4, 'gnu') into :b6;
insert into nest_bp(nest_bp_int, nest_bp_str) values(6, 'bat') into :b7;
insert into nest_bp(nest_bp_int, nest_bp_str) values(8, 'pig') into :b8;
insert into nest_bp(nest_bp_int, nest_bp_str) values(0, 'rat') into :b9;
insert into nest_cp(nest_cp_int, nest_cp_str) values(0, 'dog') into :c0;
insert into nest_cp(nest_cp_int, nest_cp_str) values(2, 'cat') into :c1;
insert into nest_cp(nest_cp_int, nest_cp_str) values(4, 'cow') into :c2;
insert into nest_cp(nest_cp_int, nest_cp_str) values(6, 'bat') into :c3;
insert into nest_cp(nest_cp_int, nest_cp_str) values(8, 'rat') into :c4;
insert into nest_cp(nest_cp_int, nest_cp_str) values(1, 'emu') into :c5;
insert into nest_cp(nest_cp_int, nest_cp_str) values(3, 'gnu') into :c6;
insert into nest_cp(nest_cp_int, nest_cp_str) values(5, 'hog') into :c7;
insert into nest_cp(nest_cp_int, nest_cp_str) values(7, 'pig') into :c8; 
insert into nest_cp(nest_cp_int, nest_cp_str) values(9, 'eel') into :c9;
insert into nest_a(nest_a_int, nest_a_str, nest_a_ref) values(0, 'bat', :a0); 
insert into nest_a(nest_a_int, nest_a_str, nest_a_ref) values(1, 'cat', :a1); 
insert into nest_a(nest_a_int, nest_a_str, nest_a_ref) values(2, 'cow', :a2); 
insert into nest_a(nest_a_int, nest_a_str, nest_a_ref) values(3, 'dog', :a3); 
insert into nest_a(nest_a_int, nest_a_str, nest_a_ref) values(4, 'eel', :a4); 
insert into nest_a(nest_a_int, nest_a_str, nest_a_ref) values(5, 'emu', :a5); 
insert into nest_a(nest_a_int, nest_a_str, nest_a_ref) values(6, 'gnu', :a6); 
insert into nest_a(nest_a_int, nest_a_str, nest_a_ref) values(7, 'hog', :a7); 
insert into nest_a(nest_a_int, nest_a_str, nest_a_ref) values(8, 'pig', :a8); 
insert into nest_a(nest_a_int, nest_a_str, nest_a_ref) values(9, 'rat', :a9); 
insert into nest_b(nest_b_int, nest_b_str, nest_b_ref) values(9, 'cow', :b0);
insert into nest_b(nest_b_int, nest_b_str, nest_b_ref) values(7, 'cat', :b1); 
insert into nest_b(nest_b_int, nest_b_str, nest_b_ref) values(5, 'dog', :b2);
insert into nest_b(nest_b_int, nest_b_str, nest_b_ref) values(3, 'emu', :b3);
insert into nest_b(nest_b_int, nest_b_str, nest_b_ref) values(1, 'eel', :b4);
insert into nest_b(nest_b_int, nest_b_str, nest_b_ref) values(2, 'hog', :b5);
insert into nest_b(nest_b_int, nest_b_str, nest_b_ref) values(4, 'gnu', :b6);
insert into nest_b(nest_b_int, nest_b_str, nest_b_ref) values(6, 'bat', :b7);
insert into nest_b(nest_b_int, nest_b_str, nest_b_ref) values(8, 'pig', :b8);
insert into nest_b(nest_b_int, nest_b_str, nest_b_ref) values(0, 'rat', :b9);
insert into nest_c(nest_c_int, nest_c_str, nest_c_ref) values(0, 'dog', :c0);
insert into nest_c(nest_c_int, nest_c_str, nest_c_ref) values(2, 'cat', :c1);
insert into nest_c(nest_c_int, nest_c_str, nest_c_ref) values(4, 'cow', :c2);
insert into nest_c(nest_c_int, nest_c_str, nest_c_ref) values(6, 'bat', :c3);
insert into nest_c(nest_c_int, nest_c_str, nest_c_ref) values(8, 'rat', :c4);
insert into nest_c(nest_c_int, nest_c_str, nest_c_ref) values(1, 'emu', :c5);
insert into nest_c(nest_c_int, nest_c_str, nest_c_ref) values(3, 'gnu', :c6);
insert into nest_c(nest_c_int, nest_c_str, nest_c_ref) values(5, 'hog', :c7);
insert into nest_c(nest_c_int, nest_c_str, nest_c_ref) values(7, 'pig', :c8); 
insert into nest_c(nest_c_int, nest_c_str, nest_c_ref) values(9, 'eel', :c9);
--set optimization: level 257;
call set_cost('m-join', 'i') on class nest_c;
call set_cost('nl-join', 'i') on class nest_c; 
call set_cost('follow', '0') on class nest_c;
select nest_a_ref.nest_ap_int
  from nest_a x
 where nest_a_ref.nest_ap_str in
       ( select nest_b_ref.nest_bp_str
           from nest_b
          where nest_b_ref.nest_bp_int in
                ( select nest_c_ref.nest_cp_int
                    from nest_c
                   where nest_c_ref.nest_cp_str > x.nest_a_ref.nest_ap_str));
call set_cost('m-join', '0') on class nest_c;
call set_cost('follow', 'i') on class nest_c;
call set_cost('nl-join', 'i') on class nest_c; 
select nest_a_ref.nest_ap_int
  from nest_a x
 where nest_a_ref.nest_ap_str in
       ( select nest_b_ref.nest_bp_str
           from nest_b
          where nest_b_ref.nest_bp_int in
                ( select nest_c_ref.nest_cp_int
                    from nest_c
                   where nest_c_ref.nest_cp_str > x.nest_a_ref.nest_ap_str));
rollback;
