--+ holdcas on;


CREATE TABLE with_trigger(a int primary key, b char(20), c double);
INSERT INTO with_trigger VALUES (1, 'AAA', 1), (2, 'BBB', 2), (3, 'CCC', 3);
SELECT * FROM with_trigger order by 1;


CREATE TRIGGER trig_bef_del BEFORE DELETE ON with_trigger EXECUTE
        INSERT INTO with_trigger VALUES (10, 'BEFORE UPDATE', 10);
CREATE TRIGGER trig_aft_del AFTER DELETE ON with_trigger EXECUTE
        INSERT INTO with_trigger VALUES (10, 'BEFORE UPDATE', 10);
		
CREATE TRIGGER trig_after_ins AFTER STATEMENT INSERT ON with_trigger EXECUTE
        DELETE FROM with_trigger WHERE a=11;


INSERT INTO with_trigger VALUES (11, 'DDD', 11);

SELECT * FROM with_trigger order by 1;

COMMIT;

SELECT * FROM with_trigger order by 1;

drop trigger trig_bef_del;
drop trigger trig_aft_del;
drop trigger trig_after_ins;
drop table with_trigger;

commit;

--+ holdcas off;

