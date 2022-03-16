-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE account (
    account_id                   INTEGER NOT NULL,
    district_id                  INTEGER NOT NULL,
    frequency                    VARCHAR2(400) NOT NULL,
    DATE_CREATED                 VARCHAR2(100) NOT NULL
    
);

ALTER TABLE account ADD CONSTRAINT account_pk PRIMARY KEY ( account_id );

CREATE TABLE client (
    client_id                    INTEGER NOT NULL,
    birth_number                 VARCHAR2(100) NOT NULL,
    district_id INTEGER NOT NULL
);

ALTER TABLE client ADD CONSTRAINT client_pk PRIMARY KEY ( client_id );

CREATE TABLE credit_card (
    card_id             INTEGER NOT NULL,
    disp_id             INTEGER NOT NULL,
    type                VARCHAR2(100) NOT NULL,
    issued              VARCHAR2(200) NOT NULL
    
);

ALTER TABLE credit_card ADD CONSTRAINT credit_card_pk PRIMARY KEY ( card_id );

CREATE TABLE demographic_data (
    A1          INTEGER NOT NULL,
    A2          VARCHAR2(200) NOT NULL,
    A3          VARCHAR2(200) NOT NULL,
    A4          INTEGER NOT NULL,
    A5          INTEGER NOT NULL,
    A6          INTEGER NOT NULL,
    A7          INTEGER NOT NULL,
    A8          INTEGER NOT NULL,
    A9          INTEGER NOT NULL,
    A10         NUMBER NOT NULL,
    A11         NUMBER NOT NULL,
    A12         VARCHAR2(100) NOT NULL,
    A13         VARCHAR2(100) NOT NULL,
    A14         INTEGER NOT NULL,
    A15         INTEGER NOT NULL,
    A16         INTEGER NOT NULL
);

ALTER TABLE demographic_data ADD CONSTRAINT demographic_data_pk PRIMARY KEY ( district_id );

CREATE TABLE disposition (
    disp_id            INTEGER NOT NULL,
    client_id          INTEGER NOT NULL,
    account_id         INTEGER NOT NULL,
    type               VARCHAR2(100)
);

ALTER TABLE disposition ADD CONSTRAINT disposition_pk PRIMARY KEY ( disp_id );

CREATE TABLE loan (
    loan_id            INTEGER NOT NULL,
    account_id         INTEGER NOT NULL,
    "date"             VARCHAR2(10) NOT NULL,
    amount             INTEGER NOT NULL,
    duration           INTEGER NOT NULL,
    payments           NUMBER NOT NULL,
    status             CHAR(1)
);

ALTER TABLE loan ADD CONSTRAINT loan_pk PRIMARY KEY ( loan_id );

CREATE TABLE permanent_order (
    order_id           INTEGER NOT NULL,
    account_id         INTEGER NOT NULL,
    bank_to            CHAR(2) NOT NULL,
    account_to         VARCHAR2(100) NOT NULL,
    amount             NUMBER NOT NULL,
    k_symbol           VARCHAR2(40)
    
);

ALTER TABLE permanent_order ADD CONSTRAINT permanent_order_pk PRIMARY KEY ( order_id );

CREATE TABLE transaction (
    trans_id           VARCHAR2(100) NOT NULL,
    account_id         INTEGER NOT NULL,
    "date"             VARCHAR2(10) NOT NULL,
    type               VARCHAR2(30) NOT NULL,
    operation          VARCHAR2(40) NOT NULL,
    amount             NUMBER NOT NULL,
    balance            NUMBER NOT NULL,
    k_symbol           VARCHAR2(100),
    bank               CHAR(2),
    account            VARCHAR2(100) 
);

ALTER TABLE transaction ADD CONSTRAINT transaction_pk PRIMARY KEY ( trans_id );

ALTER TABLE account
    ADD CONSTRAINT account_demographic_data_fk FOREIGN KEY ( district_id )
        REFERENCES demographic_data ( district_id );

