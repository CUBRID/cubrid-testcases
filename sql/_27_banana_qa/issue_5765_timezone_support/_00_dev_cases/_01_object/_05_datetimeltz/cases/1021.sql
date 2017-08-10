create class test_class (set_col set datetimeltz, list_col LIST datetimeltz, multiset_col MULTISET datetimeltz);

insert into test_class values ({datetimeltz '1990-01-02 23:59:59.999', datetimeltz '2990-01-02 23:59:59.999', datetimeltz '1990-01-02 23:59:59.999'}, {datetimeltz '1990-01-02 23:59:59.999', datetimeltz '2990-01-02 23:59:59.999', datetimeltz '1990-01-02 23:59:59.999'}, {datetimeltz '1990-01-02 23:59:59.999', datetimeltz '2990-01-02 23:59:59.999', datetimeltz '1990-01-02 23:59:59.999'});
insert into test_class values ({'1990-01-02 23:59:59.999', '2990-01-02 23:59:59.999', '1990-01-02 23:59:59.999'}, {'1990-01-02 23:59:59.999', '2990-01-02 23:59:59.999', '1990-01-02 23:59:59.999'}, {'1990-01-02 23:59:59.999', '2990-01-02 23:59:59.999', '1990-01-02 23:59:59.999'});

update test_class set set_col = {datetimeltz '1991-01-02 23:59:59.999', datetimeltz '2991-01-02 23:59:59.999', datetimeltz '1991-01-02 23:59:59.999'};
update test_class set list_col = {datetimeltz '1991-01-02 23:59:59.999', datetimeltz '2991-01-02 23:59:59.999', datetimeltz '1991-01-02 23:59:59.999'};
update test_class set multiset_col = {datetimeltz '1991-01-02 23:59:59.999', datetimeltz '2991-01-02 23:59:59.999', datetimeltz '1991-01-02 23:59:59.999'};

select * from test_class order by 1,2;

drop class test_class;

