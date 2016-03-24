autocommit off;
--set optimization: level 257
select big into :o1 from big where a = 1000;
alter big add class attribute kind big;
update class big set kind = :o1;
evaluate class big into :c;
select kind, kind.a, kind.b from class big x where x = :c;
rollback;
