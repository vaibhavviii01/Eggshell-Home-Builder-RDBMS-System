-- Team 1
-- 95-736 Final Project
-- Fall 2025
-- Contents:
--- 0. Drop tables
--- 1. Create tables
--- 2. Define sequences
--- 3. Create alternate indices for House_Style (house_style_name_uindex) and Decorator_Choice (uq_house_style_name)
--- 4. Insert data + create denormalized table (subdivision_education_zones)
--- 5. Create views: available_lots, employee_stats
--- 6. Create roles: sales_manager, construction_manager
--- 7. Create package: g1_eggshellHomebuilder_pkg
----- a. [within package] define 1 function:   calc_total_contract_price
----- b. [within package] define 3 procedures: add_decorator_choice, update_existing_contract_status, update_progress_stage
----- c. [within package] define 2 reports:    generate_constr_prog_report, generate_sales_report
--- 8. Create triggers: trg_prevent_negative_money, trg_prevent_double_sale
--- 9. Schedule daily job to generate Construction Progress Report (via schedule_progress_report)

--------------------------------------------------------------------------------------------------------------------------------
/* 0. Drop all tables in database */
--------------------------------------------------------------------------------------------------------------------------------

DROP TABLE bank CASCADE CONSTRAINTS;
DROP TABLE buyer CASCADE CONSTRAINTS;
DROP TABLE construction_stage CASCADE CONSTRAINTS;
DROP TABLE contract CASCADE CONSTRAINTS;
DROP TABLE decorator_choice CASCADE CONSTRAINTS;
DROP TABLE decorator_option CASCADE CONSTRAINTS;
DROP TABLE elevation CASCADE CONSTRAINTS;
DROP TABLE employee CASCADE CONSTRAINTS;
DROP TABLE escrow_agent CASCADE CONSTRAINTS;
DROP TABLE house_progress CASCADE CONSTRAINTS;
DROP TABLE house_style CASCADE CONSTRAINTS;
DROP TABLE lot CASCADE CONSTRAINTS;
DROP TABLE sale CASCADE CONSTRAINTS;
DROP TABLE school CASCADE CONSTRAINTS;
DROP TABLE school_district CASCADE CONSTRAINTS;
DROP TABLE subdivision CASCADE CONSTRAINTS;

--------------------------------------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------------------------------------
/* 1. Create all tables (with constraints) in database */
--------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE bank (
    bank_id     INTEGER NOT NULL,
    bank_name   VARCHAR2(50 CHAR) NOT NULL,
    phone       VARCHAR2(20 CHAR) NOT NULL,
    fax         VARCHAR2(20 CHAR),
    street      VARCHAR2(50 CHAR) NOT NULL,
    city        VARCHAR2(50 CHAR) NOT NULL,
    state       VARCHAR2(2 CHAR) NOT NULL,
    zip         VARCHAR2(5) NOT NULL
);

ALTER TABLE bank ADD CONSTRAINT bank_pk PRIMARY KEY ( bank_id );

CREATE TABLE buyer (
    buyer_id               INTEGER NOT NULL,
    first_name             VARCHAR2(20 CHAR) NOT NULL,
    last_name              VARCHAR2(20 CHAR) NOT NULL,
    phone                  VARCHAR2(20 CHAR) NOT NULL,
    email                  VARCHAR2(50 CHAR),
    street                 VARCHAR2(50 CHAR) NOT NULL,
    city                   VARCHAR2(50 CHAR) NOT NULL,
    state                  VARCHAR2(2 CHAR) NOT NULL,
    zip                    VARCHAR2(5 CHAR) NOT NULL,
    bank_bank_id           INTEGER NOT NULL
);


ALTER TABLE buyer ADD CONSTRAINT buyer_pk PRIMARY KEY ( buyer_id );

CREATE TABLE construction_stage (
    stage_id            INTEGER NOT NULL,
    stage_name          VARCHAR2(50 CHAR) NOT NULL,
    stage_description   VARCHAR2(200 CHAR),
    est_complete_time   INTEGER NOT NULL
);

ALTER TABLE construction_stage ADD CONSTRAINT construction_stage_pk PRIMARY KEY ( stage_id );

CREATE TABLE contract (
    contract_id                      INTEGER NOT NULL,
    signed_date                      DATE NOT NULL,
    base_price                       NUMBER NOT NULL,
    additional_cost                  NUMBER,
    escrow_amount                    NUMBER NOT NULL,
    estimated_completion_date        DATE NOT NULL,
    completion_date                  DATE,
    expiration_date                  DATE NOT NULL,
    contract_status                  VARCHAR2(30 CHAR) NOT NULL,
    finance_method                   VARCHAR2(50 CHAR) NOT NULL,
    lot_lot_id                       INTEGER NOT NULL,
    sale_sale_id                     INTEGER, 				
    buyer_buyer_id                   INTEGER NOT NULL,
    employee_employee_id             INTEGER
);

CREATE UNIQUE INDEX contract__idx ON
    contract (
        sale_sale_id
    ASC );

CREATE UNIQUE INDEX contract__idxv1 ON
    contract (
        buyer_buyer_id
    ASC );

ALTER TABLE contract ADD CONSTRAINT contract_pk PRIMARY KEY ( contract_id );

CREATE TABLE decorator_choice (
    choice_id                        INTEGER NOT NULL,
    choice_date                      DATE NOT NULL,
    comments                         VARCHAR2(200 CHAR),
    lot_lot_id                       INTEGER,
    option_option_id                 INTEGER NOT NULL
);

ALTER TABLE decorator_choice ADD CONSTRAINT decorator_choice_pk PRIMARY KEY ( choice_id );

CREATE TABLE elevation (
    elevation_id            INTEGER NOT NULL,
    elevation_name          VARCHAR2(50 CHAR) NOT NULL, 
    elevation_description   VARCHAR2(200 CHAR) NOT NULL,
    additional_cost         NUMBER
);

ALTER TABLE elevation ADD CONSTRAINT elevation_pk PRIMARY KEY ( elevation_id );

CREATE TABLE employee (
    employee_id   INTEGER NOT NULL,
    first_name    VARCHAR2(20 CHAR) NOT NULL,
    last_name     VARCHAR2(20 CHAR) NOT NULL,
    email         VARCHAR2(50 CHAR) NOT NULL,
    department    VARCHAR2(50 CHAR) NOT NULL,
    title         VARCHAR2(30 CHAR) NOT NULL,
    salary        NUMBER NOT NULL
);

ALTER TABLE employee ADD CONSTRAINT employee_pk PRIMARY KEY ( employee_id );

CREATE TABLE escrow_agent (
    employee_id   INTEGER NOT NULL,
    license_no    NUMBER NOT NULL
);

ALTER TABLE escrow_agent ADD CONSTRAINT escrow_agent_pk PRIMARY KEY ( employee_id );

CREATE TABLE house_progress (
    progress_report_id               INTEGER NOT NULL,
    stage_start_date                 DATE NOT NULL,
    estimated_completion_date        DATE NOT NULL,
    date_completed                   DATE,
    lot_lot_id                       INTEGER,
    construction_stage_stage_id      INTEGER NOT NULL
);

ALTER TABLE house_progress ADD CONSTRAINT house_progress_pk PRIMARY KEY ( progress_report_id );

CREATE TABLE house_style (
    style_id            INTEGER NOT NULL,
    style_name          VARCHAR2(50 CHAR) NOT NULL,
    style_description   VARCHAR2(200 CHAR) NOT NULL,
    photo               VARCHAR2(200 CHAR) NOT NULL,
    style_size          NUMBER NOT NULL,
    rooms               VARCHAR2(200) NOT NULL,
    num_bedrooms        INTEGER NOT NULL,
    num_bathrooms       NUMBER(2, 1) NOT NULL,
    num_windows         INTEGER NOT NULL,
    has_basement        CHAR(1) NOT NULL
);

ALTER TABLE house_style ADD CONSTRAINT house_style_pk PRIMARY KEY ( style_id );

CREATE TABLE lot (
    lot_id                       INTEGER NOT NULL,
    street                       VARCHAR2(50 CHAR) NOT NULL,
    city                         VARCHAR2(50 CHAR) NOT NULL,
    state                        VARCHAR2(2 CHAR) NOT NULL,
    zip                          VARCHAR2(5 CHAR) NOT NULL,
    latitude                     NUMBER NOT NULL,
    longitude                    NUMBER NOT NULL,
    status                       VARCHAR2(20 CHAR) NOT NULL,
    lot_premium                  NUMBER NOT NULL,
    lot_size                     NUMBER NOT NULL,
    is_reverse                   CHAR(1) NOT NULL,
    subdivision_subdivision_id   INTEGER NOT NULL,
    house_style_style_id         INTEGER NOT NULL,
    elevation_elevation_id       INTEGER NOT NULL
);

ALTER TABLE lot ADD CHECK ( lot_size BETWEEN 0 AND 5000 );

ALTER TABLE lot ADD CONSTRAINT lot_pk PRIMARY KEY ( lot_id);

CREATE TABLE decorator_option (
    option_id      INTEGER NOT NULL,
    option_name    VARCHAR2(50 CHAR) NOT NULL,
    room           VARCHAR2(50 CHAR) NOT NULL,
    category       VARCHAR2(10) NOT NULL,
    description    VARCHAR2(200 CHAR),
    stage1_price   NUMBER NOT NULL,
    stage4_price   NUMBER,
    stage7_price   NUMBER      
);

ALTER TABLE decorator_option ADD CONSTRAINT option_pk PRIMARY KEY ( option_id );

CREATE TABLE sale (
    sale_id                         INTEGER NOT NULL,
    "Date"                          DATE NOT NULL,
    receipt_subdivision_agreement   BINARY_FLOAT NOT NULL,
    receipt_disclosure_form         BINARY_FLOAT NOT NULL,
    receipt_contract                BINARY_FLOAT NOT NULL
);

ALTER TABLE sale ADD CONSTRAINT sale_pk PRIMARY KEY ( sale_id );

CREATE TABLE school (
    school_id                     INTEGER NOT NULL,
    school_type                   VARCHAR2(20) NOT NULL,
    school_name                   VARCHAR2(50 CHAR) NOT NULL,
    private_public                VARCHAR2(20 CHAR) NOT NULL,
    school_rating                 INTEGER NOT NULL,
    school_district_district_id   INTEGER NOT NULL
);

ALTER TABLE school ADD CONSTRAINT school_pk PRIMARY KEY ( school_id );

CREATE TABLE school_district (
    district_id     INTEGER NOT NULL,
    district_name   VARCHAR2(50 CHAR) NOT NULL
);

ALTER TABLE school_district ADD CONSTRAINT school_district_pk PRIMARY KEY ( district_id );

CREATE TABLE subdivision (
    subdivision_id                INTEGER NOT NULL,
    subdivision_name              VARCHAR2(50 CHAR) NOT NULL,
    school_district_district_id   INTEGER NOT NULL
);

