CREATE OR REPLACE TYPE Succursale_Type;
/
CREATE OR REPLACE TYPE Agence_Type AS OBJECT (
    NumAgence INT,
    NomAgence VARCHAR2(100),
    AdresseAgence VARCHAR2(255),
    Categorie VARCHAR2(50),
    NumSucc ref Succursale_Type,
    MAP MEMBER FUNCTION get_map RETURN VARCHAR2,
    member FUNCTION total_amount_of_loans_for_agency(
    agency_id IN INT,
    start_date IN DATE,
    end_date IN DATE
) RETURN NUMBER
);
/

CREATE or replace TYPE tset_ref_agence AS TABLE OF REF Agence_Type;
/

CREATE OR REPLACE TYPE Succursale_Type AS OBJECT (
    NumSucc INT,
    NomSucc VARCHAR2(100),
    AdresseSucc VARCHAR2(255),
    Region VARCHAR2(50),
    agences tset_ref_agence,
    MEMBER FUNCTION count_main_agencies RETURN NUMBER

);
/

CREATE OR REPLACE TYPE Client_Type AS OBJECT (
    NumClient INT,
    NomClient VARCHAR2(100),
    TypeClient VARCHAR2(50),
    AdresseClient VARCHAR2(255),
    NumTel VARCHAR2(20),
    Email VARCHAR2(100)
);
/

CREATE OR REPLACE TYPE Compte_Type;
/

CREATE OR REPLACE TYPE Operation_Type AS OBJECT (
    NumOperation INT,
    NatureOp VARCHAR2(20),
    MontantOp NUMBER(10, 2),
    DateOp DATE,
    Observation VARCHAR2(255),
    NumCompte REF Compte_Type
);
/

CREATE OR REPLACE TYPE Pret_Type AS OBJECT (
    NumPret INT,
    MontantPret NUMBER(10, 2),
    DateEffet DATE,
    Duree INT,
    TypePret VARCHAR2(50),
    TauxInteret NUMBER(5, 2),
    MontantEcheance NUMBER(10, 2),
    NumCompte REF Compte_Type,
    MEMBER FUNCTION agences_Secondary_ANSEJ RETURN NUMBER
);
/

Create type tset_ref_pret as table of ref Pret_Type;
/
Create or REPLACE type tset_ref_operation as table of ref Operation_Type;
/

CREATE OR REPLACE TYPE Compte_Type AS OBJECT (
    NumCompte INT,
    DateOuverture DATE,
    EtatCompte VARCHAR2(20),
    Solde NUMBER(10, 2),
    NumClient REF Client_Type,
    NumAgence REF Agence_Type,
    Operations tset_ref_operation,
    Prets tset_ref_pret,
    STATIC FUNCTION number_of_loans_for_each_agency RETURN NUMBER
); 
/






-- ////////////////////////////////////////////////////////////////////////////////////////////////////

CREATE OR REPLACE TYPE BODY Agence_Type AS
    MAP MEMBER FUNCTION get_map RETURN VARCHAR2 IS
    BEGIN
        RETURN NumAgence;
    END get_map;

    MEMBER FUNCTION total_amount_of_loans_for_agency(
    agency_id IN INT,
    start_date IN DATE,
    end_date IN DATE
  ) RETURN NUMBER IS
    total_amount NUMBER := 0;

     CURSOR  p_prets IS
      SELECT p.MontantPret
      FROM Prets p
      where deref(deref(p.NumCompte).NumAgence).NumAgence = agency_id
      AND  p.DateEffet >= start_date AND p.DateEffet <= end_date;


  BEGIN
    FOR pret_rec IN p_prets LOOP
      total_amount := total_amount + pret_rec.MontantPret;
    END LOOP;
    RETURN total_amount;
  END total_amount_of_loans_for_agency;
END;
/
show errors;



SET SERVEROUTPUT ON;

DECLARE
  agence Agence_Type;
  total_amount NUMBER;
