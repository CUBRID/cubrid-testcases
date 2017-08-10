--test multiple rows select using a select query and set, multiset, sequence types

create class t15(
    data_set set ( string ),
    data_multiset multiset( string ),
    data_sequence sequence( string ));

insert into t15 values ({'a','a','b','e','d', 'null' , null ,''},
                        {'a','a','b','e','d', 'null' , null ,''},  
                        {'a','a','b','e','d', 'null' , null ,''});
select * from t15 order by 1;


drop class t15;
