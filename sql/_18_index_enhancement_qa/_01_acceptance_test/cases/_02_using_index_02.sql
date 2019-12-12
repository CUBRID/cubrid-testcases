--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
CREATE TABLE tx (col1 int, col2 int, col3 int,col4 int);
CREATE TABLE ty (col1 int, col2 int, col3 int,col4 int);

CREATE INDEX idx_tx_a ON tx(col1);
CREATE INDEX idx_tx_ab ON tx(col1,col2);
CREATE INDEX idx_tx_ac ON tx(col1,col3);
CREATE INDEX idx_tx_ad ON tx(col1,col4);

CREATE INDEX idx_ty_a ON ty(col1);
CREATE INDEX idx_ty_ab ON ty(col1,col2);
CREATE INDEX idx_ty_ac ON ty(col1,col3);
CREATE INDEX idx_ty_ad ON ty(col1,col4);

INSERT INTO tx SELECT ROWNUM,ROWNUM,ROWNUM,ROWNUM from db_class limit 30;
INSERT INTO ty SELECT * FROM tx;

--TEST: compare sequential scan on tx and idx_tx_ab index scan, choose the best plan; 
--compare sequential scan on t2 and idx_ty_a, idx_ty_ab, idx_ty_ac, idx_ty_ad index scans, choose the best plan; 
SELECT /*+ RECOMPILE */ tx.*,ty.* FROM tx,ty WHERE tx.col1<=10 AND tx.col1=ty.col1 USING INDEX tx.idx_tx_ab ORDER BY tx.col1;

--TEST: Should support no index syntax
SELECT /*+ RECOMPILE */ tx.*,ty.* FROM tx,ty WHERE tx.col1<=10 AND tx.col1=ty.col1 USING INDEX tx.NONE, ty.idx_ty_ab ORDER BY tx.col1;

DROP TABLE tx,ty;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
