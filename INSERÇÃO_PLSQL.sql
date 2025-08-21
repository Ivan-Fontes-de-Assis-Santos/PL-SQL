EXEC DBMS_RANDOM.SEED(681457802);

--CRIANDO TABELAS TEMPORARIAS--
CREATE GLOBAL TEMPORARY TABLE primeirosNomes
(codigo INTEGER NOT NULL PRIMARY KEY,
    nome VARCHAR(40) NOT NULL);
    
CREATE GLOBAL TEMPORARY TABLE sobreNomes
(codigo INTEGER NOT NULL PRIMARY KEY,
    nome VARCHAR(40) NOT NULL);
    
CREATE GLOBAL TEMPORARY TABLE randomico
(codigo INTEGER NOT NULL PRIMARY KEY,
    nome VARCHAR(40) NOT NULL);
    
--CRIANDO OS CLIENTES--
DECLARE
    V_PRIMEIRO_NOME VARCHAR2(40);
    V_SOBRENOME     VARCHAR2(40);
    V_PROFISSAO     VARCHAR2(40);
BEGIN
    -- Populando primeiros nomes
    INSERT INTO primeirosNomes VALUES(1,'Paulo');
    INSERT INTO primeirosNomes VALUES(2,'Fernando');
    INSERT INTO primeirosNomes VALUES(3,'Aline');
    INSERT INTO primeirosNomes VALUES(4,'Amanda');
    INSERT INTO primeirosNomes VALUES(5,'Vanessa');
    INSERT INTO primeirosNomes VALUES(6,'Patricia');
    INSERT INTO primeirosNomes VALUES(7,'Mario');
    INSERT INTO primeirosNomes VALUES(8,'Thiago');
    INSERT INTO primeirosNomes VALUES(9,'Pedro');
    INSERT INTO primeirosNomes VALUES(10,'Lucas');
    
    -- Populando sobrenomes
    INSERT INTO sobreNomes VALUES(1,'Silva');
    INSERT INTO sobreNomes VALUES(2,'Souza');
    INSERT INTO sobreNomes VALUES(3,'Lima');
    INSERT INTO sobreNomes VALUES(4,'Pereira');
    INSERT INTO sobreNomes VALUES(5,'Fernandes');
    INSERT INTO sobreNomes VALUES(6,'Pinheiro');
    INSERT INTO sobreNomes VALUES(7,'Pereira');
    INSERT INTO sobreNomes VALUES(8,'Oliveira');
    INSERT INTO sobreNomes VALUES(9,'Ramos');
    INSERT INTO sobreNomes VALUES(10,'Santos');
    
    -- Populando profissões
    INSERT INTO randomico VALUES(1,'Medico(a)');
    INSERT INTO randomico VALUES(2,'Advogado(a)');
    INSERT INTO randomico VALUES(3,'Professor(a)');
    INSERT INTO randomico VALUES(4,'Designer Grafico');
    INSERT INTO randomico VALUES(5,'Secretario(a)');
    INSERT INTO randomico VALUES(6,'Engenheiro(a) Civil');
    INSERT INTO randomico VALUES(7,'Enfermeiro(a)');
    INSERT INTO randomico VALUES(8,'Marceneiro(a)');
    INSERT INTO randomico VALUES(9,'Jornalista');
    INSERT INTO randomico VALUES(10,'Contador(a)');
    
    -- Loop para criar clientes
    FOR V_CONTADOR IN 1..100 LOOP
        SELECT nome INTO V_PRIMEIRO_NOME
        FROM primeirosNomes
        WHERE codigo = TRUNC(DBMS_RANDOM.VALUE(1,11));
        
        SELECT nome INTO V_SOBRENOME
        FROM sobreNomes
        WHERE codigo = TRUNC(DBMS_RANDOM.VALUE(1,11));
        
        SELECT nome INTO V_PROFISSAO
        FROM randomico
        WHERE codigo = TRUNC(DBMS_RANDOM.VALUE(1,11));
        
        INSERT INTO TB_CLIENTE
            (CD_CLIENTE, NM_CLIENTE, DS_CLIENTE_PROFISSAO, NU_CLIENTE_CPF, DT_CLIENTE_NASC) 
        VALUES
            (SQ_CLIENTE.NEXTVAL, 
             V_PRIMEIRO_NOME || ' ' || V_SOBRENOME, 
             V_PROFISSAO,
             TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(10000000000,99999999999))),
             SYSDATE - TRUNC(DBMS_RANDOM.VALUE(15000, 45000)));
    END LOOP;
    
    COMMIT;
