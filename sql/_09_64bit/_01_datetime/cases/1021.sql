create class test_class (set_col set datetime, list_col LIST datetime, multiset_col MULTISET datetime);

insert into test_class values ({DATETIME '1990-01-02 23:59:59.999', DATETIME '2990-01-02 23:59:59.999', DATETIME '1990-01-02 23:59:59.999'}, {DATETIME '1990-01-02 23:59:59.999', DATETIME '2990-01-02 23:59:59.999', DATETIME '1990-01-02 23:59:59.999'}, {DATETIME '1990-01-02 23:59:59.999', DATETIME '2990-01-02 23:59:59.999', DATETIME '1990-01-02 23:59:59.999'});
insert into test_class values ({'1990-01-02 23:59:59.999', '2990-01-02 23:59:59.999', '1990-01-02 23:59:59.999'}, {'1990-01-02 23:59:59.999', '2990-01-02 23:59:59.999', '1990-01-02 23:59:59.999'}, {'1990-01-02 23:59:59.999', '2990-01-02 23:59:59.999', '1990-01-02 23:59:59.999'});

update test_class set set_col = {DATETIME '1991-01-02 23:59:59.999', DATETIME '2991-01-02 23:59:59.999', DATETIME '1991-01-02 23:59:59.999'};
update test_class set list_col = {DATETIME '1991-01-02 23:59:59.999', DATETIME '2991-01-02 23:59:59.999', DATETIME '1991-01-02 23:59:59.999'};
update test_class set multiset_col = {DATETIME '1991-01-02 23:59:59.999', DATETIME '2991-01-02 23:59:59.999', DATETIME '1991-01-02 23:59:59.999'};

select * from test_class order by 1,2;

drop class test_class;

