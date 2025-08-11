-- EXEMPLOS DE CURSORES EXPLICITOS -- 

DECLARE
    CURSOR cursor_emp IS
    SELECT deptno, SUM(sal)
    FROM emp
    GROUP BY deptno;
BEGIN
    OPEN cursor_emp;
END;
/

DECLARE
    emprec emp%ROWTYPE;
    CURSOR cursor_emp IS
    SELECT deptno, SUM(sal)
    FROM emp
    GROUP BY deptno;
BEGIN
    OPEN  cursor_emp;
    -- FETCH PEGA APENAS O PRIMEIRO REGISTRO DA COLUNA DEPTNO --
    FETCH cursor_emp
    INTO emprec.deptno, emprec.sal;
    DBMS_OUTPUT.PUT_LINE('Departamento: ' || emprec.deptno);
    DBMS_OUTPUT.PUT_LINE('Salario: ' || emprec.sal);
END;
/


DECLARE
    emprec emp%ROWTYPE;
    CURSOR cursor_emp IS
    SELECT deptno, SUM(sal)
    FROM emp
    GROUP BY deptno;
BEGIN
    OPEN  cursor_emp;
    -- FETCH PEGA APENAS O PRIMEIRO REGISTRO DA COLUNA DEPTNO E PARA PEGAR TODOS OS DEPTNO É ULTILIZADO O LOOP PARA REPETIR OS REGISTROS ATÉ VIR TODOS --
    LOOP
        FETCH cursor_emp
        INTO emprec.deptno, emprec.sal;
        -- VALIDA SE O CURSOR NÃO ESTÁ VAZIO --
        EXIT WHEN cursor_emp%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Departamento: ' || emprec.deptno);
        DBMS_OUTPUT.PUT_LINE('Salario: ' || emprec.sal);
    END LOOP;
END;
/

-- EXEMPLO DE BOAS PRATICAS PARA FECHAMENTO DE CURSORES --
DECLARE
    emprec emp%ROWTYPE;
    CURSOR cursor_emp IS
    SELECT deptno, SUM(sal)
    FROM emp
    GROUP BY deptno;
BEGIN
    OPEN  cursor_emp;
    -- FETCH PEGA APENAS O PRIMEIRO REGISTRO DA COLUNA DEPTNO E PARA PEGAR TODOS OS DEPTNO É ULTILIZADO O LOOP PARA REPETIR OS REGISTROS ATÉ VIR TODOS --
    LOOP
        FETCH cursor_emp
        INTO emprec.deptno, emprec.sal;
        -- VALIDA SE O CURSOR NÃO ESTÁ VAZIO --
        EXIT WHEN cursor_emp%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Departamento: ' || emprec.deptno);
        DBMS_OUTPUT.PUT_LINE('Salario: ' || emprec.sal);
    END LOOP;
    CLOSE cursor_emp;
END;
/