BEGIN
  SELECT VALUE(a)
  INTO agence
  FROM Agences a
  WHERE a.NumAgence = 101; 

  total_amount := agence.total_amount_of_loans_for_agency(101, TO_DATE('2022-01-01', 'YYYY-MM-DD'), TO_DATE('2022-12-31', 'YYYY-MM-DD'));
  DBMS_OUTPUT.PUT_LINE('Total amount of loans: ' || total_amount);
END;
/




CREATE OR REPLACE TYPE BODY Pret_Type AS
  MEMBER FUNCTION agences_Secondary_ANSEJ RETURN NUMBER IS
    total_amount NUMBER := 0;
    agence_name VARCHAR2(100);
    toto VARCHAR2(100); 
    toto2 VARCHAR2(100); 
    CURSOR c_agences_secondary_ansej IS
      SELECT DEREF(DEREF(p.NumCompte).NumAgence).NumAgence
      FROM Prets p
      WHERE p.TypePret = 'ANSEJ'
        AND DEREF(DEREF(p.NumCompte).NumAgence).Categorie = 'Secondary';
  BEGIN
    OPEN c_agences_secondary_ansej;
    LOOP
      FETCH c_agences_secondary_ansej INTO agence_name;
      EXIT WHEN c_agences_secondary_ansej%NOTFOUND;
      -- Process the agence_name value here
      SELECT a.NomAgence INTO toto FROM Agences a WHERE a.NUMAGENCE = TO_NUMBER(agence_name); -- Assuming NUMAGENCE is of type NUMBER
      SELECT DEREF(a.NumSucc).NomSucc INTO toto2 FROM Agences a WHERE a.NUMAGENCE = TO_NUMBER(agence_name); -- Assuming NUMAGENCE is of type NUMBER
      DBMS_OUTPUT.PUT_LINE('Agency: ' || toto || ' | Succursale' ||toto2);
      total_amount := total_amount + 1;
    END LOOP;
    CLOSE c_agences_secondary_ansej;
    RETURN total_amount;
  END agences_Secondary_ANSEJ;
END;
/



DECLARE
  result NUMBER;
  pret_instance Pret_Type;
BEGIN
  SELECT VALUE(a)
  INTO pret_instance
  FROM Prets a
  WHERE a.NumPret = 1;

  result := pret_instance.agences_Secondary_ANSEJ();
END;
/






CREATE OR REPLACE TYPE BODY Compte_Type AS
   STATIC FUNCTION number_of_loans_for_each_agency RETURN NUMBER IS
        CURSOR agency_cursor IS
            SELECT DISTINCT DEREF(NumAgence) AS agency
            FROM Comptes;
        loan_count NUMBER := 0;
        total_loan_count NUMBER := 0;
    BEGIN
        FOR agency_rec IN agency_cursor LOOP
            SELECT COUNT(*) INTO loan_count
            FROM (
                SELECT c.Prets
                FROM Comptes c
                WHERE DEREF(c.NumAgence) = agency_rec.agency
            ) compte_prets,
            TABLE(compte_prets.Prets) p;
            
            DBMS_OUTPUT.PUT_LINE('Number of loans for agency ' || agency_rec.agency.NomAgence || ': ' || loan_count);
            total_loan_count := total_loan_count + loan_count;
        END LOOP;
        
        RETURN total_loan_count;
    END number_of_loans_for_each_agency;

END;
/
show errors











SET SERVEROUTPUT ON;

DECLARE
    total_loans NUMBER;
BEGIN
    total_loans := Compte_Type.number_of_loans_for_each_agency();
    DBMS_OUTPUT.PUT_LINE('Total number of loans for all agencies: ' || total_loans);
END;
/













DECLARE
    total_loans NUMBER;
BEGIN
    total_loans := Compte_Type.number_of_loans_for_each_agency();
    DBMS_OUTPUT.PUT_LINE('Total number of loans across all agencies: ' || total_loans);
