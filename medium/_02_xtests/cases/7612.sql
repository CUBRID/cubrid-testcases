autocommit off;
create class obj_class
(
        a                       int
);
insert into obj_class values( 1 );
insert into obj_class values( 2 );
insert into obj_class values( 3 );
create class test_class
(
        id                      int     not null,
        attr_int                int,
        attr_smallint           smallint,
        attr_float              float,
        attr_double             double,
        attr_numeric            numeric,
        attr_monetary           monetary,
        attr_date               date,
        attr_time               time,
        attr_timestamp          timestamp,
        attr_char               char(10),
        attr_varchar            varchar(10),
        attr_nchar              nchar(10),
        attr_varnchar           nchar varying(10),
        attr_bit                bit(10),
        attr_varbit             bit varying(10),
        attr_object             obj_class,
        attr_set_int            set_of(integer),
        attr_set_smallint       set_of(smallint),
        attr_set_float          set_of(float),
        attr_set_double         set_of(double),
        attr_set_numeric        set_of(numeric),
        attr_set_monetary       set_of(monetary),
        attr_set_date           set_of(date),
        attr_set_time           set_of(time),
        attr_set_timestamp      set_of(timestamp),
        attr_set_char           set_of(char(4)),
        attr_set_varchar        set_of(varchar(4)),
        attr_set_nchar          set_of(nchar(4)),
        attr_set_varnchar       set_of(nchar varying(4)),
        attr_set_bit            set_of(bit(6)),
        attr_set_varbit         set_of(bit varying(6)),
        attr_set_object         set_of(obj_class),
        attr_multiset_int       multiset_of(integer),
        attr_multiset_smallint  multiset_of(smallint),
        attr_multiset_float     multiset_of(float),
        attr_multiset_double    multiset_of(double),
        attr_multiset_numeric   multiset_of(numeric),
        attr_multiset_monetary  multiset_of(monetary),
        attr_multiset_date      multiset_of(date),
        attr_multiset_time      multiset_of(time),
        attr_multiset_timestamp multiset_of(timestamp),
        attr_multiset_char      multiset_of(char(4)),
        attr_multiset_varchar   multiset_of(varchar(4)),
        attr_multiset_nchar     multiset_of(nchar(4)),
        attr_multiset_varnchar  multiset_of(nchar varying(4)),
        attr_multiset_bit       multiset_of(bit(6)),
        attr_multiset_varbit    multiset_of(bit varying(6)),
        attr_multiset_object    multiset_of(obj_class),
        attr_sequence_int       sequence_of(integer),
        attr_sequence_smallint  sequence_of(smallint),
        attr_sequence_float     sequence_of(float),
        attr_sequence_double    sequence_of(double),
        attr_sequence_numeric   sequence_of(numeric),
        attr_sequence_monetary  sequence_of(monetary),
        attr_sequence_date      sequence_of(date),
        attr_sequence_time      sequence_of(time),
        attr_sequence_timestamp sequence_of(timestamp),
        attr_sequence_char      sequence_of(char(4)),
        attr_sequence_varchar   sequence_of(varchar(4)),
        attr_sequence_nchar     sequence_of(nchar(4)),
        attr_sequence_varnchar  sequence_of(nchar varying(4)),
        attr_sequence_bit       sequence_of(bit(6)),
        attr_sequence_varbit    sequence_of(bit varying(6)),
        attr_sequence_object    sequence_of(obj_class)
);
create class ins_test as subclass of test_class(
        long_char char(16384),
        long_char1 char(16384),
        long_char2 char(16384),
        long_varchar varchar(16384),
        long_nchar nchar(8192),
        long_varnchar nchar varying(8192),
        long_bit bit(16384),
        long_varbit bit varying(16384));
insert into ins_test(id, attr_int)
         values (2, 2) ;
insert into ins_test(id, attr_int)
         values (3, 3) ;
insert into ins_test(id, attr_int)
         values (4, 4) ;
insert into ins_test(id, attr_int)
         values (5, 5) ;
insert into ins_test(id, attr_int)
         values (6, 6) ;
select * from ins_test order by id;
commit work;
drop class obj_class;
drop class ins_test; 
drop class test_class;
commit work;
create class test1 
(
    col1 char(8192),
    col2 char(8192),
    col3 char(8192),
    col4 char(8192),
    col5 char(8192),
    col6 char(8192),
    col7 char(8192),
    col8 char(8192)
);
insert into test1 (col1) values ('test');
select * from test1;
commit work;
drop class test1;
commit work;
rollback;
