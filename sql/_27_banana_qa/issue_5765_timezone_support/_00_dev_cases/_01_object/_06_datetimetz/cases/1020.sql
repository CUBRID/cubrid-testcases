create class test_class (set_col set datetimetz, list_col LIST datetimetz, multiset_col MULTISET datetimetz);

insert into test_class values ({datetimetz '1990-01-02 23:59:59.999', datetimetz '2990-01-02 23:59:59.999', datetimetz '1990-01-02 23:59:59.999'}, {datetimetz '1990-01-02 23:59:59.999', datetimetz '2990-01-02 23:59:59.999', datetimetz '1990-01-02 23:59:59.999'}, {datetimetz '1990-01-02 23:59:59.999', datetimetz '2990-01-02 23:59:59.999', datetimetz '1990-01-02 23:59:59.999'});
insert into test_class values ({'1990-01-02 23:59:59.999', '2990-01-02 23:59:59.999', '1990-01-02 23:59:59.999'}, {'1990-01-02 23:59:59.999', '2990-01-02 23:59:59.999', '1990-01-02 23:59:59.999'}, {'1990-01-02 23:59:59.999', '2990-01-02 23:59:59.999', '1990-01-02 23:59:59.999'});

select * from test_class order by 1,2;

drop class test_class;

