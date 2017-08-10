--row_count(), replace into a table with a foreign key
drop table if exists with_trigger,with_trigger2,trigger_actions1,trigger_actions2;

CREATE TABLE with_trigger(a int primary key, b char(10), c int);
INSERT INTO with_trigger VALUES (1, 'AAA', 1), (2, 'BBB', 2), (3, 'CCC', 3), (4, 'DDD', 4);
SELECT * FROM with_trigger order by 1;

CREATE TABLE with_trigger2(a string unique, b int, 
			   CONSTRAINT fk_id FOREIGN KEY(b) REFERENCES with_trigger(a)
			   ON DELETE CASCADE ON UPDATE SET NULL);
INSERT INTO with_trigger2 VALUES ('AAA', 1), ('BBB', 2), ('CCC', 3);
SELECT * FROM with_trigger2 order by 1;   




--replace into a table the index of which a foreign key references
REPLACE INTO with_trigger VALUES (3, 'CCC', 5);
select row_count();


DROP TRIGGER trig_bef_del1;
DROP TRIGGER trig_aft_del1;
DROP TRIGGER trig_aft_del1_1;
DROP TRIGGER trig_bef_ins1;
DROP TRIGGER trig_aft_ins1;
DROP TRIGGER trig_aft_ins1_1;
DROP TRIGGER trig_aft_ins1_2;

DROP TRIGGER trig_bef_del2;
DROP TRIGGER trig_aft_del2;
DROP TRIGGER trig_bef_ins2;
DROP TRIGGER trig_aft_ins2;

DROP TABLE trigger_actions1;
DROP TABLE trigger_actions2;
DROP TABLE with_trigger2;
DROP TABLE with_trigger;
