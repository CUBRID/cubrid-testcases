CREATE TABLE vector_table (id int, embedding VECTOR(3));
CREATE VECTOR INDEX vidx_vector_table_embedding ON vector_table(embedding CONSINE);
