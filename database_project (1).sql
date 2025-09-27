CREATE TABLE Bank (
    bank_id VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    headquarters VARCHAR(100),
    established_date DATE
);

CREATE TABLE Agency (
    agency_id VARCHAR(20) PRIMARY KEY,
    bank_id VARCHAR(20),
    name VARCHAR(100) NOT NULL,
    address VARCHAR(200),
    city VARCHAR(50),
    phone NUMBER(8,0),
    CONSTRAINT fk_agency_bank FOREIGN KEY (bank_id) REFERENCES Bank(bank_id)
);

CREATE TABLE Position (
    position_id VARCHAR(20) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(200),
    min_salary NUMBER(10, 2),
    max_salary NUMBER(10, 2),
    CHECK (min_salary >= 0),
    CHECK (max_salary >= min_salary)
);

CREATE TABLE Employee (
    employee_id VARCHAR(20) PRIMARY KEY,
    agency_id VARCHAR(20) NOT NULL,
    position_id VARCHAR(20) NOT NULL,
    cin NUMBER(8,0) NOT NULL,
    name VARCHAR(100) NOT NULL,
    hire_date DATE NOT NULL,
    salary NUMBER(10, 2) NOT NULL,
    employment_type VARCHAR(50),
    CONSTRAINT fk_employee_agency FOREIGN KEY (agency_id) REFERENCES Agency(agency_id),
    CONSTRAINT fk_employee_position FOREIGN KEY (position_id) REFERENCES Position(position_id),
    CHECK (salary >= 0)
);

CREATE TABLE Employee_Training (
    training_id VARCHAR(20) PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description VARCHAR(4000)
);

CREATE TABLE Employee_Training_Assignment (
    training_assignment_id VARCHAR(20) PRIMARY KEY,
    employee_id VARCHAR(20) NOT NULL,
    training_id VARCHAR(20) NOT NULL,
    CONSTRAINT fk_assignment_employee FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    CONSTRAINT fk_assignment_training FOREIGN KEY (training_id) REFERENCES Employee_Training(training_id)
);

CREATE TABLE Employee_Evaluation (
    evaluation_id VARCHAR(20) PRIMARY KEY,
    employee_id VARCHAR(20) NOT NULL,
    review_date DATE NOT NULL,
    score NUMBER(3,0),
    comments VARCHAR(4000),
    CONSTRAINT fk_evaluation_employee FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    CHECK (score >= 0 AND score <= 100)
);

CREATE TABLE Employee_Supervision (
    supervision_id VARCHAR(20) PRIMARY KEY,
    supervisor_id VARCHAR(20) NOT NULL,
    subordinate_id VARCHAR(20) NOT NULL,
    CONSTRAINT fk_supervision_supervisor FOREIGN KEY (supervisor_id) REFERENCES Employee(employee_id),
    CONSTRAINT fk_supervision_subordinate FOREIGN KEY (subordinate_id) REFERENCES Employee(employee_id),
    CHECK (supervisor_id != subordinate_id)
);

CREATE TABLE Customer (
    customer_id VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    cin NUMBER(8,0) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone NUMBER(8,0),
    address VARCHAR(200),
    dob DATE,
    CHECK (email LIKE '%@%.%')
);

CREATE TABLE Account (
    account_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    account_type VARCHAR(50) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    last_login TIMESTAMP,
    balance NUMBER(15, 2) NOT NULL,
    open_date DATE NOT NULL,
    CONSTRAINT fk_account_customer FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    CHECK (balance >= 0)
);

CREATE TABLE Transaction (
    transaction_id VARCHAR(20) PRIMARY KEY,
    account_id VARCHAR(20) NOT NULL,
    transaction_type VARCHAR(50) NOT NULL,
    amount NUMBER(15, 2) NOT NULL,
    transaction_date TIMESTAMP NOT NULL,
    CONSTRAINT fk_transaction_account FOREIGN KEY (account_id) REFERENCES Account(account_id),
    CHECK (amount > 0)
);