ALTER TABLE client
    ADD CONSTRAINT client_demographic_data_fk FOREIGN KEY ( district_id )
        REFERENCES demographic_data ( district_id );

ALTER TABLE credit_card
    ADD CONSTRAINT credit_card_disposition_fk FOREIGN KEY ( disp_id )
        REFERENCES disposition ( disp_id );

ALTER TABLE disposition
    ADD CONSTRAINT disposition_account_fk FOREIGN KEY ( account_id )
        REFERENCES account ( account_id );

ALTER TABLE disposition
    ADD CONSTRAINT disposition_client_fk FOREIGN KEY ( client_id )
        REFERENCES client ( client_id );

ALTER TABLE loan
    ADD CONSTRAINT loan_account_fk FOREIGN KEY ( account_id )
        REFERENCES account ( account_id );

ALTER TABLE permanent_order
    ADD CONSTRAINT permanent_order_account_fk FOREIGN KEY ( account_id )
        REFERENCES account ( account_id );

ALTER TABLE transaction
    ADD CONSTRAINT transaction_account_fk FOREIGN KEY ( account_id )
        REFERENCES account ( account_id );
        
ALTER TABLE DEMOGRAPHIC_DATA
MODIFY A10 FLOAT;
   
ALTER TABLE DEMOGRAPHIC_DATA
MODIFY A12 VARCHAR (100);
        
ALTER TABLE DEMOGRAPHIC_DATA
MODIFY A13 VARCHAR (100);

-------------------Staging area-------------------

