## Database Structure and Questions

### Project Overview

This project involves managing bank operations and loans. The database schema describes the entities involved in the banking system, including branches, agencies, clients, accounts, operations, and loans.

### Database Structure

The database is divided into two parts:

**Part 1: Relational-Object (SQL3)**

This part focuses on modeling the database using an object-oriented approach and implementing SQL queries to retrieve and manipulate data.

**Part 2: NoSQL (MongoDB)**

This part focuses on modeling the database using a document-oriented approach and implementing MongoDB queries to retrieve and manipulate data.


## Database Schema

### Entity Descriptions

**Succursale (Branch)**

* **NumSucc (Branch Number):** Unique identifier for the branch
* **nomSucc (Branch Name):** Name of the branch
* **adresseSucc (Branch Address):** Address of the branch
* **région (Region):** Region where the branch is located (Nord, Sud, Est, Ouest)

**Agence (Agency)**

* **NumAgence (Agency Number):** Unique identifier for the agency
* **nomAgence (Agency Name):** Name of the agency
* **adresseAgence (Agency Address):** Address of the agency
* **catégorie (Category):** Category of the agency (Principale or Secondaire)
* **NumSucc* (Branch Number):** Foreign key referencing the NumSucc of the associated branch

**Client (Customer)**

* **NumClient (Customer Number):** Unique identifier for the customer
* **NomClient (Customer Name):** Name of the customer
* **TypeClient (Customer Type):** Type of customer (Particulier or Entreprise)
* **AdresseClient (Customer Address):** Address of the customer
* **NumTel (Phone Number):** Phone number of the customer
* **Email (Email Address):** Email address of the customer

**Compte (Account)**

* **NumCompte (Account Number):** Unique identifier for the account
* **dateOuverture (Opening Date):** Date the account was opened
* **étatCompte (Account Status):** Status of the account (Actif or Bloqué)
* **Solde (Balance):** Current balance of the account
* **NumClient* (Customer Number):** Foreign key referencing the NumClient of the associated customer
* **NumAgence* (Agency Number):** Foreign key referencing the NumAgence of the associated agency

**Opération (Operation)**

* **NumOpération (Operation Number):** Unique identifier for the operation
* **NatureOp (Operation Type):** Type of operation (Crédit or Débit)
* **montantOp (Operation Amount):** Amount of the operation
* **DateOp (Operation Date):** Date the operation was performed
* **Observation (Observation):** Additional notes or observations about the operation
* **NumCompte* (Account Number):** Foreign key referencing the NumCompte of the associated account

**Prêt (Loan)**

* **NumPrêt (Loan Number):** Unique identifier for the loan
* **montantPrêt (Loan Amount):** Total amount of the loan
* **dateEffet (Effective Date):** Date the loan took effect
* **durée (Duration):** Duration of the loan in months
* **typePrêt (Loan Type):** Type of loan (Véhicule, Immobilier, ANSEJ, ANJEM)
* **tauxIntérêt (Interest Rate):** Interest rate of the loan
* **montantEchéance (Monthly Payment Amount):** Amount of the monthly payment
* **NumCompte* (Account Number):** Foreign key referencing the NumCompte of the associated account

### Data Type Specifications

* **Date:** Date format (e.g., YYYY-MM-DD)
* **Num:** Integer
* **String:** Text

### Additional Notes

* The `*` symbol indicates a foreign key relationship.
* The `région`, `catégorie`, `étatCompte`, `typePrêt`, and `NatureOp` attributes have predefined values.
* The `TauxInterêt`, `montantPrêt`, `montantEchéance`, `montantOp`, and `Solde` attributes are real numbers.

## Entity Relationships

* A branch can have multiple agencies.
* An agency belongs to one branch.
* A customer can have multiple accounts.
* An account belongs to one customer.
* An account can have multiple operations.
* An operation belongs to one account.
* A customer can have multiple loans.
* A loan belongs to one customer.
* An account can have one loan.
* A loan is associated with one account.

## Database Design Considerations

* The database schema is normalized to reduce data redundancy and improve data integrity.
* Foreign keys are used to enforce referential integrity between entities.
* Data types are chosen appropriately to represent the data accurately.

### Questions

**Part 1: Relational-Object (SQL3)**

1. **Create an object-oriented class diagram (UML) based on the provided relational schema.**

2. **Create two tablespaces: SQL3_TBS and SQL3_TempTBS.**

3. **Create an SQL3 user and assign it the two tablespaces created in step 2.**

4. **Grant all privileges to the SQL3 user created in step 3.**

5. **Define all necessary abstract types and associations based on the object-oriented class diagram created in step 1.**

6. **Implement methods to perform the following tasks:**
   - Calculate the number of loans issued for each agency.
   - Calculate the number of primary agencies for each branch.
   - Calculate the total loan amount for a given agency (specified by number) between 01-01-2020 and 01-01-2024.
   - List all secondary agencies (along with their corresponding branch) that have at least one "ANSEJ" loan.

7. **Define the necessary tables for the database.**

8. **Populate all tables with data:**
   - 6 branches
   - 25 agencies distributed among the branches
   - 100 clients, 40 of whom have taken loans from different agencies in different branches
   - A significant number of debit/credit operations on different accounts
   - Ensure attribute constraints are respected
   - Assign meaningful and realistic values to attributes
   - Number branches 001, 002, ..., and agencies 101, 102, 103, ...
   - Account numbers should be 10 digits long and start with the agency number (e.g., 1180005564)
   - Client numbers should be 5 digits long

9. **Write SQL queries to perform the following tasks:**
   - List all accounts for a given agency whose owners are businesses.
   - List loans issued by agencies belonging to a specific branch (numSuccursale = 005). Include NumPrêt, NumAgence, numCompte, and MontantPrêt.
   - Identify accounts on which no debit operations were performed between 2000 and 2022.
   - Determine the total credit amount for a specific account (numCompte = 1180005564) in 2023.
   - List all outstanding loans (NumPrêt, NumAgence, numCompte, numClient, and MontantPrêt).
   - Identify the account with the most transactions (debit/credit) in 2023.

**Part 2: NoSQL (MongoDB)**

**A. Document-Oriented Modeling**

1. **Propose a document-oriented data model for the database, considering that most queries will focus on loans.**

2. **Illustrate the document-oriented model using an example from the generated database.**

3. **Justify the design choices made for the document-oriented model.**

4. **Discuss any potential drawbacks of the chosen document-oriented model.**

**B. Populating the Database**

1. **Populate the MongoDB database using a script and additional data to increase the database volume.**

**C. Querying the Database**

1. **Write MongoDB queries to perform the following tasks:**



1. **Retrieve all loans issued by agency 102.**

2. **Retrieve all loans issued by agencies in the "Nord" region branches. Include NumPrêt, NumAgence, numCompte, numClient, and MontantPrêt.**

3. **Create a new collection "Agence-NbPrêts" containing agency numbers and the total number of loans per agency. Order the collection by the number of loans in descending order. Display the collection's contents.**

4. **Create a new collection "Prêt-ANSEJ" containing all loans related to ANSEJ cases. Include NumPrêt, numClient, MontantPrêt, and dateEffet.**

5. **Retrieve all loans taken out by "Particulier" (individual) clients. Display NumClient, NomClient, NumPrêt, montantPrêt.**

6. **Increase the amount of the outstanding balance by 2000DA for all outstanding loans with an effective date before January 2021.**

7. **Replicate the 3rd query using the Map-Reduce paradigm.**

8. **Determine whether the current design can fulfill the following query: Display all credit operations performed on the accounts of "Entreprise" (business) clients during the year 2023. Justify your answer.**