ALTER TABLE subdivision ADD CONSTRAINT subdivision_pk PRIMARY KEY ( subdivision_id );

ALTER TABLE buyer
    ADD CONSTRAINT buyer_bank_fk FOREIGN KEY ( bank_bank_id )
        REFERENCES bank ( bank_id );

ALTER TABLE contract
    ADD CONSTRAINT contract_buyer_fk FOREIGN KEY ( buyer_buyer_id )
        REFERENCES buyer ( buyer_id );

ALTER TABLE contract
    ADD CONSTRAINT contract_employee_fk FOREIGN KEY ( employee_employee_id )
        REFERENCES employee ( employee_id );

ALTER TABLE contract
    ADD CONSTRAINT contract_lot_fk FOREIGN KEY ( lot_lot_id)
        REFERENCES lot ( lot_id);

ALTER TABLE contract
    ADD CONSTRAINT contract_sale_fk FOREIGN KEY ( sale_sale_id )
        REFERENCES sale ( sale_id );

ALTER TABLE decorator_choice
    ADD CONSTRAINT decorator_choice_lot_fk FOREIGN KEY ( lot_lot_id)
        REFERENCES lot ( lot_id);

ALTER TABLE decorator_choice
    ADD CONSTRAINT decorator_choice_option_fk FOREIGN KEY ( option_option_id )
        REFERENCES decorator_option ( option_id );

ALTER TABLE escrow_agent
    ADD CONSTRAINT escrow_employee_fk FOREIGN KEY ( employee_id )
        REFERENCES employee ( employee_id );

ALTER TABLE house_progress
    ADD CONSTRAINT house_progress_construction_stage_fk FOREIGN KEY ( construction_stage_stage_id )
        REFERENCES construction_stage ( stage_id );

ALTER TABLE house_progress
    ADD CONSTRAINT house_progress_lot_fk FOREIGN KEY ( lot_lot_id)
        REFERENCES lot ( lot_id);

ALTER TABLE lot
    ADD CONSTRAINT lot_elevation_fk FOREIGN KEY ( elevation_elevation_id )
        REFERENCES elevation ( elevation_id );

ALTER TABLE lot
    ADD CONSTRAINT lot_house_style_fk FOREIGN KEY ( house_style_style_id )
        REFERENCES house_style ( style_id );

ALTER TABLE lot
    ADD CONSTRAINT lot_subdivision_fk FOREIGN KEY ( subdivision_subdivision_id )
        REFERENCES subdivision ( subdivision_id );

ALTER TABLE school
    ADD CONSTRAINT school_school_district_fk FOREIGN KEY ( school_district_district_id )
        REFERENCES school_district ( district_id );

ALTER TABLE subdivision
    ADD CONSTRAINT subdivision_school_district_fk FOREIGN KEY ( school_district_district_id )
        REFERENCES school_district ( district_id );

--------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------
/* 2. Creating sequences for Table IDs based on predefined naming structure:

    The Loop below creates a virtual table of values (sequence name + start value) using SELECT ... FROM dual UNION ALL ...
    by looping through each row of that virtual table and dynamically builds and executes a CREATE SEQUENCE command using 
    EXECUTE IMMEDIATE.
*/
-------------------------------------------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON;
BEGIN
    -- First, drop all sequences if they exist
    FOR rec IN (
        SELECT 'lot_sequence' AS seq_name FROM dual UNION ALL
        SELECT 'subdivision_sequence' FROM dual UNION ALL
        SELECT 'house_style_sequence' FROM dual UNION ALL
        SELECT 'elevation_sequence' FROM dual UNION ALL
        SELECT 'contract_sequence' FROM dual UNION ALL
        SELECT 'house_progress_sequence' FROM dual UNION ALL
        SELECT 'decorator_choice_sequence' FROM dual UNION ALL
        SELECT 'option_sequence' FROM dual UNION ALL
        SELECT 'sale_sequence' FROM dual UNION ALL
        SELECT 'buyer_sequence' FROM dual UNION ALL
        SELECT 'employee_sequence' FROM dual UNION ALL
        SELECT 'bank_sequence' FROM dual UNION ALL
        SELECT 'school_sequence' FROM dual UNION ALL
        SELECT 'school_district_sequence' FROM dual
    ) LOOP
        BEGIN
            EXECUTE IMMEDIATE 'DROP SEQUENCE ' || rec.seq_name;
            DBMS_OUTPUT.PUT_LINE('Dropped sequence: ' || rec.seq_name);

        EXCEPTION
            WHEN OTHERS THEN
                IF SQLCODE != -2289 THEN  -- ORA-02289: sequence does not exist
                    RAISE;
                END IF;
        END;
    END LOOP;
    
    -- Then, recreate the sequences
    FOR rec IN (
        SELECT 'lot_sequence' AS seq_name, 101001 AS start_val FROM dual UNION ALL
        SELECT 'subdivision_sequence', 102001 FROM dual UNION ALL
        SELECT 'house_style_sequence', 103001 FROM dual UNION ALL
        SELECT 'elevation_sequence', 104001 FROM dual UNION ALL
        SELECT 'contract_sequence', 105001 FROM dual UNION ALL
        SELECT 'house_progress_sequence', 106001 FROM dual UNION ALL
        SELECT 'decorator_choice_sequence', 107001 FROM dual UNION ALL
        SELECT 'option_sequence', 108001 FROM dual UNION ALL
        SELECT 'sale_sequence', 109001 FROM dual UNION ALL
        SELECT 'buyer_sequence', 111001 FROM dual UNION ALL
        SELECT 'employee_sequence', 112001 FROM dual UNION ALL
        SELECT 'bank_sequence', 113001 FROM dual UNION ALL
        SELECT 'school_sequence', 114001 FROM dual UNION ALL
        SELECT 'school_district_sequence', 115001 FROM dual
    ) LOOP
        EXECUTE IMMEDIATE 'CREATE SEQUENCE ' || rec.seq_name || 
                          ' START WITH ' || rec.start_val || 
                          ' INCREMENT BY 1';
    END LOOP;
END;
/

--------------------------------------------------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------------------------------------------
/* 3. Creating an Alternate (Unique and non-Unique) Index on House_Style and Decorator_Choice Entities */
-------------------------------------------------------------------------------------------------------------------------------
CREATE UNIQUE INDEX house_style_name_uindex ON house_style (style_name);
ALTER TABLE house_style
ADD CONSTRAINT uq_house_style_name UNIQUE (style_name)
USING INDEX house_style_name_uindex;


CREATE INDEX decorator_option_name_idx ON decorator_option (option_name);

--------------------------------------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------------------------------------
/* 4. Insert data into all tables in database (create alternate indices for  */
--------------------------------------------------------------------------------------------------------------------------------

-- Inserting Records into School District
-- First, clear all existing data:
DELETE FROM escrow_agent;
DELETE FROM contract;
DELETE FROM sale;
DELETE FROM house_progress;
DELETE FROM decorator_choice;
DELETE FROM decorator_option;
DELETE FROM buyer;
DELETE FROM lot;
DELETE FROM employee;
DELETE FROM construction_stage;
DELETE FROM house_style;
DELETE FROM elevation;
DELETE FROM school;
DELETE FROM subdivision;
DELETE FROM school_district;
DELETE FROM bank;
COMMIT;

-- Inserting Values into School District (Required by: school, subdivision)

INSERT INTO school_district VALUES (school_district_sequence.NEXTVAL, 'Funding Needed District'); 
INSERT INTO school_district VALUES (school_district_sequence.NEXTVAL, 'We Rich District'); 
INSERT INTO school_district VALUES (school_district_sequence.NEXTVAL, 'Life Is Good District'); 
INSERT INTO school_district VALUES (school_district_sequence.NEXTVAL, 'Money Laundering District'); 
-------------------------------------------------------------------------------------------------------------------------------

-- Inserting Records into School 

INSERT INTO school VALUES (school_sequence.NEXTVAL, 'Elementary School','Meh Hills','Public',4,115001); 
INSERT INTO school VALUES (school_sequence.NEXTVAL, 'Elementary School','Plesant Hills','Private',9,115002);
INSERT INTO school VALUES (school_sequence.NEXTVAL, 'Middle School','Golden Waterfalls','Public',6,115002); 
INSERT INTO school VALUES (school_sequence.NEXTVAL, 'High School','Juniper Preparatory','Private',9,115002); 
INSERT INTO school VALUES (school_sequence.NEXTVAL, 'Elementary School','Valley View','Public',4,115003); 
INSERT INTO school VALUES (school_sequence.NEXTVAL, 'Middle School','Snowy Mountains','Private',7,115003); 
INSERT INTO school VALUES (school_sequence.NEXTVAL, 'High School','Lake Geneva','Public',5,115003); 
INSERT INTO school VALUES (school_sequence.NEXTVAL, 'Pre School','Babies Never Cry','Public',8,115004); 
INSERT INTO school VALUES (school_sequence.NEXTVAL, 'Elementary School','Now They Growing','Private',9,115004); 
INSERT INTO school VALUES (school_sequence.NEXTVAL, 'Middle School','Here Comes Puberty','Public',3,115004); 
INSERT INTO school VALUES (school_sequence.NEXTVAL, 'High School','Figure Life Out','Public', 2, 115004); 
-------------------------------------------------------------------------------------------------------------------------------

-- Inserting Records into Subdivision  (Required by: lot)

INSERT INTO subdivision VALUES (subdivision_sequence.NEXTVAL, 'Newlyweds Paradise',115003); 
INSERT INTO subdivision VALUES (subdivision_sequence.NEXTVAL, 'Divorce Imminent Block',115001); 
INSERT INTO subdivision VALUES (subdivision_sequence.NEXTVAL, 'Inheritance Babies',115002); 
INSERT INTO subdivision VALUES (subdivision_sequence.NEXTVAL, 'Tax Evasion Properties',115004); 

-------------------------------------------------------------------------------------------------------------------------------
-- Denormalized Table: Subdivision + School + School District
DROP TABLE subdivision_education_zones CASCADE CONSTRAINTS;

CREATE TABLE subdivision_education_zones (
    subdivision_id       INTEGER NOT NULL,
    subdivision_name     VARCHAR2(50 CHAR) NOT NULL,
    district_id          INTEGER NOT NULL,
    district_name        VARCHAR2(50 CHAR) NOT NULL,
    school_id            INTEGER NOT NULL,
    school_name          VARCHAR2(50 CHAR) NOT NULL,
    school_type          VARCHAR2(20 CHAR) NOT NULL
);

INSERT INTO subdivision_education_zones (subdivision_id, subdivision_name, district_id, district_name, school_id, school_name, 
                                    school_type)
SELECT 
    sub.subdivision_id,
    sub.subdivision_name,
    sd.district_id,
    sd.district_name,
    s.school_id,
    s.school_name,
    s.school_type
FROM subdivision sub
JOIN school_district sd
  ON sub.school_district_district_id = sd.district_id
JOIN school s
  ON s.school_district_district_id = sd.district_id;
  
  
