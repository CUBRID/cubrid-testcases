autocommit off;
        create class sample (purpose set(string));
        insert into sample(purpose) values({'aaa', 'bbb'});
        insert into sample(purpose) values({'aaa', NULL});
        insert into sample(purpose) values({'aaa', 'bbb'});
        insert into sample(purpose) values({'aaa', 'ccc'});
        insert into sample(purpose) values({'aaa'});
        select * from sample where {'aaa'} subseteq purpose;
rollback;
