--test update statistics on view
create class t1 (c1 int, c2 char(1));
create vclass v_t1 as select c1 from t1;

update statistics on only v_t1;

drop class t1;
drop vclass v_t1;