CREATE TABLE Loan (
    loan_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    amount NUMBER(15, 2) NOT NULL,
    interest_rate NUMBER(5, 2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    CONSTRAINT fk_loan_customer FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    CHECK (amount > 0),
    CHECK (interest_rate > 0),
    CHECK (end_date > start_date)
);

CREATE TABLE Loan_Payment (
    payment_id VARCHAR(20) PRIMARY KEY,
    loan_id VARCHAR(20) NOT NULL,
    payment_date DATE NOT NULL,
    amount_paid NUMBER(15, 2) NOT NULL,
    CONSTRAINT fk_payment_loan FOREIGN KEY (loan_id) REFERENCES Loan(loan_id),
    CHECK (amount_paid > 0)
);

CREATE TABLE Credit_Card (
    card_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    card_number VARCHAR(16) NOT NULL UNIQUE,
    expiry_date DATE NOT NULL,
    cvv CHAR(3) NOT NULL,
    credit_limit NUMBER(15, 2) NOT NULL,
    CONSTRAINT fk_card_customer FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    CHECK (credit_limit > 0),
    CHECK (LENGTH(cvv) = 3)
);

CREATE TABLE Card_Transaction (
    card_tx_id VARCHAR(20) PRIMARY KEY,
    card_id VARCHAR(20) NOT NULL,
    merchant_name VARCHAR(100) NOT NULL,
    amount NUMBER(15, 2) NOT NULL,
    tx_date TIMESTAMP NOT NULL,
    CONSTRAINT fk_card_transaction FOREIGN KEY (card_id) REFERENCES Credit_Card(card_id),
    CHECK (amount > 0)
);

CREATE TABLE Currency (
    currency_code CHAR(3) PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE Exchange_Rate (
    rate_id VARCHAR(20) PRIMARY KEY,
    from_currency CHAR(3) NOT NULL,
    to_currency CHAR(3) NOT NULL,
    rate NUMBER(10, 4) NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    CONSTRAINT fk_rate_from_currency FOREIGN KEY (from_currency) REFERENCES Currency(currency_code),
    CONSTRAINT fk_rate_to_currency FOREIGN KEY (to_currency) REFERENCES Currency(currency_code),
    CHECK (rate > 0)
);

CREATE TABLE Support_Ticket (
    ticket_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    subject VARCHAR(100) NOT NULL,
    status VARCHAR(50) NOT NULL,
    open_date DATE NOT NULL,
    close_date DATE,
    CONSTRAINT fk_ticket_customer FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE Audit_Log (
    log_id VARCHAR(20) PRIMARY KEY,
    employee_id VARCHAR(20) NOT NULL,
    action VARCHAR(100) NOT NULL,
    action_date TIMESTAMP NOT NULL,
    details VARCHAR(4000),
    CONSTRAINT fk_auditlog_employee FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);

INSERT INTO Bank (bank_id, name, headquarters, established_date) VALUES ('BANK001', 'Banque Nationale de Tunisie', 'Tunis', TO_DATE('1958-01-01', 'YYYY-MM-DD'));
INSERT INTO Bank (bank_id, name, headquarters, established_date) VALUES ('BANK002', 'Société Tunisienne de Banque', 'Tunis', TO_DATE('1960-03-20', 'YYYY-MM-DD'));
INSERT INTO Bank (bank_id, name, headquarters, established_date) VALUES ('BANK003', 'Banque de lHabitat', 'Tunis', TO_DATE('1974-07-01', 'YYYY-MM-DD'));


INSERT INTO Agency (agency_id, bank_id, name, address, city, phone) VALUES ('AGENCY001', 'BANK001', 'BNT - Centre Ville', '10 Avenue Habib Bourguiba', 'Tunis', 71000001);
INSERT INTO Agency (agency_id, bank_id, name, address, city, phone) VALUES ('AGENCY002', 'BANK001', 'BNT - El Menzah', 'Cite El Menzah VI', 'Tunis', 71696969);
INSERT INTO Agency (agency_id, bank_id, name, address, city, phone) VALUES ('AGENCY003', 'BANK002', 'STB - Sfax', 'Rue Habib Bourguiba', 'Sfax', 74123123);


INSERT INTO Position (position_id, name, description, min_salary, max_salary) VALUES ('POS001', 'Cashier', 'Handles customer transactions', 800.00, 1200.00);
INSERT INTO Position (position_id, name, description, min_salary, max_salary) VALUES ('POS002', 'Loan Officer', 'Processes loan applications', 1500.00, 2500.00);
INSERT INTO Position (position_id, name, description, min_salary, max_salary) VALUES ('POS003', 'Branch Manager', 'Manages branch operations', 2000.00, 3500.00);


INSERT INTO Employee (employee_id, agency_id, position_id, cin, name, hire_date, salary, employment_type) VALUES ('EMP001', 'AGENCY001', 'POS001', 12345678, 'Rayen Abid', TO_DATE('2020-03-15', 'YYYY-MM-DD'), 1000.00, 'Full-time');
INSERT INTO Employee (employee_id, agency_id, position_id, cin, name, hire_date, salary, employment_type) VALUES ('EMP002', 'AGENCY002', 'POS002', 21212121, 'ahmed Mohamed', TO_DATE('2018-08-01', 'YYYY-MM-DD'), 2000.00, 'Full-time');
INSERT INTO Employee (employee_id, agency_id, position_id, cin, name, hire_date, salary, employment_type) VALUES ('EMP003', 'AGENCY003', 'POS003', 34567890, 'ilef Ibrahim', TO_DATE('2022-01-10', 'YYYY-MM-DD'), 3000.00, 'Part-time');


INSERT INTO Employee_Training (training_id, title, description) VALUES ('TRAIN001', 'Cashier Training', 'Basic cashier procedures');
INSERT INTO Employee_Training (training_id, title, description) VALUES ('TRAIN002', 'Loan Processing', 'Processing loan applications');
INSERT INTO Employee_Training (training_id, title, description) VALUES ('TRAIN003', 'Management Skills', 'Management and leadership');


INSERT INTO Employee_Training_Assignment (training_assignment_id, employee_id, training_id) VALUES ('TRAINASSIGN001', 'EMP001', 'TRAIN001');
INSERT INTO Employee_Training_Assignment (training_assignment_id, employee_id, training_id) VALUES ('TRAINASSIGN002', 'EMP002', 'TRAIN002');
INSERT INTO Employee_Training_Assignment (training_assignment_id, employee_id, training_id) VALUES ('TRAINASSIGN003', 'EMP003', 'TRAIN003');


INSERT INTO Employee_Evaluation (evaluation_id, employee_id, review_date, score, comments) VALUES ('EVAL001', 'EMP001', TO_DATE('2024-03-15', 'YYYY-MM-DD'), 90, 'Excellent performance');
INSERT INTO Employee_Evaluation (evaluation_id, employee_id, review_date, score, comments) VALUES ('EVAL002', 'EMP002', TO_DATE('2024-03-15', 'YYYY-MM-DD'), 80, 'Good performance');
INSERT INTO Employee_Evaluation (evaluation_id, employee_id, review_date, score, comments) VALUES ('EVAL003', 'EMP003', TO_DATE('2024-03-15', 'YYYY-MM-DD'), 70, 'Satisfactory performance');


INSERT INTO Employee_Supervision (supervision_id, supervisor_id, subordinate_id) VALUES ('SUPER001', 'EMP003', 'EMP001');
INSERT INTO Employee_Supervision (supervision_id, supervisor_id, subordinate_id) VALUES ('SUPER002', 'EMP003', 'EMP002');
INSERT INTO Employee_Supervision (supervision_id, supervisor_id, subordinate_id) VALUES ('SUPER003', 'EMP002', 'EMP001');


INSERT INTO Customer (customer_id, name, cin, email, phone, address, dob) VALUES ('CUST001', 'Ali weld', 12345678, 'ali2005@gmail.com', 50505050, '10 Rue de la Liberté, Tunis', TO_DATE('1980-07-22', 'YYYY-MM-DD'));
INSERT INTO Customer (customer_id, name, cin, email, phone, address, dob) VALUES ('CUST002', 'Salah Mohamed', 98765432, 'salouha.mohamed@gmail.com', 90909090, '45 Rue Habib Bourguiba, Sfax', TO_DATE('1995-02-10', 'YYYY-MM-DD'));
INSERT INTO Customer (customer_id, name, cin, email, phone, address, dob) VALUES ('CUST003', 'Amine Aymen', 76543210, 'amine8.aymen@yahoo.com', 90909090, '789 Avenue de Carthage, Tunis', TO_DATE('1990-12-05', 'YYYY-MM-DD'));


INSERT INTO Account (account_id, customer_id, account_type, username, password_hash, last_login, balance, open_date) VALUES ('ACC001', 'CUST001', 'Checking', 'ali123', 'hashed_password_1', TO_TIMESTAMP('2024-04-20 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 20.2, TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO Account (account_id, customer_id, account_type, username, password_hash, last_login, balance, open_date) VALUES ('ACC002', 'CUST002', 'Savings', 'salah123', 'hashed_password_2', TO_TIMESTAMP('2024-04-15 14:30:00', 'YYYY-MM-DD HH24:MI:SS'), 50000.00, TO_DATE('2025-02-01', 'YYYY-MM-DD'));
INSERT INTO Account (account_id, customer_id, account_type, username, password_hash, last_login, balance, open_date) VALUES ('ACC003', 'CUST003', 'Checking', 'amine123', 'hashed_password_3', TO_TIMESTAMP('2024-04-22 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 500.00, TO_DATE('2020-03-01', 'YYYY-MM-DD'));


INSERT INTO Transaction (transaction_id, account_id, transaction_type, amount, transaction_date) VALUES ('TX001', 'ACC001', 'Deposit', 100.00, TO_TIMESTAMP('2024-04-20 10:15:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Transaction (transaction_id, account_id, transaction_type, amount, transaction_date) VALUES ('TX002', 'ACC001', 'Withdrawal', 50.00, TO_TIMESTAMP('2024-04-20 11:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Transaction (transaction_id, account_id, transaction_type, amount, transaction_date) VALUES ('TX003', 'ACC002', 'Deposit', 200.00, TO_TIMESTAMP('2024-04-15 15:00:00', 'YYYY-MM-DD HH24:MI:SS'));


INSERT INTO Loan (loan_id, customer_id, amount, interest_rate, start_date, end_date) VALUES ('LOAN001', 'CUST001', 10000.00, 7.00, TO_DATE('2024-01-15', 'YYYY-MM-DD'), TO_DATE('2026-01-15', 'YYYY-MM-DD'));
INSERT INTO Loan (loan_id, customer_id, amount, interest_rate, start_date, end_date) VALUES ('LOAN002', 'CUST002', 5000.00, 8.00, TO_DATE('2024-02-10', 'YYYY-MM-DD'), TO_DATE('2025-02-10', 'YYYY-MM-DD'));
INSERT INTO Loan (loan_id, customer_id, amount, interest_rate, start_date, end_date) VALUES ('LOAN003', 'CUST003', 8000.00, 7.50, TO_DATE('2024-03-01', 'YYYY-MM-DD'), TO_DATE('2026-03-01', 'YYYY-MM-DD'));


INSERT INTO Loan_Payment (payment_id, loan_id, payment_date, amount_paid) VALUES ('LP001', 'LOAN001', TO_DATE('2024-02-15', 'YYYY-MM-DD'), 500.00);
INSERT INTO Loan_Payment (payment_id, loan_id, payment_date, amount_paid) VALUES ('LP002', 'LOAN001', TO_DATE('2024-03-15', 'YYYY-MM-DD'), 500.00);
INSERT INTO Loan_Payment (payment_id, loan_id, payment_date, amount_paid) VALUES ('LP003', 'LOAN002', TO_DATE('2024-03-10', 'YYYY-MM-DD'), 250.00);


INSERT INTO Credit_Card (card_id, customer_id, card_number, expiry_date, cvv, credit_limit) VALUES ('CARD001', 'CUST001', '1234567890123456', TO_DATE('2029-12-31', 'YYYY-MM-DD'), '123', 10000.00);
INSERT INTO Credit_Card (card_id, customer_id, card_number, expiry_date, cvv, credit_limit) VALUES ('CARD002', 'CUST002', '9876543210987654', TO_DATE('2028-11-30', 'YYYY-MM-DD'), '456', 5000.00);
INSERT INTO Credit_Card (card_id, customer_id, card_number, expiry_date, cvv, credit_limit) VALUES ('CARD003', 'CUST003', '2345678901234567', TO_DATE('2030-01-31', 'YYYY-MM-DD'), '789', 8000.00);


INSERT INTO Card_Transaction (card_tx_id, card_id, merchant_name, amount, tx_date) VALUES ('CT001', 'CARD001', 'Magasin Aziza', 75.00, TO_TIMESTAMP('2024-04-20 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Card_Transaction (card_tx_id, card_id, merchant_name, amount, tx_date) VALUES ('CT002', 'CARD001', 'Carrefour', 100.00, TO_TIMESTAMP('2024-04-20 13:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Card_Transaction (card_tx_id, card_id, merchant_name, amount, tx_date) VALUES ('CT003', 'CARD002', 'Souk El-Henna', 50.00, TO_TIMESTAMP('2024-04-15 16:00:00', 'YYYY-MM-DD HH24:MI:SS'));


INSERT INTO Currency (currency_code, name) VALUES ('TND', 'Tunisian Dinar');
INSERT INTO Currency (currency_code, name) VALUES ('EUR', 'Euro');
INSERT INTO Currency (currency_code, name) VALUES ('USD', 'American Dollar');


INSERT INTO Exchange_Rate (rate_id, from_currency, to_currency, rate, updated_at) VALUES ('ER001', 'TND', 'EUR', 0.30, TO_TIMESTAMP('2024-04-24 08:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Exchange_Rate (rate_id, from_currency, to_currency, rate, updated_at) VALUES ('ER002', 'TND', 'USD', 0.32, TO_TIMESTAMP('2024-04-24 09:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Exchange_Rate (rate_id, from_currency, to_currency, rate, updated_at) VALUES ('ER003', 'EUR', 'TND', 3.30, TO_TIMESTAMP('2024-04-24 10:00:00', 'YYYY-MM-DD HH24:MI:SS'));


INSERT INTO Support_Ticket (ticket_id, customer_id, subject, status, open_date, close_date) VALUES ('ST001', 'CUST001', 'Account Access Issue', 'Open', TO_DATE('2024-04-20', 'YYYY-MM-DD'), NULL);
INSERT INTO Support_Ticket (ticket_id, customer_id, subject, status, open_date, close_date) VALUES ('ST002', 'CUST002', 'Loan Application Status', 'Closed', TO_DATE('2024-04-15', 'YYYY-MM-DD'), TO_DATE('2024-04-18', 'YYYY-MM-DD'));
INSERT INTO Support_Ticket (ticket_id, customer_id, subject, status, open_date, close_date) VALUES ('ST003', 'CUST003', 'Credit Card Inquiry', 'Open', TO_DATE('2024-04-22', 'YYYY-MM-DD'), NULL);


INSERT INTO Audit_Log (log_id, employee_id, action, action_date, details) VALUES ('AL001', 'EMP001', 'Login', TO_TIMESTAMP('2024-04-20 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'User logged in successfully');
INSERT INTO Audit_Log (log_id, employee_id, action, action_date, details) VALUES ('AL002', 'EMP002', 'Update Customer Info', TO_TIMESTAMP('2024-04-15 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Updated address for customer CUST002');
INSERT INTO Audit_Log (log_id, employee_id, action, action_date, details) VALUES ('AL003', 'EMP003', 'Create Loan', TO_TIMESTAMP('2024-04-22 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Created loan LOAN003 for customer CUST003');