END;
/


SELECT * FROM TB_CLIENTE;

--CRIANDO OS QUARTOS--
DECLARE
    V_CONTADOR  INTEGER;
    V_NU_QUARTO INTEGER;
    V_FG_QUARTO_SITUACAO    VARCHAR2(40);
    V_TOTAL INTEGER;
BEGIN
    INSERT INTO randomico VALUES(1,'Ativo');
    INSERT INTO randomico VALUES(2,'Reforma');
    INSERT INTO randomico VALUES(3,'Limpeza');
    
    FOR V_CONTADOR IN 1..100 LOOP
        -- Garante NU_QUARTO único
        LOOP
            SELECT TRUNC(DBMS_RANDOM.VALUE(100,500))
            INTO V_NU_QUARTO
            FROM DUAL;
            
            SELECT COUNT(*) 
            INTO V_TOTAL 
            FROM TB_QUARTO 
            WHERE NU_QUARTO = V_NU_QUARTO;
            
            EXIT WHEN V_TOTAL = 0; -- sai se não existir esse número de quarto ainda
        END LOOP;
        
        SELECT nome
        INTO V_FG_QUARTO_SITUACAO
        FROM randomico
        WHERE codigo = TRUNC(DBMS_RANDOM.VALUE(1,4));
        
        INSERT INTO TB_QUARTO
            (CD_QUARTO, NU_QUARTO,CD_TIPO_SITUACAO, FG_QUARTO_SITUACAO)
        VALUES
            (SQ_QUARTO.NEXTVAL, V_NU_QUARTO, TRUNC(DBMS_RANDOM.VALUE(1,6)), V_FG_QUARTO_SITUACAO);
    END LOOP;
    
    COMMIT;
END;
/

--GERANDO AS HOSPEDAGENS--
DECLARE
    V_CONTADOR INTEGER;
    V_CD_QUARTO INTEGER;
    V_DIAS_ATRAS INTEGER;
    V_DIAS_PERIODO INTEGER;
    V_VL_DIARIA NUMBER(7,2);
BEGIN
    FOR V_CONTADOR IN 1..2000 LOOP
        -- número de dias atrás
        V_DIAS_ATRAS := TRUNC(DBMS_RANDOM.VALUE(1,1800));
        
        -- período da hospedagem
        V_DIAS_PERIODO := TRUNC(DBMS_RANDOM.VALUE(1,15));
        
        -- pega um quarto ativo aleatório com join direto
        SELECT Q.CD_QUARTO, T.VL_TIPO_QUARTO_DIARIA
        INTO V_CD_QUARTO, V_VL_DIARIA
        FROM (
            SELECT Q.CD_QUARTO, Q.CD_TIPO_SITUACAO, DBMS_RANDOM.VALUE AS RANDOM
            FROM TB_QUARTO Q
            WHERE Q.FG_QUARTO_SITUACAO = 'Ativo'
            ORDER BY RANDOM
        ) Q
        INNER JOIN TB_TIPO_QUARTO T ON Q.CD_TIPO_SITUACAO = T.CD_TIPO_QUARTO
        WHERE ROWNUM = 1;
        
        -- insere hospedagem
        INSERT INTO TB_HOSPEDAGEM
            (CD_HOSPEDAGEM, CD_CLIENTE, DT_HOSPEDAGEM_INICIO, DT_HOSPEDAGEM_FIM, VL_HOSPEDAGEM, CD_QUARTO)
        VALUES
            (SQ_HOSPEDAGEM.NEXTVAL, 
             TRUNC(DBMS_RANDOM.VALUE(1,101)),
             SYSDATE - V_DIAS_ATRAS,
             SYSDATE - V_DIAS_ATRAS + V_DIAS_PERIODO,
             V_VL_DIARIA * V_DIAS_PERIODO,
             V_CD_QUARTO);
    END LOOP;
    COMMIT;
END;
/