-------------------------------------------------------------------------------------------------------------------------------

-- Inserting Records into House Style (Required by: lot)

INSERT INTO house_style VALUES (
    HOUSE_STYLE_SEQUENCE.nextval, 'Rennaisance',
    'Timeless, elegant, and functional. This style is known for its symmetrical facades, arched windows, grand interiors, ' ||
    'high ceilings, and indoor-outdoor connections like courtyards or patios',
    '<ren_image_url>', 2000, 10, 4, 3, 12, 'N'
);

INSERT INTO house_style VALUES (
    HOUSE_STYLE_SEQUENCE.nextval, 'Farmhouse',
    'Simple, purposeful, and sturdy. This style features light-colored exteriors with expansive porches, overhead dormers, ' ||
    'dominant fireplaces/exterior chimneys, and a large kitchen.',
    '<frm_image_url>', 1700, 7, 2, 1, 8, 'Y'
);

INSERT INTO house_style VALUES (
    HOUSE_STYLE_SEQUENCE.nextval, 'Contemporary',
    'Clean, geometric, and natural. This style centers sustainability and flexibility in functional open spaces, large ' ||
    'windows for natural light, geometric shapes, and a simple decoration style.',
    '<cont_image_url>', 1800, 8, 3, 3, 12, 'N'
);
-------------------------------------------------------------------------------------------------------------------------------

-- Inserting Records into Elevation (Required by: lot)

INSERT INTO elevation VALUES (ELEVATION_SEQUENCE.nextval, 'Base',
    'This elevation is built with industry-standard materials for a relatively low price', 0);
    
INSERT INTO elevation VALUES (ELEVATION_SEQUENCE.nextval, 'Upgrade',
    'This elevation adds reinforced windows with storm shutters', 13000);
  
INSERT INTO elevation VALUES (ELEVATION_SEQUENCE.nextval, 'Luxury',
    'This elevation adds a modified roofline and advanced exterior stonework to the Upgrade elevation', 22000);    
-------------------------------------------------------------------------------------------------------------------------------

-- Inserting Data into Lot (Required by: contract, decorator_choice, house_progress)

INSERT INTO lot VALUES (LOT_SEQUENCE.nextval, '10 Butler Street', 'Pittsburgh', 'PA', '15201', 40.4721, -79.9604,
    'Under Construction', 15000, 2800, 'N', 102001, 103001, 104001);
    
INSERT INTO lot VALUES (LOT_SEQUENCE.nextval, '456 Penn Avenue', 'Pittsburgh', 'PA', '15224', 40.4634, -79.9457,
    'Sold', 16000, 3000, 'Y', 102001, 103002, 104002);
    
INSERT INTO lot VALUES (LOT_SEQUENCE.nextval, '211 Liberty Avenue', 'Pittsburgh', 'PA', '15222', 40.4431, -79.9930, 
    'Under Construction', 15500, 2900, 'N', 102002, 103003, 104001);
    
INSERT INTO lot VALUES (LOT_SEQUENCE.nextval, '673 Carson Street', 'Pittsburgh', 'PA', '15203', 40.4284, -79.9730,
    'Available', 17000, 3100, 'Y', 102002, 103001, 104003);
    
INSERT INTO lot VALUES (LOT_SEQUENCE.nextval, '89 Centre Avenue', 'Pittsburgh', 'PA', '15219', 40.4521, -79.9760,
    'Sold', 18000, 3200, 'N', 102003, 103002, 104001);
    
INSERT INTO lot VALUES (LOT_SEQUENCE.nextval, '911 Grandview Avenue', 'Pittsburgh', 'PA', '15211', 40.4316, 
    -80.0115, 'Available', 20000, 3300, 'N', 102003, 103003, 104002);
    
INSERT INTO lot VALUES (LOT_SEQUENCE.nextval, '4516 Forbes Avenue', 'Pittsburgh', 'PA', '15213', 40.4419, 
    -79.9533, 'Under Construction', 16500, 2700, 'Y', 102004, 103001, 104003);
    
INSERT INTO lot VALUES (LOT_SEQUENCE.nextval, '3 Boulevard of the Allies', 'Pittsburgh', 'PA', '15219', 
    40.4378, -79.9937, 'Available', 17500, 2950, 'N', 102004, 103002, 104001);
    
INSERT INTO lot VALUES (LOT_SEQUENCE.nextval, '211 Amber St', 'Pittsburgh', 'PA', '15212', 40.4530, -80.0037,
    'Available', 19000, 3000, 'Y', 102001, 103003, 104002);
    
INSERT INTO lot VALUES (LOT_SEQUENCE.nextval, '68 Negley Avenue', 'Pittsburgh', 'PA', '15206', 40.4692, -79.9233,
    'Available', 16000, 2850, 'N', 102002, 103001, 104001);
-------------------------------------------------------------------------------------------------------------------------------

-- Insert Data into Bank (Required by: buyer)

INSERT INTO bank VALUES (bank_sequence.NEXTVAL, 'Pittsburgh Community Bank', '(412) 555-1000', '(412) 555-1001',
    '123 Liberty Ave', 'Pittsburgh', 'PA', '15222');

INSERT INTO bank VALUES ( bank_sequence.NEXTVAL, 'Questionable Investments Bank', '(412) 555-2000', '(412) 555-2002',
    '456 Forbes St', 'Pittsburgh', 'PA', '15219');

INSERT INTO bank VALUES (bank_sequence.NEXTVAL, 'No Guarantess Trust', '(412) 555-3000', NULL,
    '789 Penn Ave', 'Pittsburgh', 'PA', '15222');

INSERT INTO bank VALUES (bank_sequence.NEXTVAL, 'Infidelity Credit Union', '(412) 555-4000', '(356) 498-1093',
    '1010 Smallman St', 'Pittsburgh', 'PA', '15222');

INSERT INTO bank VALUES (bank_sequence.NEXTVAL, 'Rob N Dash Bank', '(412) 555-5000', NULL,
    '2020 Market St', 'Pittsburgh', 'PA', '15222');
-------------------------------------------------------------------------------------------------------------------------------

-- Insert Data into Buyer (Required by Contract)

INSERT INTO buyer VALUES (buyer_sequence.NEXTVAL, 'Afifa', 'Iqbal', '(412) 555-1010', 'maze.runner@gmail.com',
    '123 Elm Street', 'Pittsburgh', 'PA', '15222', 113001);

INSERT INTO buyer VALUES ( buyer_sequence.NEXTVAL, 'Mburu', 'Kagiri', '(412) 555-2020', 'hunger.games@district12.com', 
    '456 Maple Ave', 'Pittsburgh', 'PA', '15219', 113002);

INSERT INTO buyer VALUES (buyer_sequence.NEXTVAL, 'Anna', 'Ringwood', '(412) 555-3030', 'walking.dead@zombie.com',
    '789 Oak Blvd', 'Pittsburgh', 'PA', '15222', 113003);

INSERT INTO buyer VALUES (buyer_sequence.NEXTVAL, 'Vaibhavi', 'Udgirkar', '(412) 555-4040', 'amazing.race@global.com',
    '1010 Birch Lane', 'Pittsburgh', 'PA', '15222',113004);

INSERT INTO buyer VALUES (buyer_sequence.NEXTVAL, 'Steely', 'McBeam', '(412) 555-5050', 'steelers.mascot@steelcity.com',
    '2020 Cedar Road', 'Pittsburgh', 'PA', '15222', 113005);
    
-------------------------------------------------------------------------------------------------------------------------------

-- Insert Data into Employee and Escrow (Required by contract)

INSERT INTO employee VALUES (employee_sequence.NEXTVAL, 'Alice', 'Wonderland', 'alice.loves@rabbits.com', 'Sales',
    'Sales Manager', 60000);

INSERT INTO employee VALUES (employee_sequence.NEXTVAL, 'Oz', 'the Wizard', 'abracadbra@brick.road', 'Construction',
    'Construction Manager', 65000);

INSERT INTO employee VALUES (employee_sequence.NEXTVAL, 'Sasquatch', 'McFoot', 'hideNseekKing@alive.com', 'Legal Department',
    'Lawyer', 100000);

INSERT INTO employee VALUES (employee_sequence.NEXTVAL, 'Ray', 'Firefly', 'with.evangeline@stars.com', 'Finances',
    'Escrow Agent', 80000
);

INSERT INTO escrow_agent VALUES (employee_sequence.CURRVAL, 123);

INSERT INTO employee VALUES (employee_sequence.NEXTVAL, 'Bilbo', 'Baggins', 'Hobbit.RingLover@shire.magic', 'Finances',
    'Escrow Agent', 82000
);
INSERT INTO escrow_agent VALUES (employee_sequence.CURRVAL, 456);

-------------------------------------------------------------------------------------------------------------------------------

-- Insert Data into Sale (Required by: contract)

INSERT INTO sale VALUES (SALE_SEQUENCE.nextval, TO_DATE('2024-08-10', 'YYYY-MM-DD'), 1, 1, 1);
INSERT INTO sale VALUES (SALE_SEQUENCE.nextval, TO_DATE('2025-04-09', 'YYYY-MM-DD'), 1, 0, 1);

-------------------------------------------------------------------------------------------------------------------------------

-- Insert Data into Contract

INSERT INTO contract VALUES (contract_sequence.NEXTVAL,
    TO_DATE('2024-03-01', 'YYYY-MM-DD'),  -- signed_date
    320000,                             -- base_price
    NULL,                               -- additional_cost
    16000,                              -- escrow_amount
    TO_DATE('2024-11-15', 'YYYY-MM-DD'), -- estimated_completion_date
    NULL,                                -- completion_date
    TO_DATE('2024-12-01', 'YYYY-MM-DD'),  -- expiration_date
    'Active',                          -- contract_status
    'Loan',                          -- finance_method
    101001,                            -- lot_lot_id
    NULL,                            -- sale_sale_id
    111001,                            -- buyer_buyer_id
    112004                            -- employee_employee_id (agent)
);

INSERT INTO contract VALUES (contract_sequence.NEXTVAL,
    TO_DATE('2023-07-11', 'YYYY-MM-DD'),  -- signed_date
    300000,                             -- base_price
    30000,                              -- additional_cost
    15000,                              -- escrow_amount
    TO_DATE('2024-08-15', 'YYYY-MM-DD'), -- estimated_completion_date
    TO_DATE('2024-08-31', 'YYYY-MM-DD'),  -- completion_date
    TO_DATE('2024-09-01', 'YYYY-MM-DD'),  -- expiration_date
    'Completed',                          -- contract_status
    'Check',                          -- finance_method
    101002,                            -- lot_lot_id
    109001,                            -- sale_sale_id
    111005,                            -- buyer_buyer_id
    112004                             -- employee_employee_id (agent)
);

