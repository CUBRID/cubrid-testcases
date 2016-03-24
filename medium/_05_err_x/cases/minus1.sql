autocommit off;
create class footime (a time, b timestamp, c date);
select -a, -b, -c from footime;
rollback;
