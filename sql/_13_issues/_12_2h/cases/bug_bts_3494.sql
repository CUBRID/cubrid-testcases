--TEST: evaluate timestamp (:str_date) into :expected; returns null

evaluate '05/26/2010' into :str_date;
evaluate timestamp (:str_date) into :expected;
evaluate timestamp (:expected) into :v1;
evaluate date (:v1) into :v2;
evaluate (:v2) into :v3;
evaluate date (:v3) into :v4;