INSERT INTO contract VALUES (contract_sequence.NEXTVAL,
    TO_DATE('2024-09-12', 'YYYY-MM-DD'),  -- signed_date
    450000,                             -- base_price
    NULL,                               -- additional_cost
    19000,                              -- escrow_amount
    TO_DATE('2025-10-25', 'YYYY-MM-DD'), -- estimated_completion_date
    NULL,                                -- completion_date
    TO_DATE('2025-11-14', 'YYYY-MM-DD'),  -- expiration_date
    'Active',                          -- contract_status
    'Loan',                          -- finance_method
    101003,                            -- lot_lot_id
    NULL,                            -- sale_sale_id
    111004,                            -- buyer_buyer_id
    112005                            -- employee_employee_id (agent)
);

INSERT INTO contract VALUES (contract_sequence.NEXTVAL,
    TO_DATE('2025-01-01', 'YYYY-MM-DD'),  -- signed_date
    600000,                             -- base_price
    45000,                              -- additional_cost
    30000,                              -- escrow_amount
    TO_DATE('2026-04-05', 'YYYY-MM-DD'), -- estimated_completion_date
    TO_DATE('2026-06-01', 'YYYY-MM-DD'), -- completion_date
    TO_DATE('2026-06-22', 'YYYY-MM-DD'),  -- expiration_date
    'Completed',                          -- contract_status
    'Loan',                          -- finance_method
    101005,                            -- lot_lot_id
    109002,                            -- sale_sale_id
    111002,                            -- buyer_buyer_id
    112005                             -- employee_employee_id (agent)
);

INSERT INTO contract VALUES (contract_sequence.NEXTVAL,
    TO_DATE('2023-10-15', 'YYYY-MM-DD'),  -- signed_date
    525000,                             -- base_price
    NULL,                               -- additional_cost
    20000,                              -- escrow_amount
    TO_DATE('2024-09-15', 'YYYY-MM-DD'), -- estimated_completion_date
    NULL,                                -- completion_date
    TO_DATE('2024-10-01', 'YYYY-MM-DD'),  -- expiration_date
    'Active',                          -- contract_status
    'Check',                          -- finance_method
    101007,                            -- lot_lot_id
    NULL,                            -- sale_sale_id
    111003,                            -- buyer_buyer_id
    112004                             -- employee_employee_id (agent)
);
-------------------------------------------------------------------------------------------------------------------------------

-- Insert Data into construction_stage (Required by: house_progress)

INSERT INTO construction_stage VALUES (1, 'Foundation', 'Construct base of house, including footings, slab, or basement.', 3);
INSERT INTO construction_stage VALUES (2, 'Framing', 'Build structural skeleton with walls, floors, and roof.', 5);
INSERT INTO construction_stage VALUES (3, 'Systems', 'Install plumbing, electrical wiring, and HVAC components.', 3);
INSERT INTO construction_stage VALUES (4, 'Exterior', 'Add roofing, siding, windows, and doors to enclose the house.', 2);
INSERT INTO construction_stage VALUES (5, 'Interior', 'Put up insulation, drywall, and interior partitions.', 2);
INSERT INTO construction_stage VALUES (6, 'Finishes', 'Apply flooring, cabinetry, paint, trim, and fixtures.', 4);
INSERT INTO construction_stage VALUES (7, 'Inspection', 'Complete final checks, touch-ups, and approvals for occupancy.', 2);
-------------------------------------------------------------------------------------------------------------------------------

-- Insert Data into House Progress

INSERT INTO house_progress VALUES (house_progress_sequence.NEXTVAL, TO_DATE('2023-07-20','YYYY-MM-DD'),
    TO_DATE('2023-08-25','YYYY-MM-DD'), TO_DATE('2023-08-22','YYYY-MM-DD'), 101002, 1);
INSERT INTO house_progress VALUES (house_progress_sequence.NEXTVAL, TO_DATE('2023-08-22','YYYY-MM-DD'),
    TO_DATE('2023-10-01','YYYY-MM-DD'), TO_DATE('2023-09-30','YYYY-MM-DD'), 101002, 2);
INSERT INTO house_progress VALUES (house_progress_sequence.NEXTVAL, TO_DATE('2023-09-30','YYYY-MM-DD'),
    TO_DATE('2023-12-02','YYYY-MM-DD'), TO_DATE('2023-12-02','YYYY-MM-DD'), 101002, 3);
INSERT INTO house_progress VALUES (house_progress_sequence.NEXTVAL, TO_DATE('2023-12-02','YYYY-MM-DD'),
    TO_DATE('2024-01-31','YYYY-MM-DD'), TO_DATE('2024-02-04','YYYY-MM-DD'), 101002, 4);
INSERT INTO house_progress VALUES (house_progress_sequence.NEXTVAL, TO_DATE('2024-02-04','YYYY-MM-DD'),
    TO_DATE('2024-05-12','YYYY-MM-DD'), TO_DATE('2024-05-13','YYYY-MM-DD'), 101002, 5);
INSERT INTO house_progress VALUES (house_progress_sequence.NEXTVAL, TO_DATE('2024-03-15','YYYY-MM-DD'),
    TO_DATE('2024-04-18','YYYY-MM-DD'), TO_DATE('2024-04-17','YYYY-MM-DD'), 101005, 1);
INSERT INTO house_progress VALUES (house_progress_sequence.NEXTVAL, TO_DATE('2024-04-17','YYYY-MM-DD'),
    TO_DATE('2024-05-27','YYYY-MM-DD'), TO_DATE('2024-05-24','YYYY-MM-DD'), 101005, 2);
INSERT INTO house_progress VALUES (house_progress_sequence.NEXTVAL, TO_DATE('2024-05-13','YYYY-MM-DD'),
    TO_DATE('2024-06-30','YYYY-MM-DD'), TO_DATE('2024-07-07','YYYY-MM-DD'), 101002, 6);
INSERT INTO house_progress VALUES (house_progress_sequence.NEXTVAL, TO_DATE('2024-05-24','YYYY-MM-DD'),
    TO_DATE('2024-07-26','YYYY-MM-DD'), TO_DATE('2024-07-26','YYYY-MM-DD'), 101005, 3);
INSERT INTO house_progress VALUES (house_progress_sequence.NEXTVAL, TO_DATE('2024-07-07','YYYY-MM-DD'),
    TO_DATE('2024-08-15','YYYY-MM-DD'), TO_DATE('2024-08-10','YYYY-MM-DD'), 101002, 7);
INSERT INTO house_progress VALUES (house_progress_sequence.NEXTVAL, TO_DATE('2024-07-26','YYYY-MM-DD'),
    TO_DATE('2024-09-23','YYYY-MM-DD'), TO_DATE('2024-09-29','YYYY-MM-DD'), 101005, 4);
INSERT INTO house_progress VALUES (house_progress_sequence.NEXTVAL, TO_DATE('2024-09-24','YYYY-MM-DD'),
    TO_DATE('2024-10-29','YYYY-MM-DD'), TO_DATE('2024-10-27','YYYY-MM-DD'), 101003, 1);
INSERT INTO house_progress VALUES (house_progress_sequence.NEXTVAL, TO_DATE('2024-09-29','YYYY-MM-DD'),
    TO_DATE('2025-01-03','YYYY-MM-DD'), TO_DATE('2025-01-05','YYYY-MM-DD'), 101005, 5);
INSERT INTO house_progress VALUES (house_progress_sequence.NEXTVAL, TO_DATE('2024-10-27','YYYY-MM-DD'),
    TO_DATE('2024-12-04','YYYY-MM-DD'), TO_DATE('2024-12-07','YYYY-MM-DD'), 101003, 2);
INSERT INTO house_progress VALUES (house_progress_sequence.NEXTVAL, TO_DATE('2024-12-07','YYYY-MM-DD'),
    TO_DATE('2025-02-09','YYYY-MM-DD'), TO_DATE('2025-02-07','YYYY-MM-DD'), 101003, 3);
INSERT INTO house_progress VALUES (house_progress_sequence.NEXTVAL, TO_DATE('2025-01-05','YYYY-MM-DD'),
    TO_DATE('2025-02-21','YYYY-MM-DD'), TO_DATE('2025-03-03','YYYY-MM-DD'), 101005, 6);
INSERT INTO house_progress VALUES (house_progress_sequence.NEXTVAL, TO_DATE('2025-01-15','YYYY-MM-DD'),
    TO_DATE('2025-03-15','YYYY-MM-DD'), TO_DATE('2025-03-13','YYYY-MM-DD'), 101001, 1);
INSERT INTO house_progress VALUES (house_progress_sequence.NEXTVAL, TO_DATE('2025-02-07','YYYY-MM-DD'),
    TO_DATE('2025-04-08','YYYY-MM-DD'), TO_DATE('2025-04-11','YYYY-MM-DD'), 101003, 4);
INSERT INTO house_progress VALUES (house_progress_sequence.NEXTVAL, TO_DATE('2025-03-03','YYYY-MM-DD'),
    TO_DATE('2025-04-12','YYYY-MM-DD'), TO_DATE('2025-04-05','YYYY-MM-DD'), 101005, 7);
INSERT INTO house_progress VALUES (house_progress_sequence.NEXTVAL, TO_DATE('2025-03-13','YYYY-MM-DD'),
    TO_DATE('2025-04-22','YYYY-MM-DD'), TO_DATE('2025-04-15','YYYY-MM-DD'), 101001, 2);
INSERT INTO house_progress VALUES (house_progress_sequence.NEXTVAL, TO_DATE('2025-04-11','YYYY-MM-DD'),
    TO_DATE('2025-07-16','YYYY-MM-DD'), TO_DATE('2025-07-18','YYYY-MM-DD'), 101003, 5);
INSERT INTO house_progress VALUES (house_progress_sequence.NEXTVAL, TO_DATE('2025-04-15','YYYY-MM-DD'),
    TO_DATE('2025-06-17','YYYY-MM-DD'), NULL, 101001, 3);
INSERT INTO house_progress VALUES (house_progress_sequence.NEXTVAL, TO_DATE('2025-07-18','YYYY-MM-DD'),
    TO_DATE('2025-09-06','YYYY-MM-DD'), NULL, 101003, 6);
INSERT INTO house_progress VALUES (house_progress_sequence.NEXTVAL, TO_DATE('2025-09-30','YYYY-MM-DD'),
    TO_DATE('2025-11-28','YYYY-MM-DD'), NULL, 101007, 1);
-------------------------------------------------------------------------------------------------------------------------------

-- Insert Data into Decorator_Option (Required by: decorator_choice)

INSERT INTO decorator_option VALUES (option_sequence.NEXTVAL, 'Chandelier Wiring', 'Kitchen', 'Electrical',
    'A sturdier wire for heavier fixtures', 20, 75, NULL);
INSERT INTO decorator_option VALUES (option_sequence.NEXTVAL, 'Ceiling Fan Wiring', 'Bedroom', 'Electrical',
    'A sturdier wire for heavier fixtures', 25, 90, NULL);
INSERT INTO decorator_option VALUES (option_sequence.NEXTVAL, 'Mirror Backlights', 'Bathroom', 'Electrical',
    'A soft-glowing yellow light on the back of a protruding mirror', 50, 100, 200);
