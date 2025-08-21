--STORED PROCEDURES--
--ARMAZENAR REGRAS DE NEGOCIO E ARMAZENAMENTO--

-- PROCEDURE BÁSICA QUE CALCULA O QUADRADO DE UM NÚMERO
CREATE OR REPLACE PROCEDURE sp_quadrado(p_num IN NUMBER := 0)
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE(p_num * p_num); -- EXIBE O RESULTADO
END sp_quadrado;
/

-- PROCEDURE PARA REAJUSTE SALARIAL DE FUNCIONÁRIO
CREATE OR REPLACE PROCEDURE sp_reajuste(
    p_codigo_emp IN emp.empno%type, 
    p_porcentagem IN NUMBER DEFAULT 25) -- PARÂMETRO OPCIONAL COM VALOR PADRÃO 25%
IS
BEGIN
    UPDATE emp
    SET sal = sal + (sal * (p_porcentagem/100)) -- CALCULA NOVO SALÁRIO
    WHERE empno = p_codigo_emp;
    COMMIT; -- CONFIRMA ALTERAÇÃO
END sp_reajuste;
/

-- PROCEDURE COM PARÂMETROS DE SAÍDA (OUT) PARA CONSULTA DE FUNCIONÁRIO
CREATE OR REPLACE PROCEDURE sp_consulta_emp(
    p_id IN emp.empno%type, 
    p_nome OUT emp.ename%TYPE, -- PARÂMETRO DE SAÍDA: NOME
    p_salario OUT emp.sal%TYPE) -- PARÂMETRO DE SAÍDA: SALÁRIO
IS
BEGIN
    SELECT ename, sal 
    INTO p_nome, p_salario -- ARMAZENA RESULTADOS NOS PARÂMETROS DE SAÍDA
    FROM emp
    WHERE empno = p_id;
END sp_consulta_emp;
/

-- PROCEDURE PARA CADASTRAR HOSPEDAGEM (REGRA DE NEGÓCIO COMPLETA)
CREATE OR REPLACE PROCEDURE sp_cadastrar_hospedagem(
    p_cd_cliente INTEGER, 
    p_cd_quarto INTEGER)
AS 
    v_total INTEGER; -- VARIÁVEL PARA VERIFICAÇÃO
BEGIN
    -- VERIFICA SE QUARTO ESTÁ DISPONÍVEL (STATUS 'ATIVO')
    SELECT COUNT(cd_quarto)
    INTO v_total
    FROM tb_quarto
    WHERE fg_quarto_situacao = 'Ativo'
    AND cd_quarto = p_cd_quarto;
    
    -- SE QUARTO DISPONÍVEL, REALIZA HOSPEDAGEM
    IF (v_total = 1) THEN
        -- INSERE REGISTRO NA TABELA DE HOSPEDAGEM (USA SEQUENCE PARA CHAVE PRIMÁRIA)
        INSERT INTO tb_hospedagem(cd_hospedagem, cd_cliente, dt_hospedagem_inicio, cd_quarto)
        VALUES (sq_hospedagem.nextval, p_cd_cliente, SYSDATE, p_cd_quarto);
        
        -- ATUALIZA STATUS DO QUARTO PARA 'OCUPADO'
        UPDATE tb_quarto 
        SET fg_quarto_situacao = 'Ocupado'
        WHERE cd_quarto = p_cd_quarto;
        
        COMMIT; -- CONFIRMA TRANSAÇÃO
    ELSE
        -- SE QUARTO INDISPONÍVEL, RETORNA ERRO PERSONALIZADO
        raise_application_error(-20001, 'Quarto não liberado');
    END IF;
END;
/
