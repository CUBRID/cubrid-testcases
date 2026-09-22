/* 3. Verify SERVER option numeric values (PORT) */

DROP SERVER IF EXISTS srv1;

-- ===========================================================================
-- PORT range check
-- ===========================================================================
evaluate '1. PORT out of range (error)';
-- Expect error when PORT is out of the supported range (±10^38)
CREATE SERVER srv1 (
  HOST='localhost',
  PORT=100000000000000000000000000000000000000,
  DBNAME=demodb,
  USER=dba
);

evaluate '2. PORT in range';
CREATE SERVER srv1 (
  HOST='localhost',
  PORT=30000,
  DBNAME=demodb,
  USER=dba
);

evaluate '3. ALTER PORT out of range (error)';
-- Expect error when ALTER PORT is out of the supported range (±10^38)
ALTER SERVER srv1 CHANGE PORT=100000000000000000000000000000000000000;

DROP SERVER IF EXISTS srv1;