CREATE TABLE sa_account (
    account_id                   INTEGER NOT NULL,
    district_id                  INTEGER NOT NULL,
    frequency                    VARCHAR2(400) NOT NULL,
    DATE_CREATED                 VARCHAR2(100) NOT NULL,
    loadData                     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

UPDATE SA_ACCOUNT
   SET FREQUENCY = REPLACE(FREQUENCY, 'POPLATEK MESICNE', 'MONTHLY');
UPDATE SA_ACCOUNT
   SET FREQUENCY = REPLACE(FREQUENCY, 'POPLATEK TYDNE', 'WEEKLY');
UPDATE SA_ACCOUNT
   SET FREQUENCY = REPLACE(FREQUENCY, 'POPLATEK PO OBRATU', 'AFTER');

CREATE TABLE sa_client (
    client_id                    INTEGER NOT NULL,
    birth_number                 VARCHAR2(100) NOT NULL,
    district_id                  INTEGER NOT NULL,
     loadData                    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);




CREATE TABLE sa_credit_card (
    card_id             INTEGER NOT NULL,
    disp_id             INTEGER NOT NULL,
    type                VARCHAR2(100) NOT NULL,
    issued              VARCHAR2(200) NOT NULL,
     loadData                     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    
);

CREATE TABLE sa_demographic_data (
    A1          INTEGER NOT NULL,
    A2          VARCHAR2(200) NOT NULL,
    A3          VARCHAR2(200) NOT NULL,
    A4          INTEGER NOT NULL,
    A5          INTEGER NOT NULL,
    A6          INTEGER NOT NULL,
    A7          INTEGER NOT NULL,
    A8          INTEGER NOT NULL,
    A9          INTEGER NOT NULL,
    A10         NUMBER NOT NULL,
    A11         NUMBER NOT NULL,
    A12         VARCHAR2(100) NOT NULL,
    A13         VARCHAR2(100) NOT NULL,
    A14         INTEGER NOT NULL,
    A15         INTEGER NOT NULL,
    A16         INTEGER NOT NULL,
    loadData                     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sa_disposition (
    disp_id            INTEGER NOT NULL,
    client_id          INTEGER NOT NULL,
    account_id         INTEGER NOT NULL,
    type               VARCHAR2(100),
    loadData                     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sa_loan (
    loan_id            INTEGER NOT NULL,
    account_id         INTEGER NOT NULL,
    "date"             INTEGER NOT NULL,
    amount             INTEGER NOT NULL,
    duration           INTEGER NOT NULL,
    payments           NUMBER NOT NULL,
    status             VARCHAR2(100),
    loadData                     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE SA_LOAN
ADD DAY INTEGER;
CREATE TABLE sa_permanent_order (
    order_id           INTEGER NOT NULL,
    account_id         INTEGER NOT NULL,
    bank_to            CHAR(2) NOT NULL,
    account_to         VARCHAR2(100) NOT NULL,
    amount             NUMBER NOT NULL,
    k_symbol           VARCHAR2(40),
    loadData                     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

UPDATE sa_permanent_order
   SET K_SYMBOL = REPLACE(K_SYMBOL, 'SIPO', 'HOUSEHOLD');
UPDATE sa_permanent_order
   SET K_SYMBOL = REPLACE(K_SYMBOL, 'UVER', 'LOAN_PAYMENT');
UPDATE sa_permanent_order
   SET K_SYMBOL = REPLACE(K_SYMBOL, 'LEASING', 'LEASING');
UPDATE sa_permanent_order
SET K_SYMBOL = REPLACE(K_SYMBOL, 'POJISTNE', 'INSURANCE_PAYMENT');
   
CREATE TABLE sa_transaction (
    trans_id           VARCHAR2(100) NOT NULL,
    account_id         INTEGER NOT NULL,
    "date"             VARCHAR2(10) NOT NULL,
    type               VARCHAR2(30) NOT NULL,
    operation          VARCHAR2(40) NOT NULL,
    amount             NUMBER NOT NULL,
    balance            NUMBER NOT NULL,
    k_symbol           VARCHAR2(100),
    bank               CHAR(2),
    account            VARCHAR2(100),
    loadData                     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

UPDATE sa_transaction
   SET TYPE = REPLACE(TYPE, 'PRIJEM', 'credit');
UPDATE sa_transaction
   SET TYPE = REPLACE(TYPE, 'VYDAJ', 'withdrawal');
   
UPDATE sa_transaction
SET OPERATION = REPLACE(OPERATION, 'VYBER KARTOU', 'credit card withdrawal');

UPDATE sa_transaction
SET OPERATION = REPLACE(OPERATION, 'VKLAD', 'credit in cash');

UPDATE sa_transaction
SET OPERATION = REPLACE(OPERATION, 'PREVOD Z UCTU', 'collection from another bank');

UPDATE sa_transaction
SET OPERATION = REPLACE(OPERATION, 'VYBER', 'withdrawal in cash');

UPDATE sa_transaction
SET OPERATION = REPLACE(OPERATION, 'PREVOD NA UCET', 'remittance to another bank');

UPDATE sa_transaction
SET K_SYMBOL = REPLACE(K_SYMBOL, 'POJISTNE', 'insurrance payment');

UPDATE sa_transaction
SET K_SYMBOL = REPLACE(K_SYMBOL, 'SLUZBY', 'payment for statement');

UPDATE sa_transaction
SET K_SYMBOL = REPLACE(K_SYMBOL, 'UROK', 'interest credited');

UPDATE sa_transaction
SET K_SYMBOL = REPLACE(K_SYMBOL, 'SANKC. UROK', 'sanction interest if negative balance');

UPDATE sa_transaction
SET K_SYMBOL = REPLACE(K_SYMBOL, 'SIPO', 'household');

UPDATE SA_TRANSACTION
SET K_SYMBOL = REPLACE(K_SYMBOL, 'UVER', 'loan payment');


INSERT INTO sa_account (account_id, district_id, frequency, date_created) SELECT account.account_id ,
account.district_id ,
account.frequency ,
account.date_created 
  FROM ACCOUNT;

INSERT INTO sa_client ( client_id, birth_number, district_id ) SELECT client.client_id,
client.birth_number ,
client.district_id 
  FROM CLIENT;
  
UPDATE SA_CLIENT
SET BIRTH_NUMBER =  SUBSTR (birth_number, 1, 2) || (SUBSTR (birth_number, 3, 2)) - 50 || SUBSTR (birth_number, 5, 2)
WHERE SUBSTR (birth_number, 3, 2) > 12;
  
INSERT INTO sa_credit_card(card_id, disp_id, type, issued) SELECT credit_card.card_id,
credit_card.disp_id,
credit_card.type,
credit_card.issued
FROM CREDIT_CARD;

INSERT INTO sa_demographic_data(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16) SELECT demographic_data.a1,
demographic_data.a2,
demographic_data.a3,
demographic_data.a4,
demographic_data.a5,
demographic_data.a6,
demographic_data.a7,
demographic_data.a8,
demographic_data.a9,
demographic_data.a10,
demographic_data.a11,
demographic_data.a12,
demographic_data.a13,
demographic_data.a14,
demographic_data.a15,
demographic_data.a16
FROM DEMOGRAPHIC_DATA;

INSERT INTO sa_disposition(disp_id, client_id, account_id,type) SELECT disposition.disp_id,
disposition.client_id,
disposition.account_id,
disposition.type
FROM DISPOSITION;

INSERT INTO sa_loan(LOAN_ID, ACCOUNT_ID, "date", AMOUNT, DURATION, PAYMENTS, STATUS) SELECT loan.loan_id,
loan.account_id,
loan."date",
loan.amount,
loan.duration,
loan.payments,
loan.status
FROM LOAN;

ALTER TABLE SA_LOAN
MODIFY STATUS VARCHAR2(200);

UPDATE SA_LOAN
SET STATUS = REPLACE(STATUS, 'A', 'contract finished, no problems');

UPDATE SA_LOAN
SET STATUS = REPLACE(STATUS, 'B', 'contract finished, loan not payed');

UPDATE SA_LOAN
SET STATUS = REPLACE(STATUS, 'C', 'running contract, OK so far');

UPDATE SA_LOAN
SET STATUS = REPLACE(STATUS, 'D', 'running contract, client in debt');

INSERT INTO sa_permanent_order(ORDER_ID,ACCOUNT_ID,BANK_TO,ACCOUNT_TO,AMOUNT,K_SYMBOL) SELECT permanent_order.order_id,
permanent_order.account_id,
permanent_order.bank_to,
permanent_order.account_to,
permanent_order.amount,
permanent_order.k_symbol
FROM permanent_order;

INSERT INTO sa_transaction(TRANS_ID,ACCOUNT_ID,"date",TYPE,OPERATION,AMOUNT,BALANCE,K_SYMBOL,BANK,ACCOUNT) SELECT transaction.trans_id,
transaction.account_id,
transaction."date",
transaction.type,
transaction.operation,
transaction.amount,
transaction.balance,
transaction.k_symbol,
transaction.bank,
transaction.account
FROM transaction;

UPDATE SA_transaction
SET k_symbol = REPLACE(k_symbol, 'POJISTNE', 'insurrance');
UPDATE SA_transaction
SET k_symbol = REPLACE(k_symbol, 'SLUZBY', 'statement');
UPDATE SA_transaction
SET k_symbol = REPLACE(k_symbol, 'UROK', 'interest');
UPDATE SA_transaction
SET k_symbol = REPLACE(k_symbol, 'SANKC.UROK', 'sanction');
UPDATE SA_transaction
SET k_symbol = REPLACE(k_symbol, 'SIPO', 'household');
UPDATE SA_transaction
SET k_symbol = REPLACE(k_symbol, 'DUCHOD', 'pension');
UPDATE SA_transaction
SET k_symbol = REPLACE(k_symbol, 'UVER', 'loan');


------------------Data warehouse----------------------
CREATE TABLE dw_account_dim (
    account_id      INTEGER NOT NULL,
    frequency       VARCHAR2(100)
);

ALTER TABLE dw_account_dim ADD CONSTRAINT account_dim_pk PRIMARY KEY ( account_id );

CREATE TABLE dw_calendar_dim (
    year  INTEGER NOT NULL,
    month INTEGER NOT NULL,
    day   INTEGER NOT NULL
);

UPDATE DW_CALENDAR_DIM
SET YEAR = YEAR-1900;

ALTER TABLE dw_calendar_dim
    ADD CONSTRAINT calendar_dim_pk PRIMARY KEY ( year,
                                                 month,
                                                 day );



CREATE TABLE dw_loan_dim (
    loan_id INTEGER NOT NULL,
    status  CHAR(1)
);

ALTER TABLE DW_LOAN_DIM
MODIFY STATUS VARCHAR2(100);

ALTER TABLE dw_loan_dim ADD CONSTRAINT loan_dim_pk PRIMARY KEY ( loan_id );

CREATE TABLE dw_loan_fact (
    loan_dim_loan_dim_id   NUMBER NOT NULL,
    account_dim_account_id INTEGER NOT NULL,
    amount                 NUMBER,
    duration               INTEGER,
    payments               NUMBER,
    calendar_dim_year      INTEGER NOT NULL,
    calendar_dim_month     INTEGER NOT NULL,
    calendar_dim_day       INTEGER NOT NULL
);




CREATE TABLE dw_order_dim (
    order_id   INTEGER NOT NULL,
    bank_to    CHAR(2),
    account_to VARCHAR2(100),
    k_symbol   VARCHAR2(100)
);

ALTER TABLE dw_order_dim ADD CONSTRAINT order_dim_pk PRIMARY KEY ( order_id );

CREATE TABLE dw_order_fact (
    order_dim_order_id     INTEGER NOT NULL,
    account_dim_account_id INTEGER NOT NULL,
    amount                 FLOAT
 
);

CREATE TABLE dw_trans_dim (
    trans_id  INTEGER NOT NULL,
    type      VARCHAR2(100),
    operation VARCHAR2(100),
    k_symbol  VARCHAR2(100),
    bank      CHAR(2),
    account   VARCHAR2(100)
);
UPDATE dw_trans_dim
SET k_symbol = REPLACE(k_symbol, 'POJISTNE', 'insurrance');
UPDATE dw_trans_dim
SET k_symbol = REPLACE(k_symbol, 'SLUZBY', 'statement');
UPDATE dw_trans_dim
SET k_symbol = REPLACE(k_symbol, 'UROK', 'interest');
UPDATE dw_trans_dim
SET k_symbol = REPLACE(k_symbol, 'SANKC.UROK', 'sanction');
UPDATE dw_trans_dim
SET k_symbol = REPLACE(k_symbol, 'SIPO', 'household');
UPDATE dw_trans_dim
SET k_symbol = REPLACE(k_symbol, 'DUCHOD', 'pension');
UPDATE dw_trans_dim
SET k_symbol = REPLACE(k_symbol, 'UVER', 'loan');

ALTER TABLE dw_trans_dim ADD CONSTRAINT trans_dim_pk PRIMARY KEY ( trans_id );

CREATE TABLE dw_trans_fact (
    trans_dim_trans_id     INTEGER NOT NULL,
    account_dim_account_id INTEGER NOT NULL,
    amount                 NUMBER,
    balance                NUMBER,
    calendar_dim_year      INTEGER NOT NULL,
    calendar_dim_month     INTEGER NOT NULL,
    calendar_dim_day       INTEGER NOT NULL
);

ALTER TABLE DW_TRANS_FACT
drop column DATE_OF_TRANS;

ALTER TABLE dw_account_dim
    ADD CONSTRAINT account_dim_dem_data_dim_fk FOREIGN KEY ( dem_data_dim_a1 )
        REFERENCES dw_dem_data_dim ( a1 );

ALTER TABLE dw_loan_fact
    ADD CONSTRAINT loan_fact_account_dim_fk FOREIGN KEY ( account_dim_account_id )
        REFERENCES dw_account_dim ( account_id );
ALTER TABLE dw_loan_fact
DROP CONSTRAINT loan_fact_account_dim_fk;        

ALTER TABLE dw_loan_fact
    ADD CONSTRAINT loan_fact_calendar_dim_fk FOREIGN KEY ( calendar_dim_year,
                                                           calendar_dim_month,
                                                           calendar_dim_day )
        REFERENCES dw_calendar_dim ( year,
                                  month,
                                  day );

ALTER TABLE dw_loan_fact
    ADD CONSTRAINT loan_fact_loan_dim_fk FOREIGN KEY ( loan_dim_loan_dim_id )
        REFERENCES dw_loan_dim ( loan_id );

ALTER TABLE dw_order_fact
    ADD CONSTRAINT order_fact_account_dim_fk FOREIGN KEY ( account_dim_account_id )
        REFERENCES dw_account_dim ( account_id );


ALTER TABLE dw_order_fact
    ADD CONSTRAINT order_fact_order_dim_fk FOREIGN KEY ( order_dim_order_id )
        REFERENCES dw_order_dim ( order_id );

ALTER TABLE dw_trans_fact
    ADD CONSTRAINT trans_fact_account_dim_fk FOREIGN KEY ( account_dim_account_id )
        REFERENCES dw_account_dim ( account_id );

ALTER TABLE dw_trans_fact
    ADD CONSTRAINT trans_fact_calendar_dim_fk FOREIGN KEY ( calendar_dim_year,
                                                            calendar_dim_month,
                                                            calendar_dim_day )
        REFERENCES dw_calendar_dim ( year,
                                  month,
                                  day );

ALTER TABLE dw_trans_fact
    ADD CONSTRAINT trans_fact_trans_dim_fk FOREIGN KEY ( trans_dim_trans_id )
        REFERENCES dw_trans_dim ( trans_id );
        


INSERT INTO dw_loan_dim(LOAN_ID,STATUS) SELECT 
LOAN_ID,
STATUS
FROM sa_LOAN;

INSERT INTO dw_account_dim (account_id, frequency ) 
SELECT sa_account.account_id, sa_account.frequency FROM sa_account;

INSERT INTO dw_order_dim (order_id, bank_to,account_to,k_symbol) Select
order_id,bank_to,account_to,k_symbol FROM sa_permanent_order;

INSERT INTO dw_trans_dim (trans_id, type, operation, k_symbol, bank, account)
SELECT trans_id, type, operation, k_symbol, bank, account FROM sa_transaction;


ALTER TABLE dw_loan_fact
    ADD CONSTRAINT order_loan_dim_fk FOREIGN KEY ( CALENDAR_DIM_YEAR,CALENDAR_DIM_MONTH,CALENDAR_DIM_DAY )
        REFERENCES dw_calendar_dim ( year,month,day );
ALTER TABLE dw_loan_fact
DROP CONSTRAINT order_loan_dim_fk;

-----
select account_id,sum(amount),duration from DW_LOAN_FACT
join dw_loan_dim on dw_loan_fact.loan_dim_loan_dim_id= dw_loan_dim.loan_id
join dw_account_dim on dw_loan_fact.account_dim_account_id= dw_account_dim.account_id
where dw_loan_dim.status = 'running contract, client in debt' 
group by account_id, duration order by sum(amount) desc
fetch first 5 rows only;

select account_dim_account_id as "User", sum(amount) as "Total Sum"
from dw_trans_fact 
join dw_trans_dim on dw_trans_fact.trans_dim_trans_id = dw_trans_dim.trans_id 
where k_symbol= 'pension'
group by account_dim_account_id order by sum(amount) desc;

select account_dim_account_id as "User", sum(amount)as "Total Sum" from dw_trans_fact 
join dw_trans_dim on dw_trans_fact.trans_dim_trans_id = dw_trans_dim.trans_id
where calendar_dim_year = 98 and calendar_dim_month > 0  and calendar_dim_month < 4 and operation='credit card withdrawal'
group by account_dim_account_id order by sum(amount) desc;

select bank_to as "BANK",sum(amount)as "SUM RECEIVED"
from dw_order_fact
join dw_order_dim on dw_order_fact.order_dim_order_id=dw_order_dim.order_id
where k_symbol='HOUSEHOLD'
group by  bank_to order by sum(amount) desc
fetch first 10 rows only;








                           