END;
/



CREATE OR REPLACE TYPE BODY Succursale_Type AS
    MEMBER FUNCTION count_main_agencies RETURN NUMBER IS
        main_agency_count NUMBER := 0;
        agence Agence_Type;
    BEGIN
        FOR i IN 1..self.agences.COUNT LOOP
            agence := get_agence(self.agences(i));
            IF agence.Categorie  = 'Primary' THEN
                main_agency_count := main_agency_count + 1;
            END IF;
        END LOOP;
        
        RETURN main_agency_count;
    END count_main_agencies;
END;
/



SELECT s.count_main_agencies() 
FROM Succursale s;




-- ////////////////////////////////////////////////////////////////////////////////////////////////////

CREATE TABLE Agences OF Agence_Type(
    CONSTRAINT pk_agences PRIMARY KEY(NumAgence),
    CONSTRAINT check_categorie CHECK (Categorie IN ('Primary', 'Secondary'))
);

CREATE TABLE Succursale OF Succursale_Type(
    CONSTRAINT pk_succursales PRIMARY KEY(NumSucc),
    CONSTRAINT check_region CHECK (Region IN ('North', 'South', 'East', 'West'))
) nested TABLE agences STORE AS table_agences;

CREATE TABLE Clients OF Client_Type(
    CONSTRAINT pk_clients PRIMARY KEY(NumClient),
    CONSTRAINT check_type_client CHECK (TypeClient IN ('Individual', 'Business'))
);

CREATE TABLE Operations OF Operation_Type(
    CONSTRAINT pk_operations PRIMARY KEY(NumOperation),
    CONSTRAINT check_nature_op CHECK (NatureOp IN ('Credit', 'Debit'))
); 

CREATE TABLE Prets OF Pret_Type(
    CONSTRAINT pk_prets PRIMARY KEY(NumPret),
    CONSTRAINT check_type_pret CHECK (TypePret IN ('Vehicle', 'Real Estate', 'ANSEJ', 'ANJEM'))
);

CREATE TABLE Comptes OF Compte_Type(
    CONSTRAINT pk_comptes PRIMARY KEY(NumCompte),
    CONSTRAINT check_etat_compte CHECK (EtatCompte IN ('Active', 'Blocked'))
) nested TABLE Operations STORE AS table_operations,
  nested TABLE Prets STORE AS table_prets;


-- ////////////////////////////////////////////////////////////////////////////////////////////////////



BEGIN
    FOR i IN 1..6 LOOP
        INSERT INTO Succursale VALUES (
            i, 
            'Succursale ' || TO_CHAR(i, 'FM009'), 
            'Address ' || TO_CHAR(i, 'FM009'), 
            CASE MOD(i, 4)
                WHEN 0 THEN 'North'
                WHEN 1 THEN 'South'
                WHEN 2 THEN 'East'
                ELSE 'West'
            END, 
            tset_ref_agence()
        );
    END LOOP;
    COMMIT;
END;
/



-- ////////////////////////////////////////////////////////////////////////////////////////////////////


DELETE FROM Clients;
DELETE FROM Agences;
DELETE FROM Comptes;
delete from Operations;
delete from Prets;

-- ////////////////////////////////////////////////////////////////////////////////////////////////////


BEGIN
    FOR i IN 10001..10100 LOOP
        -- Insert a new Client
        INSERT INTO Clients
        VALUES (i, 'Client ' || TO_CHAR(i - 10000, 'FM0099'), 
                CASE MOD(i, 2) WHEN 0 THEN 'Business' ELSE 'Individual' END, 
                'Address ' || TO_CHAR(i - 10000, 'FM0099'), 
                '1234567890', 'client' || TO_CHAR(i - 10000, 'FM0099') || '@example.com');
    END LOOP;

    COMMIT;
END;
/








-- Insert data into Agences table

DELETE FROM Agences;



