--Test optimizing class with keywork only
create class t1 (c1 int, c2 char(1));
create class sub_t1 as subclass of t1(c3 int);
create class sub_t2 as subclass of t1(c4 int);
create class sub_t3 as subclass of t1(c5 int);
create class sub_t4 as subclass of t1(c6 int);

update statistics on only t1;

drop class t1, sub_t1, sub_t2, sub_t3, sub_t4;