INSERT INTO decorator_option VALUES (option_sequence.NEXTVAL, 'Electric Stove', 'Kitchen', 'Electrical',
    'Stove uses electricity instead of gas', 125, 200, 500);
INSERT INTO decorator_option VALUES (option_sequence.NEXTVAL, 'Sink in Garage', 'Garage', 'Plumbing',
    'Deep-basin sink with utility nozzle', 130, 400, NULL);
INSERT INTO decorator_option VALUES (option_sequence.NEXTVAL, 'Two Sinks in Bathroom', 'Bathroom', 'Plumbing',
    'Allows for larger counter space', 75, 140, NULL);
INSERT INTO decorator_option VALUES (option_sequence.NEXTVAL, 'Copper Pipes', 'Bathroom', 'Plumbing',
    'Plumbing uses industry-standard copper pipes', 375, 500, NULL);
INSERT INTO decorator_option VALUES (option_sequence.NEXTVAL, 'PVC Pipes', 'Bathroom', 'Plumbing',
    'Plumbing uses industry-standard PVC pipes', 425, 600, NULL);
INSERT INTO decorator_option VALUES (option_sequence.NEXTVAL, 'Wooden Cabinetry', 'Kitchen', 'Interior',
    'Cabinets are sturdier but also heavier', 400, 525, 700);
INSERT INTO decorator_option VALUES (option_sequence.NEXTVAL, 'Particleboard Cabinetry', 'Kitchen', 'Interior',
    'Cabinets are less sturdy but lighter', 200, 400, 550);
INSERT INTO decorator_option VALUES (option_sequence.NEXTVAL, 'Toilet Flush Handle', 'Bathroom', 'Interior',
    'Places flush as a top-of-tank button instead of a lever', 225, 200, 250);
INSERT INTO decorator_option VALUES (option_sequence.NEXTVAL, 'Doorknobs', 'Bedroom', 'Interior',
    'Doorknobs with two-way locks', 20, 35, 50);
INSERT INTO decorator_option VALUES (option_sequence.NEXTVAL, 'One Garage Door', 'Garage', 'Exterior',
    'Double-car garage is fitted with a single door', 300, 500, 1000);
INSERT INTO decorator_option VALUES (option_sequence.NEXTVAL, 'Two Garage Doors', 'Garage', 'Exterior',
    'Double-car garage is fitted with two doors and a pillar in the middle', 300, 500, 1000);
INSERT INTO decorator_option VALUES (option_sequence.NEXTVAL, 'Porch Swing', 'Exterior', 'Exterior',
    'Fixtures are installed to support a porch swing', 200, 250, 300);
INSERT INTO decorator_option VALUES (option_sequence.NEXTVAL, 'Floodlights', 'Exterior', 'Exterior',
    'Floodlights are attached at all corners of the house', 175, 300, NULL);
-------------------------------------------------------------------------------------------------------------------------------

-- Insert Data into Decorator_Choice

INSERT INTO decorator_choice VALUES (decorator_choice_sequence.NEXTVAL, TO_DATE('2025-02-02', 'YYYY-MM-DD'),
    NULL, 101001, 108001);
INSERT INTO decorator_choice VALUES (decorator_choice_sequence.NEXTVAL, TO_DATE('2025-02-02', 'YYYY-MM-DD'),
    'Buyer is very adamant', 101001, 108006);
INSERT INTO decorator_choice VALUES (decorator_choice_sequence.NEXTVAL, TO_DATE('2023-07-31', 'YYYY-MM-DD'),
    'Need to order more inventory', 101002, 108004);
INSERT INTO decorator_choice VALUES (decorator_choice_sequence.NEXTVAL, TO_DATE('2024-07-31', 'YYYY-MM-DD'),
    NULL, 101002, 108012);
INSERT INTO decorator_choice VALUES (decorator_choice_sequence.NEXTVAL, TO_DATE('2024-10-15', 'YYYY-MM-DD'),
    NULL, 101003, 108002);
INSERT INTO decorator_choice VALUES (decorator_choice_sequence.NEXTVAL, TO_DATE('2024-03-01', 'YYYY-MM-DD'),
    NULL, 101003, 108009);
INSERT INTO decorator_choice VALUES (decorator_choice_sequence.NEXTVAL, TO_DATE('2024-08-01', 'YYYY-MM-DD'),
    'Customer changed mind again!', 101005, 108013);
INSERT INTO decorator_choice VALUES (decorator_choice_sequence.NEXTVAL, TO_DATE('2025-03-31', 'YYYY-MM-DD'),
    'Why would they decide this so late???', 101005, 108011);
INSERT INTO decorator_choice VALUES (decorator_choice_sequence.NEXTVAL, TO_DATE('2025-10-01', 'YYYY-MM-DD'),
    NULL, 101007, 108005);
INSERT INTO decorator_choice VALUES (decorator_choice_sequence.NEXTVAL, TO_DATE('2025-10-02', 'YYYY-MM-DD'),
    'This buyer has their act together', 101007, 108007);
-------------------------------------------------------------------------------------------------------------------------------
COMMIT;

--------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------
/* 5. Create views */
--------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW available_lots AS
-- This view compiles information each available lot using its many FKs, resulting
-- in a user-friendly view of all the lots and their information. The sales
-- manager is the most likely user of this view.
    SELECT
        lot.lot_id,
        lot.street||' '||lot.city||' '||lot.state||' '||lot.zip AS usps_address,
        lot.status AS lot_status,
        hs.style_name,
        hs.style_description,
        e.elevation_name,
        e.elevation_description,
        lot.lot_premium,
        lot.lot_size,
        lot.is_reverse,
        sub.subdivision_name,
        sd.district_name AS school_district
    FROM lot 
    LEFT JOIN subdivision sub ON lot.subdivision_subdivision_id = sub.subdivision_id
    LEFT JOIN school_district sd ON sub.school_district_district_id = sd.district_id
    LEFT JOIN elevation e ON lot.elevation_elevation_id = e.elevation_id
    LEFT JOIN house_style hs ON lot.house_style_style_id = hs.style_id
    WHERE lot.status = 'Available'
    ORDER BY lot_premium ASC
;

CREATE OR REPLACE VIEW employee_stats AS
-- This view deliberately hides the salary information of each employee and only
-- reports on the number of contracts they are currently responsible for managing.
-- HR and upper-level management are the most likely users of this view.
WITH employee_contracts AS (
    SELECT
        e.employee_id,
        e.first_name||' '||e.last_name AS employee_name,
        e.title,
        c.contract_id,
        c.sale_sale_id
    FROM employee e, contract c
    WHERE e.employee_id = c.employee_employee_id
)
SELECT
    employee_id, employee_name, title,
    COUNT(DISTINCT contract_id) AS num_contracts,
    COUNT(DISTINCT sale_sale_id) AS num_sales
FROM employee_contracts
GROUP BY employee_id, employee_name, title
ORDER BY employee_id
;

--------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------
/* 6. Create database roles */
--------------------------------------------------------------------------------------------------------------------------------
DROP ROLE sales_manager_g1;
DROP ROLE construction_manager_g1;

-- The sales manager role only needs to access tables/views having to do with sales and contracts
CREATE ROLE sales_manager_g1;
GRANT SELECT, INSERT, UPDATE, DELETE ON sale TO sales_manager_g1;
GRANT SELECT, INSERT, UPDATE, DELETE ON contract TO sales_manager_g1;
GRANT SELECT ON available_lots TO sales_manager_g1;
GRANT SELECT ON employee_stats TO sales_manager_g1;

-- The construction manager role only needs to access tables/views having to do with active house
-- construction. They are responsible for updating house progress and decorator choices. They may
-- need to view data regarding the lot or the lookup tables for construction_stage and
-- decorator_option, so they are granted read-only privileges on those tables.
CREATE ROLE construction_manager_g1;
GRANT SELECT, INSERT, UPDATE, DELETE ON house_progress TO construction_manager_g1;
GRANT SELECT, INSERT, UPDATE, DELETE ON decorator_choice TO construction_manager_g1;
GRANT SELECT, UPDATE ON contract TO construction_manager_g1;
GRANT SELECT ON lot TO construction_manager_g1;
GRANT SELECT ON subdivision TO construction_manager_g1;
GRANT SELECT ON construction_stage TO construction_manager_g1;
GRANT SELECT ON decorator_option TO construction_manager_g1;

--------------------------------------------------------------------------------------------------------------------------------
/* 7. Create package with additional database objects */
--------------------------------------------------------------------------------------------------------------------------------

/*
Package Structure:

Function:
    - calc_total_contract_price

Procedures:
    - add_buyer
    - add_sale
    - add_contract
    - mark_lot_sold
    - add_decorator_choice
    - update_existing_contract_status
    - update_progress_stage
    - generate_constr_prog_report
    - generate_sales_report
*/

-- PACKAGE: EGGSHELL HOMEBUILDER MAIN LOGIC

CREATE OR REPLACE PACKAGE g1_eggshellHomebuilder_pkg AS
/*
    The purpose of this package is to contain all business logic for the Buyer, Contract, Sale, Construction_Stage, and
    Decorator_Choice Entities. It also adds reporting views.
*/
    -- Add the buyer
   PROCEDURE add_buyer(
      p_first_name   IN buyer.first_name%type,
      p_last_name    IN buyer.last_name%type,
      p_phone        IN buyer.phone%type,
      p_email        IN buyer.email%type,
      p_street       IN buyer.street%type,
      p_city         IN buyer.city%type,
      p_state        IN buyer.state%type,
      p_zip          IN buyer.zip%type,
      p_bank_id      IN bank.bank_id%type
   );

   -- Sale logic
   PROCEDURE add_sale(
      p_sale_date                     IN DATE DEFAULT SYSDATE,
      p_receipt_subdivision_agreement IN BINARY_FLOAT,
      p_receipt_disclosure_form       IN BINARY_FLOAT,
      p_receipt_contract              IN BINARY_FLOAT
   );

   -- Contract logic
   PROCEDURE add_contract(
      p_lot_id          IN NUMBER,
      p_buyer_id        IN NUMBER,
      p_employee_id     IN NUMBER,
      p_sale_id         IN NUMBER,
      p_base_price      IN NUMBER,
      p_escrow_amount   IN NUMBER,
      p_finance_method  IN VARCHAR2
   );

   -- Lot management
   PROCEDURE mark_lot_sold(p_lot_id IN NUMBER);

   -- Decorator / construction / contract management
   PROCEDURE add_decorator_choice(
     p_lot_id IN decorator_choice.lot_lot_id%TYPE, 
     p_option_id IN decorator_choice.option_option_id%TYPE,
     p_date IN decorator_choice.choice_date%TYPE,
     p_comments IN decorator_choice.comments%TYPE
   );

   PROCEDURE update_existing_contract_status(
        p_contract_id IN contract.contract_id%TYPE,
        p_new_status  IN contract.contract_status%TYPE,
        p_date IN contract.completion_date%TYPE
   );

   PROCEDURE update_progress_stage(
        p_lot_id IN house_progress.lot_lot_id%TYPE, 
        p_date IN house_progress.date_completed%TYPE
   );
   
   -- b. Function
   FUNCTION calc_total_contract_price(
      p_contract_id IN NUMBER
   ) RETURN NUMBER;

   -- c. Reports
   PROCEDURE generate_constr_prog_report;
   PROCEDURE generate_sales_report;

