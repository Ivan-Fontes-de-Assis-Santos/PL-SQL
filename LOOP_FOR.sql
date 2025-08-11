-- EXEMPLO DE LOOPS DE CURSOR FOR --

-- SINTAXE PADRÃO DO FOR:
-- FOR nome_registo IN nome_cursor LOOP
-- Instruções;
--END LOOP;

SET SERVEROUTPUT ON
DECLARE
    CURSOR cursor_emp IS
    SELECT deptno, SUM(sal) soma
    FROM emp
    GROUP BY deptno;
BEGIN
    FOR emprec IN cursor_emp LOOP
        DBMS_OUTPUT.PUT_LINE ('Departamento: ' || emprec.deptno);
        DBMS_OUTPUT.PUT_LINE ('Salario: ' || emprec.soma);
    END LOOP;
END ;
/
