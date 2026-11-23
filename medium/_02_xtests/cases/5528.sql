autocommit off;
        create class sample (purpose set(string));
        insert into sample(purpose) values({'aaa', 'bbb'});
        insert into sample(purpose) values({'aaa', NULL});
        insert into sample(purpose) values({'aaa', 'bbb'});
        insert into sample(purpose) values({'aaa', 'ccc'});
        insert into sample(purpose) values({'aaa'});
        select * from sample where {'aaa'} subseteq purpose
        order by case
          when 'bbb' in purpose then 1
          when 'ccc' in purpose then 3
          when purpose = {'aaa'} then 4
          else 2
        end;
rollback;
