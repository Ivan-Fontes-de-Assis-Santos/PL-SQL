-- =============================================
-- PACOTES (PACKAGES) EM PL/SQL
-- =============================================
-- Packages são estruturas que agrupam procedures, funções, variáveis e constantes
-- para melhor organização, segurança e desempenho do código.

-- Vantagens:
-- 1. Organização: Agrupa funcionalidades relacionadas
-- 2. Encapsulamento: Esconde a implementação dos usuários
-- 3. Desempenho: Todo o pacote é carregado na memória de uma vez
-- 4. Segurança: Controle de acesso através de grants

-- Estrutura de um Package:
-- 1. ESPECIFICAÇÃO (SPECIFICATION): Interface pública - o que o pacote faz
-- 2. CORPO (BODY): Implementação - como o pacote faz

-- =============================================
-- EXEMPLO 1: PACOTE SIMPLES COM CONSTANTES
-- =============================================

-- Criação da especificação do pacote pkg_faculdade
CREATE OR REPLACE PACKAGE pkg_faculdade
AS
    -- Declaração de constantes públicas
    CNOME CONSTANT VARCHAR2(4):='FIAP';          -- Nome da faculdade
    CFONE CONSTANT VARCHAR2(13):='(11)3385-8010';-- Telefone da faculdade  
    CNOTA CONSTANT VARCHAR2(2):=10;              -- Nota da faculdade
END pkg_faculdade;
/

-- =============================================
-- EXEMPLO DE USO DO PACOTE pkg_faculdade
-- =============================================

-- Habilita a exibição de mensagens no console
SET SERVEROUTPUT ON

-- Bloco anônimo para demonstrar o uso do pacote
DECLARE
    melhor VARCHAR2(30);  -- Variável para armazenar mensagem
BEGIN
    -- Concatena o nome da faculdade com uma mensagem
    melhor := pkg_faculdade.CNOME || ', a melhor faculdade';
    
    -- Exibe a mensagem no console
    DBMS_OUTPUT.PUT_LINE(melhor);
END;
/

-- =============================================
-- EXEMPLO 2: PACOTE COM FUNÇÃO E PROCEDURE
-- =============================================

-- Criação da especificação do pacote pkg_rh
-- Define a interface pública (o que o pacote faz)
CREATE OR REPLACE PACKAGE pkg_rh
AS
    -- Declaração da função pública
    FUNCTION fn_descobrir_salario(p_id IN emp.empno%TYPE) RETURN NUMBER;
    
    -- Declaração do procedimento público
    -- NOTA: Há um erro de digitação no parâmetro (p_codido_emp vs p_codigo_emp)
    PROCEDURE sp_reajuste(p_codido_emp IN emp.empno%TYPE, p_porcentagem IN NUMBER DEFAULT 25);
END pkg_rh;
/

-- =============================================
-- CORPO DO PACOTE pkg_rh (IMPLEMENTAÇÃO)
-- =============================================

-- Criação do corpo do pacote pkg_rh
-- Define a implementação (como o pacote faz)
CREATE OR REPLACE PACKAGE BODY pkg_rh AS

    -- Implementação da função fn_descobrir_salario
    FUNCTION fn_descobrir_salario(p_id IN emp.empno%TYPE)
    RETURN NUMBER IS
        v_salario emp.sal%TYPE := 0;  -- Variável para armazenar o salário
    BEGIN
        -- Consulta o salário do funcionário pelo ID
        SELECT sal
        INTO v_salario
        FROM emp
        WHERE empno = p_id;
        
        -- Retorna o salário encontrado
        RETURN v_salario;
        
    EXCEPTION
        -- Tratamento de exceção para quando nenhum dado é encontrado
        WHEN NO_DATA_FOUND THEN
            RETURN 0;  -- Retorna 0 se o funcionário não existir
    END fn_descobrir_salario;
 
    -- Implementação do procedimento sp_reajuste
    -- NOTA: Há inconsistência no nome do parâmetro (p_codigo_emp vs p_codido_emp da especificação)
    -- NOTA: Há inconsistência no valor default (20 vs 25 da especificação)
    PROCEDURE sp_reajuste(p_codigo_emp IN emp.empno%TYPE, p_porcentagem IN NUMBER DEFAULT 20) IS
    BEGIN
        -- Atualiza o salário do funcionário com o reajuste percentual
        UPDATE emp
        SET sal = sal + (sal * (p_porcentagem/100))
        WHERE empno = p_codigo_emp;
        
        -- Confirma a transação
        COMMIT;
    END sp_reajuste;
    
END pkg_rh;
/

-- =============================================
-- EXEMPLO DE USO DO PACOTE pkg_rh
-- =============================================

-- Habilita a exibição de mensagens no console
SET SERVEROUTPUT ON

-- Bloco anônimo para testar a função do pacote
DECLARE
    v_sal NUMBER(8,2);  -- Variável para armazenar o salário
BEGIN
    -- Chama a função para descobrir o salário do funcionário com ID 7900
    v_sal := pkg_rh.fn_descobrir_salario(7900);
    
    -- Exibe o salário no console
    DBMS_OUTPUT.PUT_LINE('Salário do funcionário 7900: ' || v_sal);
END;
/

-- =============================================
-- CORREÇÕES NECESSÁRIAS NO CÓDIGO
-- =============================================

-- 1. CORRIGIR a inconsistência de nomes de parâmetros:
--    Na especificação: p_codido_emp → No corpo: p_codigo_emp
--
-- 2. CORRIGIR a inconsistência de valores default:
--    Na especificação: DEFAULT 25 → No corpo: DEFAULT 20
--
-- 3. ADICIONAR tratamento de exceções na função fn_descobrir_salario
--    (já adicionado no código acima)

-- =============================================
-- VERSÃO CORRIGIDA DA ESPECIFICAÇÃO
-- =============================================

CREATE OR REPLACE PACKAGE pkg_rh
AS
    FUNCTION fn_descobrir_salario(p_id IN emp.empno%TYPE) RETURN NUMBER;
    PROCEDURE sp_reajuste(p_codigo_emp IN emp.empno%TYPE, p_porcentagem IN NUMBER DEFAULT 20);
END pkg_rh;
/

-- =============================================
-- COMO USAR OS PACOTES NO SQL
-- =============================================

-- Para usar uma função de pacote em consulta SQL:
-- SELECT pkg_rh.fn_descobrir_salario(empno) as salario, ename
-- FROM emp;

-- Para executar um procedimento de pacote:
-- BEGIN
--    pkg_rh.sp_reajuste(7900, 15); -- Reajuste de 15% para o empregado 7900
-- END;
-- /

-- =============================================
-- BOAS PRÁTICAS NO USO DE PACOTES
-- =============================================

-- 1. Manter consistência entre especificação e corpo
-- 2. Usar nomes significativos para procedures e funções  
-- 3. Documentar os parâmetros e funcionalidades
-- 4. Implementar tratamento de exceções adequado
-- 5. Usar constantes para valores fixos
-- 6. Manter o acoplamento baixo entre pacotes
