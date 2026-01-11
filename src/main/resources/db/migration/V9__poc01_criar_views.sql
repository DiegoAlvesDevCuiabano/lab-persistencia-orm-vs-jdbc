CREATE VIEW vw_registro_evento_ativo_50k AS
SELECT
    id,
    tipo,
    status,
    descricao,
    ativo,
    data_criacao
FROM registro_evento_50k
WHERE ativo = 1;

CREATE VIEW vw_registro_evento_ativo_500k AS
SELECT
    id,
    tipo,
    status,
    descricao,
    ativo,
    data_criacao
FROM registro_evento_500k
WHERE ativo = 1;

CREATE VIEW vw_registro_evento_ativo_5kk AS
SELECT
    id,
    tipo,
    status,
    descricao,
    ativo,
    data_criacao
FROM registro_evento_5kk
WHERE ativo = 1;