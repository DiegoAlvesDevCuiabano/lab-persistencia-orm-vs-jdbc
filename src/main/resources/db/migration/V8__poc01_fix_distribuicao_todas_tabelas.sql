TRUNCATE TABLE registro_evento_50k;

INSERT INTO registro_evento_50k (tipo, status, descricao, ativo, data_criacao)
SELECT
    CASE
        WHEN n1.n % 10 < 4 THEN 'A'
        WHEN n1.n % 10 < 7 THEN 'B'
        WHEN n1.n % 10 < 9 THEN 'C'
        ELSE 'D'
        END,
    CASE
        WHEN n2.n % 10 < 5 THEN 'ATIVO'
        WHEN n2.n % 10 < 7 THEN 'PENDENTE'
        ELSE 'INATIVO'
        END,
    CONCAT('Evento tipo ',
           CASE
               WHEN n1.n % 10 < 4 THEN 'A'
               WHEN n1.n % 10 < 7 THEN 'B'
               WHEN n1.n % 10 < 9 THEN 'C'
               ELSE 'D'
               END,
           ' numero ', n1.n, '-', n2.n
    ),
    CASE WHEN (n1.n + n2.n) % 10 < 7 THEN 1 ELSE 0 END,
    DATE_SUB(CURRENT_TIMESTAMP, INTERVAL (n1.n % 365) DAY)
FROM helper_numbers n1
         CROSS JOIN helper_numbers n2
    LIMIT 50000;

TRUNCATE TABLE registro_evento_500k;

INSERT INTO registro_evento_500k SELECT * FROM registro_evento_50k;

INSERT INTO registro_evento_500k (tipo, status, descricao, ativo, data_criacao)
SELECT
    CASE
        WHEN n1.n % 10 < 4 THEN 'A'
        WHEN n1.n % 10 < 7 THEN 'B'
        WHEN n1.n % 10 < 9 THEN 'C'
        ELSE 'D'
        END,
    CASE
        WHEN n2.n % 10 < 5 THEN 'ATIVO'
        WHEN n2.n % 10 < 7 THEN 'PENDENTE'
        ELSE 'INATIVO'
        END,
    CONCAT('Evento tipo ',
           CASE
               WHEN n1.n % 10 < 4 THEN 'A'
               WHEN n1.n % 10 < 7 THEN 'B'
               WHEN n1.n % 10 < 9 THEN 'C'
               ELSE 'D'
               END,
           ' numero ', n1.n, '-', n2.n
    ),
    CASE WHEN (n1.n + n2.n) % 10 < 7 THEN 1 ELSE 0 END,
    DATE_SUB(CURRENT_TIMESTAMP, INTERVAL (n1.n % 365) DAY)
FROM helper_numbers n1
         CROSS JOIN helper_numbers n2
    LIMIT 450000;

TRUNCATE TABLE registro_evento_5kk;

INSERT INTO registro_evento_5kk SELECT * FROM registro_evento_500k;

INSERT INTO registro_evento_5kk (tipo, status, descricao, ativo, data_criacao)
SELECT
    CASE
        WHEN n1.n % 10 < 4 THEN 'A'
        WHEN n1.n % 10 < 7 THEN 'B'
        WHEN n1.n % 10 < 9 THEN 'C'
        ELSE 'D'
        END,
    CASE
        WHEN n2.n % 10 < 5 THEN 'ATIVO'
        WHEN n2.n % 10 < 7 THEN 'PENDENTE'
        ELSE 'INATIVO'
        END,
    CONCAT('Evento tipo ',
           CASE
               WHEN n1.n % 10 < 4 THEN 'A'
               WHEN n1.n % 10 < 7 THEN 'B'
               WHEN n1.n % 10 < 9 THEN 'C'
               ELSE 'D'
               END,
           ' numero ', n1.n, '-', n2.n, '-', n3.n
    ),
    CASE WHEN (n1.n + n2.n + n3.n) % 10 < 7 THEN 1 ELSE 0 END,
    DATE_SUB(CURRENT_TIMESTAMP, INTERVAL ((n1.n + n2.n * 10 + n3.n * 100) % 365) DAY)
FROM helper_numbers n1
         CROSS JOIN helper_numbers n2
         CROSS JOIN helper_numbers n3
    LIMIT 4500000;