END g1_eggshellHomebuilder_pkg;
/


-- PACKAGE: EGGSHELL HOMEBUILDER BODY
CREATE OR REPLACE PACKAGE BODY g1_eggshellHomebuilder_pkg AS

   --
   -- PROCEDURE to add_buyer
   PROCEDURE add_buyer(
      p_first_name   IN buyer.first_name%type,
      p_last_name    IN buyer.last_name%type,
      p_phone        IN buyer.phone%type,
      p_email        IN buyer.email%type,
      p_street       IN buyer.street%type,
      p_city         IN buyer.city%type,
      p_state        IN buyer.state%type,
      p_zip          IN buyer.zip%type,
      p_bank_id      IN bank.bank_id%type
   )
   IS
   BEGIN
      INSERT INTO Buyer (
         Buyer_ID, First_Name, Last_Name, Phone, Email,
         Street, City, State, ZIP, Bank_Bank_ID
      )
      VALUES (
         buyer_sequence.NEXTVAL, p_first_name, p_last_name, p_phone, p_email,
         p_street, p_city, p_state, p_zip, p_bank_id
      );
      DBMS_OUTPUT.PUT_LINE('Buyer ' || p_first_name || ' ' || p_last_name || ' successfully added.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error adding buyer: ' || SQLERRM);
   END add_buyer;
------------------------------------------------------------------------------------------------------------------------------

   -- PROCEDURE to add_sale
   PROCEDURE add_sale(
      p_sale_date                     IN DATE DEFAULT SYSDATE,
      p_receipt_subdivision_agreement IN BINARY_FLOAT,
      p_receipt_disclosure_form       IN BINARY_FLOAT,
      p_receipt_contract              IN BINARY_FLOAT
   )
   IS
   BEGIN
      INSERT INTO Sale (
         Sale_ID, "Date", Receipt_Subdivision_Agreement,
         Receipt_Disclosure_Form, Receipt_Contract
      )
      VALUES (
         sale_sequence.NEXTVAL, p_sale_date,
         p_receipt_subdivision_agreement,
         p_receipt_disclosure_form,
         p_receipt_contract
      );
      DBMS_OUTPUT.PUT_LINE('Sale ' || ' record created.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error adding sale: ' || SQLERRM);
   END add_sale;

--------------------------------------------------------------------------------------------------------------------------------
-- Procedure to Calculate Total Contract Price
    -- Function: Calculate total contract/sale price
    -- Parameters(p_contract_id)
    -- Actions: 
    ------ retrieve base price and additional cost of choen options from the contract table
    ------ retrieve the additional cost from the elevation table
    ------ retrieve the lot premium from the lot table
    ------ return the final computed contract price
    FUNCTION calc_total_contract_price(p_contract_id IN NUMBER)
    RETURN NUMBER
        IS v_total NUMBER;
    BEGIN
        SELECT (c.Base_Price
               + NVL(c.Additional_Cost,0)
               + NVL(l.Lot_Premium,0)
               + NVL(e.Additional_Cost,0))
        INTO v_total
        FROM Contract c
        JOIN Lot l ON c.Lot_Lot_ID = l.Lot_ID
        LEFT JOIN Elevation e ON l.Elevation_Elevation_ID = e.Elevation_ID
        WHERE c.Contract_ID = p_contract_id;
    
        RETURN v_total;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No matching contract found for ID ' || p_contract_id);
            RETURN NULL;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error calculating total price for contract: ' || p_contract_id);
            RETURN NULL;
    END;
--------------------------------------------------------------------------------------------------------------------------------
-- PROCEDURE: ADD_CONTRACT
    PROCEDURE add_contract(
       p_lot_id         IN NUMBER,
       p_buyer_id       IN NUMBER,
       p_employee_id    IN NUMBER,
       p_sale_id        IN NUMBER,
       p_base_price     IN NUMBER,
       p_escrow_amount  IN NUMBER,
       p_finance_method IN VARCHAR2
    ) IS
       v_estimated_completion_date DATE := ADD_MONTHS(SYSDATE, 8);
       v_expiration_date DATE := ADD_MONTHS(SYSDATE, 9);
    BEGIN
       INSERT INTO contract (
          contract_id, signed_date, base_price, escrow_amount,
          estimated_completion_date, expiration_date,
          contract_status, finance_method, lot_lot_id,
          sale_sale_id, buyer_buyer_id, employee_employee_id
       ) VALUES (
          contract_sequence.NEXTVAL, SYSDATE, p_base_price, p_escrow_amount,
          v_estimated_completion_date, v_expiration_date,
          'Active', p_finance_method, p_lot_id, p_sale_id,
          p_buyer_id, p_employee_id
       );
    
       DBMS_OUTPUT.PUT_LINE('Contract successfully created for Buyer ID ' || p_buyer_id);
    EXCEPTION
       WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('Error adding contract: ' || SQLERRM);
    END add_contract;


--------------------------------------------------------------------------------------------------------------------------------
-- 6. PROCEDURE: MARK_LOT_SOLD

    PROCEDURE mark_lot_sold(p_lot_id IN NUMBER) IS
    BEGIN
       UPDATE lot
          SET status = 'Sold'
        WHERE lot_id = p_lot_id;
    
       DBMS_OUTPUT.PUT_LINE('Lot ' || p_lot_id || ' marked as SOLD.');
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
          DBMS_OUTPUT.PUT_LINE('Lot with ' || p_lot_id || ' not found');
       WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('Error marking lot sold: ' || SQLERRM);
    END mark_lot_sold;


--------------------------------------------------------------------------------------------------------------------------------
-- Procedure: Add decorator choice
-- Parameters(p_lot_id, p_option_id, p_date, p_comments)
-- Actions: 
------ check that current stage is 1, 4, or 7
------ add new record to decorator choice table
------ get stage price and update additional_costs in contract table
-- Assumptions: 
------ if option chosen previously, even in different stage, cannot be chosen again
    PROCEDURE add_decorator_choice(p_lot_id IN decorator_choice.lot_lot_id%TYPE, 
                                   p_option_id IN decorator_choice.option_option_id%TYPE,
                                   p_date IN decorator_choice.choice_date%TYPE,
                                   p_comments IN decorator_choice.comments%TYPE)
    IS
    e_invalid_lot EXCEPTION;
    e_invalid_date EXCEPTION;
    e_no_choices_stage EXCEPTION;
    e_choice_not_in_stage EXCEPTION;
    
    current_status VARCHAR2(242);
    contract_record contract%ROWTYPE;
    current_stage NUMBER;
    choice_price NUMBER;
    total_additional_cost NUMBER;
    option_record decorator_option%ROWTYPE;
    
    BEGIN
    
       SELECT status INTO current_status
         FROM lot
        WHERE lot_id = p_lot_id;
        
       SELECT * INTO contract_record
         FROM contract 
        WHERE lot_lot_id = p_lot_id 
              AND LOWER(contract_status) = 'active';
        
        IF current_status IS NULL THEN
          RAISE NO_DATA_FOUND;
        -- check that lot is under construction
        ELSIF LOWER(current_status) != 'under construction' THEN
          RAISE e_invalid_lot;
        -- check that date parameter comes after construction start date
        ELSIF p_date < contract_record.signed_date THEN
          RAISE e_invalid_date;
        
        ELSE
         -- get current stage
         SELECT construction_stage_stage_id INTO current_stage
           FROM house_progress
          WHERE lot_lot_id = p_lot_id
          ORDER BY stage_start_date DESC
          FETCH FIRST 1 ROW ONLY;
          
         -- check if current stage is 1, 4, or 7
         IF current_stage NOT IN (1, 4, 7) THEN
          RAISE e_no_choices_stage;
         END IF;
         
         -- check if choice can be made in current stage (price is non-null)
         SELECT * INTO option_record
           FROM decorator_option
          WHERE option_id = p_option_id;
          
         IF current_stage = 1 THEN
           choice_price := option_record.stage1_price;
         ELSIF current_stage = 4 THEN
           choice_price := option_record.stage4_price;
         ELSIF current_stage = 7 THEN
           choice_price := option_record.stage7_price;
         END IF;
         
         IF choice_price IS NULL THEN
          RAISE e_choice_not_in_stage;
         END IF;
         
         -- create new record in decorator choice table
         INSERT INTO decorator_choice (choice_id, choice_date, comments, lot_lot_id, option_option_id) 
                     VALUES (decorator_choice_sequence.NEXTVAL, p_date, p_comments, p_lot_id, p_option_id);
        
         -- update additional_cost in contract table to account for choice price
         total_additional_cost := COALESCE(contract_record.additional_cost, 0) + choice_price;
         UPDATE contract
            SET additional_cost = total_additional_cost
          WHERE lot_lot_id = p_lot_id;
          
         -- print out option details and price + cumulative cost of choices to date
         DBMS_OUTPUT.PUT_LINE('' || option_record.category || ' | ' || option_record.option_name || ' in ' || option_record.room || ' added to decorator choices for lot ' || p_lot_id);
         DBMS_OUTPUT.PUT_LINE('This choice costs $' || choice_price);
         DBMS_OUTPUT.PUT_LINE('Cumulative additional costs for lot ' || p_lot_id || ' are now $' || total_additional_cost);
         
        END IF;
        
    EXCEPTION
       
       WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('Lot not found');
         
       WHEN e_invalid_lot THEN
         DBMS_OUTPUT.PUT_LINE('Specified lot is not under construction.');
    
       WHEN e_invalid_date THEN
         DBMS_OUTPUT.PUT_LINE('Invalid date. Active contract for specified lot began on ' || contract_record.signed_date);
         
       WHEN e_no_choices_stage THEN
         DBMS_OUTPUT.PUT_LINE('Decorator choices can only be made in stages 1, 4, and 7. Lot ' || p_lot_id || ' is in stage ' || current_stage);
         
       WHEN e_choice_not_in_stage THEN
         DBMS_OUTPUT.PUT_LINE('Decorator choice ' || p_option_id || ' cannot be made in stage ' || current_stage);
    
       WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('The PLSQL procedure executed by '|| USER ||' returned an unhandled exception on '|| SYSDATE);
    END add_decorator_choice;  


