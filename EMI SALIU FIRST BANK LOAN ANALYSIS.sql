create database first_bank_data_loan;
use first_bank_data_loan;
CREATE TABLE loan_applicationss (
    Loan_ID VARCHAR(20),
    Gender VARCHAR(10),
    Married VARCHAR(5),
    Dependents VARCHAR(5),
    Education VARCHAR(20),
    Self_Employed VARCHAR(5),
    ApplicantIncome INT,
    CoapplicantIncome DECIMAL(10,2),
    LoanAmount DECIMAL(10,2),
    Loan_Amount_Term DECIMAL(10,2),
    Credit_History DECIMAL(3,1),
    Property_Area VARCHAR(15),
    Loan_Status VARCHAR(5);
    USE first_bank_loans;
SELECT * FROM loan_applicationss
LIMIT 10;
    SELECT 
    Loan_Status,
    COUNT(*) AS total,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM loan_applicationss), 2) AS percentage
FROM loan_applicationss
GROUP BY Loan_Status;
SELECT 
    Credit_History,
    Loan_Status,
    COUNT(*) AS total
FROM loan_applicationss
GROUP BY Credit_History, Loan_Status
ORDER BY Credit_History, Loan_Status;
SELECT 
    Gender,
    Loan_Status,
    COUNT(*) AS total
FROM loan_applicationss
WHERE Gender IS NOT NULL
GROUP BY Gender, Loan_Status
ORDER BY Gender, Loan_Status;
SELECT Self_Employed, Loan_Status, COUNT(*) AS total
FROM loan_applicationss
WHERE Self_Employed IS NOT NULL
GROUP BY Self_Employed, Loan_Status
ORDER BY Self_Employed, Loan_Status;
SELECT Property_Area, Loan_Status, COUNT(*) AS total
FROM loan_applicationss
WHERE Property_Area IS NOT NULL
GROUP BY Property_Area, Loan_Status
ORDER BY Property_Area, Loan_Status;
SELECT 
    Loan_Status,
    ROUND(AVG(ApplicantIncome), 2) AS avg_income,
    ROUND(AVG(CoapplicantIncome), 2) AS avg_coapplicant_income,
    ROUND(AVG(LoanAmount), 2) AS avg_loan_amount,
    ROUND(AVG(Loan_Amount_Term), 2) AS avg_loan_term
FROM loan_applicationss
WHERE Loan_Status IS NOT NULL
GROUP BY Loan_Status;
SELECT 
    Loan_ID,
    Gender,
    ApplicantIncome,
    LoanAmount,
    Credit_History,
    Self_Employed,
    CoapplicantIncome,
    Loan_Status,
    CASE
        WHEN Credit_History = 0 THEN 'HIGH RISK — Bad Credit'
        WHEN LoanAmount > (SELECT AVG(LoanAmount) FROM loan_applicationss) THEN 'HIGH RISK — High Loan'
        WHEN Self_Employed = 'Yes' THEN 'HIGH RISK — Self Employed'
        WHEN CoapplicantIncome = 0 THEN 'HIGH RISK — No Coapplicant'
        ELSE 'NORMAL'
    END AS Risk_Flag
FROM loan_applicationss
WHERE Loan_Status IS NOT NULL
ORDER BY Risk_Flag;
SELECT 
    Risk_Flag,
    Loan_Status,
    COUNT(*) AS total
FROM (
    SELECT 
        Loan_Status,
        CASE
            WHEN Credit_History = 0 THEN 'HIGH RISK'
            WHEN LoanAmount > (SELECT AVG(LoanAmount) FROM loan_applicationss) THEN 'HIGH RISK'
            WHEN Self_Employed = 'Yes' THEN 'HIGH RISK'
            WHEN CoapplicantIncome = 0 THEN 'HIGH RISK'
            ELSE 'NORMAL'
        END AS Risk_Flag
    FROM loan_applicationss
    WHERE Loan_Status IS NOT NULL
) AS risk_table
GROUP BY Risk_Flag, Loan_Status
ORDER BY Risk_Flag, Loan_Status;