DECLARE
    v_agence_ref REF Agence_Type;
BEGIN
    FOR i IN 101..125 LOOP
        -- Insert a new Agence
        INSERT INTO Agences
        VALUES (i, 'Agence ' || TO_CHAR(i, 'FM009'), 'Address ' || TO_CHAR(i, 'FM009'), 
                CASE MOD(i, 2) WHEN 0 THEN 'Primary' ELSE 'Secondary' END, 
                (SELECT REF(s) FROM Succursale s WHERE NumSucc = MOD(i, 6) + 1));

        -- Get a reference to the new Agence
        SELECT REF(a) INTO v_agence_ref FROM Agences a WHERE a.NumAgence = i;

        -- Update the Succursale table
        UPDATE Succursale s
        SET VALUE(s) = Succursale_Type(s.NumSucc, s.NomSucc, s.AdresseSucc, s.Region, s.agences MULTISET UNION tset_ref_agence(v_agence_ref))
        WHERE s.NumSucc = MOD(i, 6) + 1;
    END LOOP;

    COMMIT;
END;
/




-- Insert data into Comptes table
DELETE FROM Comptes;


BEGIN
    FOR i IN 0..99 LOOP
        -- Insert a new Account
        INSERT INTO Comptes
        VALUES (TO_NUMBER(TO_CHAR(101 + MOD(i, 25), 'FM009') || TO_CHAR(1000000 + i, 'FM0999999')), 
                TO_DATE('2022-01-01', 'YYYY-MM-DD'), 
                CASE WHEN i < 40 THEN 'Active' ELSE CASE MOD(i, 2) WHEN 0 THEN 'Active' ELSE 'Blocked' END END, 
                TRUNC(DBMS_RANDOM.VALUE(50, 10000)), 
                (SELECT REF(c) FROM Clients c WHERE c.NumClient = 10001 + i), 
                (SELECT REF(a) FROM Agences a WHERE a.NumAgence = 101 + MOD(i, 25)), 
                tset_ref_operation(), 
                tset_ref_pret());
    END LOOP;

    COMMIT;
END;
/



-- Insert data into Operations table



DECLARE
    TYPE op_types IS TABLE OF VARCHAR2(20) INDEX BY PLS_INTEGER;
    v_op_types op_types;
    v_num_compte Comptes.NumCompte%TYPE;
BEGIN
    v_op_types(1) := 'Credit';
    v_op_types(2) := 'Debit';

    FOR i IN 1..200 LOOP
        -- Select a random account
        SELECT NumCompte INTO v_num_compte FROM (SELECT NumCompte FROM Comptes ORDER BY DBMS_RANDOM.VALUE) WHERE ROWNUM = 1;

        -- Insert a new Operation
        INSERT INTO Operations
        VALUES (i, 
                v_op_types(TRUNC(DBMS_RANDOM.VALUE(1, 2))), 
                TRUNC(DBMS_RANDOM.VALUE(50, 10000)), 
                TO_DATE('2022-01-03', 'YYYY-MM-DD'), 
                'Observation ' || i, 
                (SELECT REF(c) FROM Comptes c WHERE NumCompte = v_num_compte));

        -- Update the Comptes table
        UPDATE Comptes c 
        SET c.Operations = tset_ref_operation((SELECT REF(o) FROM Operations o WHERE NumOperation = i)) 
        WHERE NumCompte = v_num_compte;
    END LOOP;

    COMMIT;
END;
/


-- Insert data into Prets table



DECLARE
    TYPE pret_types IS TABLE OF VARCHAR2(20) INDEX BY PLS_INTEGER;
    v_pret_types pret_types;
    v_num_compte Comptes.NumCompte%TYPE;