--------------------------------------------------------------------------------------------------------------------------------
-- 8. PROCEDURE: UPDATE_EXISTING_CONTRACT_STATUS

    -- Procedure: Update existing contract status 
    -- Parameters(p_contract_ID, p_new_status, p_date)
    -- Actions: 
    ------ get current contract status
    ------ get lot information
    ------ check that contract exists
    ------ check that changing status is allowed
    ------ check that new status is valid
    ------ update contract table to reflect new status
    ------ when new status is 'completed', update contract completion date and update lot status to 'under negotiation' 
    ------ when new status is 'cancelled', update lot table to show that lot is available again
    -- Assumptions: 
    ------  if completed, cannott be cancelled

   PROCEDURE update_existing_contract_status(p_contract_id IN contract.contract_id%TYPE, 
                                             p_new_status  IN contract.contract_status%TYPE,
                                             p_date IN contract.completion_date%TYPE)
    IS

    e_invalid_status EXCEPTION;
    e_no_update_allowed EXCEPTION;
    
    contract_record contract%ROWTYPE;
    
    BEGIN
       -- get current contract status and lot id from contract record
       SELECT * INTO contract_record
         FROM contract
        WHERE contract_id = p_contract_id;
        
       -- check that contract exists
       IF contract_record.contract_status IS NULL THEN
         RAISE NO_DATA_FOUND;
       -- check that changing status is allowed
       ELSIF LOWER(contract_record.contract_status) != 'active' THEN
         RAISE e_no_update_allowed;
       -- check that new status is valid
       ELSIF LOWER(p_new_status) NOT IN ('active', 'cancelled', 'completed', 'expired') THEN
         RAISE e_invalid_status;
         
       ELSE
         -- update contract table to reflect new status
         UPDATE contract
            SET contract_status = p_new_status
          WHERE contract_id = p_contract_id;
          DBMS_OUTPUT.PUT_LINE('Contract ' || p_contract_id || ' status updated from ' || contract_record.contract_status || ' to ' || p_new_status || ' - effective ' || p_date);
          DBMS_OUTPUT.NEW_LINE;
         
         -- when p_new_status is completed, update contract completion date and update lot status to under negotiation 
         IF LOWER(p_new_status) = 'completed' THEN
            UPDATE contract
               SET completion_date = p_date
             WHERE contract_id = p_contract_id;
            UPDATE lot
               SET status = 'Under negotiation'
             WHERE lot_id = contract_record.lot_lot_id;
            DBMS_OUTPUT.PUT_LINE('Lot ' || contract_record.lot_lot_id || ' status updated from Under Construction to Under Negotiation - effective ' || p_date);
            DBMS_OUTPUT.NEW_LINE;
         END IF;
         
         -- when p_new_status is cancelled, update lot table to show that lot is available again
         IF LOWER(p_new_status) = 'cancelled' THEN
            UPDATE lot
               SET status = 'Available'
             WHERE lot_id = contract_record.lot_lot_id;
            DBMS_OUTPUT.PUT_LINE('Lot ' || contract_record.lot_lot_id || ' status updated from Under Construction to Available - effective ' || p_date);
            DBMS_OUTPUT.NEW_LINE;
         END IF;
       END IF;
       COMMIT;
    EXCEPTION
       
       WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('Contract not found');
         
       WHEN e_invalid_status THEN
         DBMS_OUTPUT.PUT_LINE('Specified status is not valid. Status must be active, completed, cancelled, or expired');
    
       WHEN e_no_update_allowed THEN
         DBMS_OUTPUT.PUT_LINE('Selected contract has current status: '|| contract_record.contract_status);
         DBMS_OUTPUT.PUT_LINE('It cannot be updated to '|| p_new_status);
    
       WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('The PLSQL procedure executed by '|| USER ||' returned an unhandled exception on '|| SYSDATE);
    END update_existing_contract_status;  

--------------------------------------------------------------------------------------------------------------------------------
-- 9. PROCEDURE: UPDATE_PROGRESS_STAGE

    -- Parameters(p_lot_id, p_date)
    -- Actions: 
    ------ check that lot is under construction
    ------ determine next stage
    ------ if prior stage is stage 7, mark construction complete by calling update_contract_status procedure
    ------ otherwise:
    ------    calculate and store estimated completion date for next stage
    ------    add new record to house progress table for next stage
    ------ update existing record for prior stage with date completed
    -- Assumptions: 
    ------ previous stage ends on same day that next stage starts; 
    ------ house must go through all 7 stages, 
    ------ cannot return to past stage or skip a stage

   PROCEDURE update_progress_stage(p_lot_id IN house_progress.lot_lot_id%TYPE, 
                                   p_date IN house_progress.date_completed%TYPE)
    IS

        e_invalid_lot EXCEPTION;
        e_invalid_date EXCEPTION;
        current_status VARCHAR2(242);
        contract_record contract%ROWTYPE;
        started_date DATE;
        latest_stage NUMBER;
        progress_record house_progress%ROWTYPE;
        next_stage NUMBER;
        latest_complete_time NUMBER;
        incurred_costs NUMBER;
        next_complete_time NUMBER;
        est_date DATE;

    BEGIN
       SELECT status INTO current_status
         FROM lot
        WHERE lot_id = p_lot_id;
        
       SELECT * INTO contract_record
         FROM contract 
        WHERE lot_lot_id = p_lot_id AND LOWER(contract_status) = 'active';
       
       IF current_status IS NULL THEN
         RAISE NO_DATA_FOUND;
       -- check that lot is under construction
       ELSIF LOWER(current_status) != 'under construction' THEN
         RAISE e_invalid_lot;
       -- check that date parameter comes after construction start date
       ELSIF p_date < contract_record.signed_date THEN
         RAISE e_invalid_date;
       ELSE
         -- get the latest stage for lot
         SELECT * INTO progress_record
           FROM house_progress
          WHERE lot_lot_id = p_lot_id
          ORDER BY construction_stage_stage_id DESC, stage_start_date DESC
          FETCH FIRST 1 ROWS ONLY;
         started_date := progress_record.stage_start_date;
         latest_stage := progress_record.construction_stage_stage_id;
         -- store next stage
         next_stage := latest_stage + 1;
         -- update record for previous stage to reflect date completed
         UPDATE house_progress
            SET date_completed = p_date
          WHERE lot_lot_id = p_lot_id AND 
                construction_stage_stage_id = latest_stage AND 
                stage_start_date = contract_record.signed_date;
         -- calculate actual time it took to complete latest stage
         latest_complete_time := p_date - started_date;
         DBMS_OUTPUT.PUT_LINE('Lot ' || p_lot_id || ' construction progress updated from stage '|| latest_stage || ' to stage ' || next_stage || ' on ' || p_date);
         DBMS_OUTPUT.PUT_LINE('Stage ' || latest_stage || ' completed in '|| latest_complete_time || ' days');
         
         -- calculate incurred costs for decorator choices made during latest stage
         IF latest_stage IN (1, 4, 7) THEN
            SELECT SUM(COALESCE(stage1_price,0) + COALESCE(stage4_price,0) + COALESCE(stage7_price,0)) INTO incurred_costs
              FROM decorator_choice dc JOIN decorator_option do ON dc.option_option_id = do.option_id
             WHERE lot_lot_id = p_lot_id AND choice_date BETWEEN started_date AND p_date;
            DBMS_OUTPUT.PUT_LINE('During stage ' || latest_stage || ', incurred costs of $'|| incurred_costs);
            DBMS_OUTPUT.NEW_LINE;
         END IF;   
         IF latest_stage = 7 THEN
           update_existing_contract_status(contract_record.contract_id, 'completed', p_date);
           DBMS_OUTPUT.PUT_LINE('The overall estimated completion date for lot ' || p_lot_id || ' under contract ' || contract_record.contract_id || ' was ' || contract_record.estimated_completion_date);
           DBMS_OUTPUT.PUT_LINE('and the actual completion date was ' || p_date);
         ELSE
          -- get estimated time to complete next stage
          SELECT est_complete_time INTO next_complete_time
            FROM construction_stage
           WHERE stage_id = next_stage;
          -- calculated estimated stage completion date (next_complete_time is int representing weeks)
          est_date := p_date + (7*next_complete_time);
          -- create new record in house progress table
          INSERT INTO house_progress (progress_report_id, stage_start_date, estimated_completion_date, date_completed, lot_lot_id, construction_stage_stage_id) 
                 VALUES (house_progress_sequence.NEXTVAL, p_date, est_date, NULL, p_lot_id, next_stage);
          DBMS_OUTPUT.PUT_LINE('Stage ' || next_stage || ' is estimated to complete in ' || next_complete_time || ' days, by '|| est_date);
          DBMS_OUTPUT.PUT_LINE('The overall estimated completion date for lot ' || p_lot_id || ' under contract ' || contract_record.contract_id || ' is ' || contract_record.estimated_completion_date);
          DBMS_OUTPUT.NEW_LINE;
         END IF;
       END IF;
       
    EXCEPTION
       
       WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('Lot not found');
         
       WHEN e_invalid_lot THEN
         DBMS_OUTPUT.PUT_LINE('Specified lot is not under construction.');
    
       WHEN e_invalid_date THEN
         DBMS_OUTPUT.PUT_LINE('Invalid date. Active contract for specified lot began on ' || contract_record.signed_date);
    
       WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('The PLSQL procedure executed by '|| USER ||' returned an unhandled exception on '|| SYSDATE);
    END update_progress_stage; 
    
        
--------------------------------------------------------------------------------------------------------------------------------
-- 10. PROCEDURE: GENERATE_CONSTR_PROG_REPORT
/*
    Construction Progress Report for ALL properties currently under construction.
    Only applies to lots that are currently under construction.
    Only retrieves the current stage of the construction progress.
    Joins the House_Progress, Construction_Stage, Lot, and Subdivision tables to mostly reproduce
    the report on page 531 of the case study.
*/
    PROCEDURE generate_constr_prog_report IS
    CURSOR c_progress IS
        SELECT city, subdivision_name, lot_lot_id, stage_name, stage_description, stage_start_date, estimated_completion_date
        FROM (
            SELECT
                lt.city,
                sd.subdivision_name,
                hp.lot_lot_id,
                cs.stage_name,
                cs.stage_description,
                lt.status,
                hp.stage_start_date,
                hp.estimated_completion_date,
                ROW_NUMBER() OVER (PARTITION BY hp.lot_lot_id ORDER BY hp.stage_start_date DESC) AS row_num
            FROM house_progress hp
            LEFT JOIN construction_stage cs ON hp.construction_stage_stage_id = cs.stage_id
            LEFT JOIN lot lt ON hp.lot_lot_id = lt.lot_id
            LEFT JOIN subdivision sd ON lt.subdivision_subdivision_id = sd.subdivision_id
        )
        WHERE row_num = 1 AND status = 'Under Construction';
        v_city lot.city%TYPE;
        v_subdivision_name subdivision.subdivision_name%TYPE;
        v_lot_lot_id house_progress.lot_lot_id%TYPE;
        v_stage_name construction_stage.stage_name%TYPE;
        v_stage_description construction_stage.stage_description%TYPE;
        v_stage_start_date house_progress.stage_start_date%TYPE;
        v_estimated_completion_date house_progress.estimated_completion_date%TYPE;
    BEGIN
        OPEN c_progress;
        LOOP
            FETCH c_progress
            INTO v_city, v_subdivision_name, v_lot_lot_id, v_stage_name, v_stage_description, 
                 v_stage_start_date, v_estimated_completion_date;
            EXIT WHEN c_progress%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('+--------------------- G1 CONSTRUCTION PROGRESS REPORT ------------------------+');
            DBMS_OUTPUT.PUT_LINE('City: '||v_city);
            DBMS_OUTPUT.PUT_LINE('Subdivision: '||v_subdivision_name);
            DBMS_OUTPUT.PUT_LINE('Lot ID: '||v_lot_lot_id);
            DBMS_OUTPUT.PUT_LINE('   ~~~                                ~~~                                 ~~~   ');
            DBMS_OUTPUT.PUT_LINE('Report Date: '||TO_CHAR(sysdate, 'FMMonth DD, YYYY HH:MI:SS AM'));
            DBMS_OUTPUT.PUT_LINE(RPAD('Current Stage: '||v_stage_name, 40)||LPAD('Stage Start Date: '||TO_CHAR(v_stage_start_date, 'FMMonth DD, YYYY'), 40));
            DBMS_OUTPUT.PUT_LINE('Stage Details: '||v_stage_description);
            DBMS_OUTPUT.PUT_LINE('Estimated Completion Date: '||TO_CHAR(v_estimated_completion_date, 'FMMonth DD, YYYY'));
            DBMS_OUTPUT.PUT_LINE('+------------------------------------------------------------------------------+');
            DBMS_OUTPUT.NEW_LINE();
        END LOOP;
        CLOSE c_progress;

