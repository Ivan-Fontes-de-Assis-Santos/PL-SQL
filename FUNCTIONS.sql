-- FUNÇÕES DE AGREGAÇÃO E STRING
-- MAX, MIN, AVG, SUM - Funções de agregação padrão do SQL
SELECT MAX(sal) -- Retorna o maior salário da tabela emp
FROM emp;

-- SUBSTR - Função de string que extrai parte de uma string
-- Parâmetros: (string, posição_inicial, número_de_caracteres)
SELECT SUBSTR('ABCDE',1,3) -- Retorna 'ABC' (3 caracteres a partir da posição 1)
FROM DUAL; -- Tabela virtual do Oracle para consultas que não precisam de tabelas reais

-- Inserindo dados usando SUBSTR
INSERT INTO DEPT
VALUES(80, SUBSTR('ABCDE',1,3),'RS'); -- Insere departamento com código 80, nome 'ABC' e localização 'RS'

-- FUNÇÕES PERSONALIZADAS
-- Sintaxe básica:
-- CREATE OR REPLACE FUNCTION fn_nome_função
-- (parametro IN tipo_parametro, ...)
-- RETURN tipo_do_retorno
-- IS ou AS
--   declaração_de_variáveis
-- BEGIN
--   corpo_da_função
-- END;

-- Função para descobrir salário de um empregado pelo ID
CREATE OR REPLACE FUNCTION fn_descobrir_salario
    (p_id IN emp.empno%TYPE) -- Parâmetro de entrada: ID do empregado
RETURN NUMBER -- Tipo de retorno: NUMBER (salário)
IS
    v_salario emp.sal%TYPE := 0; -- Variável local para armazenar o salário, inicializada com 0
BEGIN
    -- Consulta para obter o salário do empregado com o ID especificado
    SELECT sal
    INTO v_salario -- Armazena o resultado na variável v_salario
    FROM emp
    WHERE empno= p_id; -- Filtra pelo ID do empregado
    RETURN v_salario; -- Retorna o salário encontrado
END fn_descobrir_salario;
/

-- Exemplo de uso: Lista todos os empregados com seus respectivos salários usando a função personalizada
SELECT empno, fn_descobrir_salario(empno) AS salario
FROM emp;

-- Função para contar o número total de departamentos
CREATE OR REPLACE FUNCTION fn_contadept
RETURN NUMBER IS -- Função sem parâmetros que retorna NUMBER
    total NUMBER(7) := 0; -- Variável para armazenar o total de departamentos
BEGIN
    -- Conta o número total de departamentos na tabela dept
    SELECT COUNT(*)
    INTO total -- Armazena o resultado na variável total
    FROM dept;
    RETURN total; -- Retorna o total de departamentos
END;
/

-- Bloco anônimo para demonstrar o uso da função fn_contadept com output
SET SERVEROUTPUT ON -- Habilita a exibição de mensagens no console
DECLARE
    v_conta NUMBER(7); -- Variável para receber o retorno da função
BEGIN
    v_conta := fn_contadept(); -- Chama a função (note os parênteses vazios)
    -- Exibe o resultado formatado
    DBMS_OUTPUT.PUT_LINE('Quantidade de Departamentos: ' || v_conta);
END;
/

-- Função para calcular salário anual considerando salário e comissão
CREATE OR REPLACE FUNCTION fn_sal_anual
(p_sal NUMBER, p_comm NUMBER) -- Parâmetros: salário mensal e comissão
RETURN NUMBER -- Retorna o salário anual
IS
BEGIN
    -- Cálculo: (salário + comissão(tratando NULL como 0)) × 12 meses
    RETURN(p_sal + NVL(p_comm,0))*12;
    -- NVL trata valores NULL, convertendo para 0 quando necessário
END;
/

-- Exemplo de uso: Calcula o salário anual com salário 10000 e comissão NULL (tratada como 0)
SELECT fn_sal_anual(10000, null) AS salario_anual
FROM dual;
