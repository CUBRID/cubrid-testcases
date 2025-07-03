-------------------------------------------------------------------------------
-- Literal Comparison
-------------------------------------------------------------------------------
select
  vector_distance('[11, 2, 3]', '[2, 3, 4]', COSINE),
  '[11, 2, 3]' <c> '[2, 3, 4]';

select
  vector_distance('[1, 2, 3]', '[2, 3, 4]', DOT),
  inner_product('[1, 2, 3]', '[2, 3, 4]'),
  '[1, 2, 3]' <#> '[2, 3, 4]';

select
  vector_distance('[1, 2, 3]', '[2, 3, 4]', EUCLIDEAN),
  '[1, 2, 3]' <-> '[2, 3, 4]';

select
  vector_distance('[1, 2, 3]', '[2, 3, 4]', MANHATTAN),
  '[1, 2, 3]' <+> '[2, 3, 4]';

-------------------------------------------------------------------------------
-- Column Comparison
-------------------------------------------------------------------------------

-- Setup
DROP IF EXISTS vec_test;

CREATE TABLE vec_test (
    id INT,
    vec1 VECTOR(3),
    vec2 VECTOR(3)
);

INSERT INTO vec_test VALUES
  (1, '[1, 2, 3]', '[2, 3, 4]'),           -- general case
  (2, '[1, 0, 0]', '[0, 1, 0]'),           -- orthogonal vectors
  (3, '[1, 2, 3]', '[1, 2, 3]'),           -- identical vectors
  (4, '[0, 0, 0]', '[1, 2, 3]'),           -- one zero vector
  (5, '[0, 0, 0]', '[0, 0, 0]'),           -- both zero vectors
  (6, '[-1, -2, -3]', '[1, 2, 3]'),        -- opposite vectors
  (7, '[10, 20, 30]', '[30, 20, 10]'),     -- permuted values
  (8, '[3, -3, 3]', '[-3, 3, -3]');        -- mixed signs

-------------------------------------------------------------------------------
-- COSINE SIMILARITY
-------------------------------------------------------------------------------
-- vector_distance(vec1, vec2, COSINE) == vec1 <c> vec2

SELECT id,
       vector_distance(vec1, vec2, COSINE) AS cosine_fn,
       vec1 <c> vec2 AS cosine_op
FROM vec_test;

-------------------------------------------------------------------------------
-- INNER PRODUCT (DOT PRODUCT)
-------------------------------------------------------------------------------
-- vector_distance(vec1, vec2, DOT) == inner_product(vec1, vec2) == vec1 <#> vec2

SELECT id,
       vector_distance(vec1, vec2, DOT) AS dot_fn,
       inner_product(vec1, vec2) AS dot_named,
       vec1 <#> vec2 AS dot_op
FROM vec_test;

-------------------------------------------------------------------------------
-- EUCLIDEAN DISTANCE
-------------------------------------------------------------------------------
-- vector_distance(vec1, vec2, EUCLIDEAN) == vec1 <-> vec2

SELECT id,
       vector_distance(vec1, vec2, EUCLIDEAN) AS euclid_fn,
       vec1 <-> vec2 AS euclid_op
FROM vec_test;

-------------------------------------------------------------------------------
-- MANHATTAN DISTANCE
-------------------------------------------------------------------------------
-- vector_distance(vec1, vec2, MANHATTAN) == vec1 <+> vec2

SELECT id,
       vector_distance(vec1, vec2, MANHATTAN) AS manhattan_fn,
       vec1 <+> vec2 AS manhattan_op
FROM vec_test;