END generate_constr_prog_report;
------------------------------------------------------------------------
-- 11. PROCEDURE: GENERATE_SALES_REPORT
    /*
    Joins several tables to get the information for ALL sales.
    to mostly reproduce the report on page 532 of the case study.
    */
    
    PROCEDURE generate_sales_report IS
        CURSOR c_sale IS
         SELECT 
            sl."Date" AS sale_date,
            CASE WHEN sl.receipt_subdivision_agreement = 1 THEN 'Yes' ELSE 'No' END AS rec_subdv_agrmt,
            CASE WHEN sl.receipt_disclosure_form = 1 THEN 'Yes' ELSE 'No' END AS rec_discl_form,
            CASE WHEN sl.receipt_contract = 1 THEN 'Yes' ELSE 'No' END AS rec_contract,
            ct.lot_lot_id,
            ct.employee_employee_id,
            ct.estimated_completion_date,
            lt.street||' '||lt.city||', '||lt.state||' '||lt.zip AS lot_address,
            lt.lot_size,
            lt.lot_premium,
            hs.style_name,
            el.elevation_name,
            sd.subdivision_id,
            sd.subdivision_name,
            br.first_name||' '||br.last_name AS buyer_name,
            br.street||' '||br.city||', '||br.state||' '||br.zip AS buyer_address,
            bk.bank_name,
            bk.street||' '||bk.city||', '||bk.state||' '||bk.zip AS bank_address,
            bk.phone,
            bk.fax,
            ep.first_name||' '||ep.last_name AS employee_name,
            ea.license_no
        FROM sale sl
        LEFT JOIN contract ct ON sl.sale_id = ct.sale_sale_id
        LEFT JOIN lot lt ON ct.lot_lot_id = lt.lot_id
        LEFT JOIN house_style hs ON lt.house_style_style_id = hs.style_id
        LEFT JOIN elevation el ON lt.elevation_elevation_id = el.elevation_id
        LEFT JOIN subdivision sd ON lt.subdivision_subdivision_id = sd.subdivision_id
        LEFT JOIN buyer br ON ct.buyer_buyer_id = br.buyer_id
        LEFT JOIN bank bk ON br.bank_bank_id = bk.bank_id
        LEFT JOIN employee ep ON ct.employee_employee_id = ep.employee_id
        LEFT JOIN escrow_agent ea ON ea.employee_id = ep.employee_id;
        v_sale_date sale."Date"%TYPE;
        v_rec_subdv_agrmt VARCHAR(3);
        v_rec_discl_form VARCHAR(3);
        v_rec_contract VARCHAR(3);
        v_lot_id contract.lot_lot_id%TYPE;
        v_employee_id contract.employee_employee_id%TYPE;
        v_est_compl_date contract.estimated_completion_date%TYPE;
        v_lot_address VARCHAR(50);
        v_lot_size lot.lot_size%TYPE;
        v_lot_premium lot.lot_premium%TYPE;
        v_house_style_name house_style.style_name%TYPE;
        v_elevation_name elevation.elevation_name%TYPE;
        v_subdiv_id subdivision.subdivision_id%TYPE;
        v_subdiv_name subdivision.subdivision_name%TYPE;
        v_buyer_name VARCHAR(25);
        v_buyer_address VARCHAR(50);
        v_bank_name bank.bank_name%TYPE;
        v_bank_address VARCHAR(50);
        v_bank_phone bank.phone%TYPE;
        v_bank_fax bank.fax%TYPE;
        v_employee_name VARCHAR(25);
        v_license_no escrow_agent.license_no%TYPE;
    BEGIN
    OPEN c_sale;
    LOOP
        FETCH c_sale
        INTO v_sale_date, v_rec_subdv_agrmt, v_rec_discl_form, v_rec_contract, v_lot_id, 
             v_employee_id, v_est_compl_date, v_lot_address, v_lot_size, v_lot_premium,
             v_house_style_name, v_elevation_name, v_subdiv_id, v_subdiv_name, v_buyer_name,
             v_buyer_address, v_bank_name, v_bank_address, v_bank_phone, v_bank_fax,
             v_employee_name, v_license_no;
        EXIT WHEN c_sale%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('+-------------------------------------- G1 SALES REPORT ------------------------------------------+');
        DBMS_OUTPUT.PUT_LINE('Report Date: '||TO_CHAR(sysdate, 'FMMonth DD, YYYY HH:MI:SS AM'));
        DBMS_OUTPUT.PUT_LINE(RPAD('Customer Name: '||v_buyer_name, 50)||RPAD('Agent: '||v_employee_name, 50));
        DBMS_OUTPUT.PUT_LINE(RPAD('Address: '||v_buyer_address, 50)||RPAD('License No. '||v_license_no, 50));
        DBMS_OUTPUT.NEW_LINE();
        DBMS_OUTPUT.PUT_LINE('Subdivision ID: '||v_subdiv_id);
        DBMS_OUTPUT.PUT_LINE('Subdivision Name: '||v_subdiv_name);
        DBMS_OUTPUT.NEW_LINE();
        DBMS_OUTPUT.PUT_LINE(RPAD('Lot ID: '||v_lot_id, 50)||RPAD('Lot Size (sq. ft.): '||v_lot_size, 50));
        DBMS_OUTPUT.PUT_LINE(RPAD('Address: '||v_lot_address, 50)||RPAD('Lot Premium: $'||v_lot_premium, 50));
        DBMS_OUTPUT.PUT_LINE(RPAD('House Style: '||v_house_style_name, 50)||RPAD('Est. Completion Date: '||TO_CHAR(v_est_compl_date, 'FMMonth DD, YYYY'), 50));
        DBMS_OUTPUT.PUT_LINE(RPAD('Elevation: '||v_elevation_name, 50));
        DBMS_OUTPUT.NEW_LINE();
        DBMS_OUTPUT.PUT_LINE(RPAD('Bank Name: '||v_bank_name, 50)||RPAD('Phone: '||v_bank_phone, 50));
        DBMS_OUTPUT.PUT_LINE(RPAD('Address: '||v_bank_address, 50)||RPAD('Fax: '||v_bank_fax, 50));        
        DBMS_OUTPUT.NEW_LINE();
        DBMS_OUTPUT.PUT_LINE('Buyer received copies of:');
        DBMS_OUTPUT.PUT_LINE('Subdivision Agreement: '||v_rec_subdv_agrmt);
        DBMS_OUTPUT.PUT_LINE('Disclosure Form: '||v_rec_discl_form);
        DBMS_OUTPUT.PUT_LINE('Contract: '||v_rec_contract);
        DBMS_OUTPUT.PUT_LINE('+--------------------------------------------------------------------------------------------------+');
        DBMS_OUTPUT.NEW_LINE();
    END LOOP;
    CLOSE c_sale;

END generate_sales_report;

END g1_eggshellHomebuilder_pkg;
/
/* End of package */
--------------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------------
/* 8. Triggers */
--------------------------------------------------------------------------------------------------------------------------------

-- Trigger to prevent negative money values in Contract table
CREATE OR REPLACE TRIGGER trg_prevent_negative_money
BEFORE INSERT OR UPDATE ON Contract   -- Trigger will fire before inserting or updating a contract
FOR EACH ROW
BEGIN
   -- Check base price
   IF :NEW.BASE_PRICE < 0 THEN
      RAISE_APPLICATION_ERROR(-20005, 'Base price cannot be negative.');
   END IF;

   -- Check escrow amount
   IF :NEW.ESCROW_AMOUNT < 0 THEN
      RAISE_APPLICATION_ERROR(-20006, 'Escrow amount cannot be negative.');
   END IF;
END;
/

-- Trigger to prevent creating a contract for a lot that is already sold
CREATE OR REPLACE TRIGGER trg_prevent_double_sale
BEFORE INSERT ON Contract
FOR EACH ROW
DECLARE
   v_status VARCHAR2(20);
BEGIN
   SELECT Status
   INTO v_status
   FROM Lot
   WHERE Lot_ID = :NEW.LOT_LOT_ID;   -- foreign key from Contract to Lot

-- If the lot is already sold, then prevent the insert and raise an error
   IF UPPER(v_status) NOT LIKE 'AVAILABLE' THEN
      RAISE_APPLICATION_ERROR(-20004, 'This lot has already been sold. Cannot create another contract.');
   END IF;
END;
/

--------------------------------------------------------------------------------------------------------------------------------
/* 9. Schedule a job (report generation) */
--------------------------------------------------------------------------------------------------------------------------------

-- Job to generate a Construction Progress Report for ALL properties currently under construction
BEGIN
   DBMS_SCHEDULER.DROP_JOB (
      job_name => 'PROGRESS_REPORT',
      defer    => TRUE
   );
END;
/
CREATE OR REPLACE PROCEDURE schedule_progress_report (
    p_start_date      IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP,
    p_repeat_interval IN VARCHAR2 DEFAULT 'FREQ=DAILY; BYHOUR=9;'
)
AS
BEGIN
  DBMS_SCHEDULER.CREATE_JOB (
    job_name        => 'PROGRESS_REPORT',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'BEGIN g1_eggshellHomebuilder_pkg.generate_constr_prog_report; END;',
    start_date      => p_start_date,
    repeat_interval => p_repeat_interval,
    enabled         => TRUE,
    comments        => 'Generates the Construction Progress Report for ALL properties currently under construction, daily at 9am.'
  );
END;
/

execute schedule_progress_report();
--------------------------------------------------------------------------------------------------------------------------------