BEGIN
    v_pret_types(1) := 'Vehicle';
    v_pret_types(2) := 'Real Estate';
    v_pret_types(3) := 'ANSEJ';
    v_pret_types(4) := 'ANJEM';

    FOR i IN 1..200 LOOP
        -- Select a random account from the first 40 accounts
        SELECT NumCompte INTO v_num_compte FROM (SELECT NumCompte FROM Comptes WHERE ROWNUM <= 40 ORDER BY DBMS_RANDOM.VALUE) WHERE ROWNUM = 1;

        -- Insert a new Pret
        INSERT INTO Prets
        VALUES (i, 
                TRUNC(DBMS_RANDOM.VALUE(50, 10000)), 
                TO_DATE('2022-01-03', 'YYYY-MM-DD'), 
                TRUNC(DBMS_RANDOM.VALUE(1, 12)), 
                v_pret_types(TRUNC(DBMS_RANDOM.VALUE(1, 4))), 
                TRUNC(DBMS_RANDOM.VALUE(3, 99)), 
                TRUNC(DBMS_RANDOM.VALUE(100, 500)), 
                (SELECT REF(c) FROM Comptes c WHERE NumCompte = v_num_compte));

        -- Update the Comptes table
        UPDATE Comptes c 
        SET c.Prets = tset_ref_pret((SELECT REF(p) FROM Prets p WHERE NumPret = i)) 
        WHERE NumCompte = v_num_compte;
    END LOOP;

    COMMIT;
END;
/


-- ////////////////////////////////////////////////////////////////////////////////////////////////////


-- Data base interogation

SELECT c.NumCompte, c.DateOuverture, c.EtatCompte, c.Solde
FROM Comptes c
WHERE DEREF(c.NumClient).TypeClient = 'Business'
AND DEREF(c.NumAgence).NumAgence = :given_agency_id;




SELECT DEREF(p.COLUMN_VALUE).NumPret, DEREF(c.NumAgence).NumAgence AS NumAgence, c.NumCompte, DEREF(p.COLUMN_VALUE).MontantPret
FROM Comptes c, TABLE(c.Prets) p
WHERE DEREF(c.NumAgence).NumSucc.NumSucc = 1;


SELECT c.NumCompte
FROM Comptes c
WHERE NOT EXISTS (
    SELECT 1
    FROM TABLE(c.Operations) o
    WHERE o.COLUMN_VALUE.NatureOp = 'Debit' -- Assuming NatureOp is the column for transaction type
    AND o.COLUMN_VALUE.DateOp BETWEEN TO_DATE('2000-01-01', 'YYYY-MM-DD') AND TO_DATE('2022-12-31', 'YYYY-MM-DD')
);



SELECT SUM(o.COLUMN_VALUE.MontantOp) as TOTAL
FROM Comptes c, TABLE(c.Operations) o
WHERE c.NumCompte = 1161000040
  AND o.COLUMN_VALUE.NatureOp = 'Credit'
  AND o.COLUMN_VALUE.DateOp BETWEEN TO_DATE('2020-01-01', 'YYYY-MM-DD') AND TO_DATE('2026-12-31', 'YYYY-MM-DD');




SELECT p.COLUMN_VALUE.NumPret,
       DEREF(c.NumAgence).NumAgence AS NumAgence,
       c.NumCompte,
       DEREF(c.NumClient).NumClient AS NumClient,
       p.COLUMN_VALUE.MontantPret
FROM Comptes c, TABLE(c.Prets) p
WHERE ADD_MONTHS(p.COLUMN_VALUE.DateEffet, p.COLUMN_VALUE.Duree) > SYSDATE;


SELECT c.NumCompte, COUNT(*) AS TotalOperations
FROM Comptes c, TABLE(c.Operations) o
WHERE o.COLUMN_VALUE.DateOp BETWEEN TO_DATE('2020-01-01', 'YYYY-MM-DD') AND TO_DATE('2025-12-31', 'YYYY-MM-DD')
GROUP BY c.NumCompte
ORDER BY TotalOperations DESC
FETCH FIRST 1 ROW ONLY;