SET SERVEROUTPUT ON
--ULTILIZANDO O %ROWTYPE NÃO PRECISA DECLARAR TODAS AS COLUNAS E SUAS VARIAVEIS--+
DECLARE 
    emprec emp%ROWTYPE;
BEGIN
    SELECT *
    INTO emprec
    FROM emp
    WHERE empno = 7369;
    DBMS_OUTPUT.PUT_LINE ('Código = ' || emprec.empno);
    DBMS_OUTPUT.PUT_LINE ('Nome = ' || emprec.ename);
    DBMS_OUTPUT.PUT_LINE ('Cargo = ' || emprec.job);
    DBMS_OUTPUT.PUT_LINE ('Gerente = ' || emprec.mgr);
    DBMS_OUTPUT.PUT_LINE ('Data = ' || emprec.hiredate);
    DBMS_OUTPUT.PUT_LINE ('Sala = ' || emprec.sal);
    DBMS_OUTPUT.PUT_LINE ('Comissao = ' || emprec.comm);
    DBMS_OUTPUT.PUT_LINE ('Depart. = ' || emprec.deptno);
END;
/
