-- ACCOUNTS TABLE: Stores bank account information and balances
-- Use this table for queries about: account numbers, account types, balances, account status, customer accounts, interest rates
CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,                  -- Unique identifier for each account
    account_number VARCHAR(20) UNIQUE NOT NULL,     -- Unique account number
    account_type VARCHAR(50) NOT NULL,              -- Type (savings, checking, business)
    customer_name VARCHAR(255) NOT NULL,            -- Account holder name
    customer_email VARCHAR(255),                    -- Customer email address
    balance DECIMAL(15, 2) DEFAULT 0.00,            -- Current account balance
    currency VARCHAR(3) DEFAULT 'USD',              -- Currency code (USD, EUR, etc.)
    status VARCHAR(20) DEFAULT 'active',            -- Account status (active, closed, suspended)
    opened_date DATE NOT NULL,                      -- Date account was opened
    closed_date DATE,                               -- Date account was closed (NULL if active)
    interest_rate DECIMAL(5, 2),                    -- Annual interest rate percentage
    credit_limit DECIMAL(15, 2),                    -- Credit limit for overdraft protection
    branch_code VARCHAR(20)                         -- Branch where account was opened
);

-- TRANSACTIONS TABLE: Stores financial transactions and account activity
-- Use this table for queries about: transaction amounts, transaction dates, transaction types, merchant names, account activity
CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,              -- Unique identifier for each transaction
    account_id INTEGER REFERENCES accounts(account_id), -- Account for this transaction
    transaction_type VARCHAR(50) NOT NULL,          -- Type (deposit, withdrawal, transfer, purchase)
    amount DECIMAL(15, 2) NOT NULL,                 -- Transaction amount
    balance_after DECIMAL(15, 2),                   -- Account balance after transaction
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- When transaction occurred
    description TEXT,                               -- Transaction description
    reference_number VARCHAR(100) UNIQUE,           -- Unique transaction reference
    status VARCHAR(20) DEFAULT 'completed',         -- Status (completed, pending, failed)
    merchant_name VARCHAR(255),                     -- Merchant/payee name
    category VARCHAR(100)                           -- Transaction category (groceries, dining, income, etc.)
);

-- LOANS TABLE: Stores loan information and repayment details
-- Use this table for queries about: loan amounts, interest rates, loan types, outstanding balances, loan status, monthly payments
CREATE TABLE loans (
    loan_id SERIAL PRIMARY KEY,                     -- Unique identifier for each loan
    account_id INTEGER REFERENCES accounts(account_id), -- Account holder's account
    loan_type VARCHAR(50) NOT NULL,                 -- Type (personal, mortgage, auto, business)
    principal_amount DECIMAL(15, 2) NOT NULL,       -- Original loan amount
    interest_rate DECIMAL(5, 2) NOT NULL,           -- Annual interest rate percentage
    term_months INTEGER NOT NULL,                   -- Loan term in months
    monthly_payment DECIMAL(10, 2),                 -- Monthly payment amount
    outstanding_balance DECIMAL(15, 2),             -- Remaining balance to be paid
    start_date DATE NOT NULL,                       -- Loan start date
    end_date DATE,                                  -- Loan maturity/end date
    status VARCHAR(20) DEFAULT 'active',            -- Status (active, paid_off, defaulted)
    purpose TEXT                                    -- Loan purpose description
);

-- LOAN_PAYMENTS TABLE: Stores individual loan payment records
-- Use this table for queries about: payment history, principal paid, interest paid, payment dates, payment status
CREATE TABLE loan_payments (
    payment_id SERIAL PRIMARY KEY,                  -- Unique identifier for each payment
    loan_id INTEGER REFERENCES loans(loan_id),      -- Loan this payment applies to
    payment_date DATE NOT NULL,                     -- Date payment was made
    payment_amount DECIMAL(10, 2) NOT NULL,         -- Total payment amount
    principal_paid DECIMAL(10, 2),                  -- Amount applied to principal
    interest_paid DECIMAL(10, 2),                   -- Amount applied to interest
    remaining_balance DECIMAL(15, 2),               -- Loan balance after this payment
    payment_status VARCHAR(20) DEFAULT 'completed'  -- Status (completed, pending, failed)
);

-- INVESTMENTS TABLE: Stores investment portfolio information
-- Use this table for queries about: investment types, asset names, purchase prices, current values, investment returns
CREATE TABLE investments (
    investment_id SERIAL PRIMARY KEY,               -- Unique identifier for each investment
    account_id INTEGER REFERENCES accounts(account_id), -- Account holding the investment
    investment_type VARCHAR(50) NOT NULL,           -- Type (stocks, bonds, mutual_fund, etf)
    asset_name VARCHAR(255) NOT NULL,               -- Name of asset/security
    quantity DECIMAL(15, 4),                        -- Number of shares/units held
    purchase_price DECIMAL(12, 2),                  -- Price per unit at purchase
    current_price DECIMAL(12, 2),                   -- Current market price per unit
    purchase_date DATE NOT NULL,                    -- Date of purchase
    maturity_date DATE,                             -- Maturity date (for bonds)
    status VARCHAR(20) DEFAULT 'active'             -- Status (active, sold, matured)
);

-- CREDIT_CARDS TABLE: Stores credit card information and limits
-- Use this table for queries about: credit limits, available credit, card types, rewards points, card status
CREATE TABLE credit_cards (
    card_id SERIAL PRIMARY KEY,                     -- Unique identifier for each card
    account_id INTEGER REFERENCES accounts(account_id), -- Linked account
    card_number VARCHAR(19) UNIQUE NOT NULL,        -- Card number (masked for security)
    card_type VARCHAR(50) NOT NULL,                 -- Type (platinum, gold, standard)
    credit_limit DECIMAL(12, 2) NOT NULL,           -- Maximum credit limit
    available_credit DECIMAL(12, 2),                -- Currently available credit
    interest_rate DECIMAL(5, 2),                    -- Annual percentage rate (APR)
    issue_date DATE NOT NULL,                       -- Date card was issued
    expiry_date DATE NOT NULL,                      -- Card expiration date
    status VARCHAR(20) DEFAULT 'active',            -- Status (active, blocked, expired)
    rewards_points INTEGER DEFAULT 0                -- Accumulated rewards points
);

-- BENEFICIARIES TABLE: Stores beneficiary information for transfers and inheritance
-- Use this table for queries about: beneficiary names, accounts, relationships, transfer recipients
CREATE TABLE beneficiaries (
    beneficiary_id SERIAL PRIMARY KEY,              -- Unique identifier for each beneficiary
    account_id INTEGER REFERENCES accounts(account_id), -- Account that added this beneficiary
    beneficiary_name VARCHAR(255) NOT NULL,         -- Beneficiary full name
    beneficiary_account VARCHAR(20) NOT NULL,       -- Beneficiary account number
    bank_name VARCHAR(255),                         -- Beneficiary's bank name
    relationship VARCHAR(100),                      -- Relationship to account holder
    added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- When beneficiary was added
);







CREATE INDEX idx_accounts_number ON accounts(account_number);
CREATE INDEX idx_transactions_account ON transactions(account_id);
CREATE INDEX idx_transactions_date ON transactions(transaction_date);
CREATE INDEX idx_loans_account ON loans(account_id);
CREATE INDEX idx_investments_account ON investments(account_id);
CREATE INDEX idx_credit_cards_account ON credit_cards(account_id);
