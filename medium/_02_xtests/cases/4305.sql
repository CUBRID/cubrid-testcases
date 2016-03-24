autocommit off;
create class foo (
           short_attr  short, 
           int_attr int,
           float_attr float,
           double_attr double,
           str_attr string,
           time_attr time,
           timestamp_attr timestamp,
           date_attr date,
           monetary_attr monetary,
           set_int_attr set(int),
           multiset_int_attr multiset(int),
           seq_int_attr sequence(int)
        )
   
	method get_cur_obj() foo
               function get_cur_obj,
	       add_short(short, short) short
		function add_short,
	       add_int(int, int) int
		function add_int,
	       add_float(float, float) float
		function add_float,
	       add_double(double, double) double
		function add_double,
	       add_time(time, int) time
		function add_time,
	       add_timestamp(timestamp, timestamp) timestamp
		function add_timestamp,
	       add_monetary(monetary, monetary) monetary
		function add_monetary,
	       add_date(date, int) date
		function add_date,
	       add_str(string, string) string
		function add_str,
	       inc_set(set(int)) int
                function inc_set,
	   
    sum_set(set(int)) int
                function sum_set
	file 'it-doesnt-matter-its-not-linked.o';
create class foo_foo (
           fshort_attr  short, 
           fint_attr int,
           ffloat_attr float,
           fdouble_attr double,
           fstr_attr string,
           ftime_attr time,
           ftimestamp_attr timestamp,
           fdate_attr date,
           fmonetary_attr monetary,
           one_foo foo)
   	method  get_cur_obj() foo_foo
               function get_cur_obj,
	       add_short(short, short) short
		function add_short,
	       add_int(int, int) int
		function add_int,
	       add_float(float, float) float
		function add_float,
	       add_double(double, double) double
		function add_double,
	       add_time(time, time) time
		function add_time,
	       add_timestamp(timestamp, timestamp) timestamp
		function add_timestamp,
	       add_monetary(monetary, monetary) monetary
		function add_monetary,
	       add_date(date, int) date
		function add_date,
	       add_str(string, string) string
		function add_str,
	       inc_set(set(int)) int
                function inc_set,
	       sum_set(set(int)) int
                function sum_set
	file 'it-doesnt-matter-its-not-linked.o';
insert into foo values (1, 10, 11.1, 111.11,'foo string 1', TIME '08:00:01', TIMESTAMP '3/1/1993 8:1 am', DATE '1/1/1993', 17000,{-10, 0, 10}, {10,10,10},{1,2,3}) to p1;
insert into foo values (2, 20, 22.2, 222.22,'foo string 2', TIME '08:00:02', TIMESTAMP '3/2/1993 8:2 am', DATE '2/2/1993', 27000,{-20, 0, 20}, {20,20,20},{2,2,3}) to p2;
insert into foo values (3, 30, 33.3, 333.33,'foo string 3', TIME '08:00:03', TIMESTAMP '3/3/1993 8:3 am', DATE '3/3/1993', 37000,{-30, 0, 30}, {30,30,30},{3,2,3}) to p3;
insert into foo values (4, 40, 44.4, 444.44,'foo string 4', TIME '08:00:04', TIMESTAMP '3/4/1993 8:4 am', DATE '4/4/1993', 47000,{-40, 0, 40}, {40,40,40},{4,2,3}) to p4;
insert into foo values (5, 50, 55.5, 555.55,'foo string 5', TIME '08:00:05', TIMESTAMP '3/5/1993 8:5 am', DATE '5/5/1993', 57000,{-50, 0, 50}, {50,50,50},{5,2,3}) to p5;
insert into foo_foo values (1, 10, 11.1, 111.11,'foo string 1', TIME '08:01:00', TIMESTAMP '3/1/1993 8:0 am', DATE '1/1/1993', 17000, NULL);
insert into foo_foo values (2, 20, 22.2, 222.22,'foo string 2', TIME '08:02:00', TIMESTAMP '3/2/1993 8:0 am', DATE '2/2/1993', 27000, p2);
insert into foo_foo values (3, 30, 33.3, 333.33,'foo string 3', TIME '08:03:00', TIMESTAMP '3/3/1993 8:0 am', DATE '3/3/1993', 37000, p3);
delete from foo where short_attr > 1;
select fshort_attr, add_short(one_foo, one_foo.short_attr, fshort_attr) from foo_foo;
rollback;
