-- User Guide Code
-- Team 1
-- This script includes example code for demonstrating database use cases and object test cases

SET SERVEROUTPUT ON;

/* Scenario 1 - Determine which lots are still available for new potential buyers*/
SELECT * FROM available_lots;

/* Scenario 2 - Check that status of all active builds */
BEGIN
   DBMS_SCHEDULER.DROP_JOB (
      job_name => 'PROGRESS_REPORT',
      defer    => TRUE
   );
END;
/
execute schedule_progress_report(SYSTIMESTAMP, 'FREQ=MINUTELY;');
execute g1_eggshellHomebuilder_pkg.generate_constr_prog_report;

/* Scenario 3 - Track the construction progress of an individual project */
execute g1_eggshellHomebuilder_pkg.update_progress_stage(101001, SYSTIMESTAMP);

/* Scenario 4 - Record a buyer’s design choices throughout construction */
execute g1_eggshellHomebuilder_pkg.add_decorator_choice(107001, 108003, SYSTIMESTAMP, 'Customer cares a lot about this.');

/* Scenario 5 - Review details of all completed sales */
execute g1_eggshellHomebuilder_pkg.generate_sales_report;

/* Scenario 6 - Identify employee performance with respect to sales */
SELECT * FROM employee_stats;

--------------------------------------------------------------------------------------------------------------------------------

/* Additional example use cases */
-- explicitly update a contract status
execute g1_eggshellHomebuilder_pkg.update_existing_contract_status(105001, 'Completed', '31-AUG-24');

-- function to get final price of constructed house
BEGIN
  DBMS_OUTPUT.PUT_LINE('Total contract price: ' || g1_eggshellHomebuilder_pkg.calc_total_contract_price(105001));
END;
/

-- query denormalization instance to see information about which subdivisions have affiliated elementary schools
SELECT *
  FROM subdivision_education_zones
 WHERE school_type = 'Elementary School';
 
 -- Alternate index to efficiently access information from the house style 
 -- table via the style name rather than style ID
SELECT * 
  FROM house_style 
 WHERE style_name = 'Farmhouse';
 
 
-- Alternate index to efficiently access information from the house style table 
-- via the style name rather than style ID
 SELECT * 
   FROM decorator_option
WHERE option_name = 'Chandelier Wiring';


--------------------------------------------------------------------------------------------------------------------------------
/* Example test cases */

-- Testing procedure exceptions
--------------------------------
-- demonstrate exception raised for non-existent contract ID
execute g1_eggshellHomebuilder_pkg.update_existing_contract_status(105015, 'Completed', SYSTIMESTAMP);

-- demonstrate exception raised for invalid status
execute g1_eggshellHomebuilder_pkg.update_existing_contract_status(105005, 'Working on it', SYSTIMESTAMP);

-- demonstrate exception raised for inactive contract
execute g1_eggshellHomebuilder_pkg.update_existing_contract_status(105004, 'Completed', SYSTIMESTAMP);

-- demonstrate exception raised for lot that is not currently under construction
execute g1_eggshellHomebuilder_pkg.add_decorator_choice(101010, 108003, SYSTIMESTAMP, 'Customer cares a lot about this.');

-- demonstrate exception raised if trying to add a choice in a stage other than 1, 4, 7
execute g1_eggshellHomebuilder_pkg.add_decorator_choice(101003, 108003, SYSTIMESTAMP, 'Customer cares a lot about this.');

-- demonstrate exception raised if trying to add a choice that needs to be made in an earlier stage
execute g1_eggshellHomebuilder_pkg.add_decorator_choice(101002, 108016, SYSTIMESTAMP, 'Customer cares a lot about this.');


-- Testing triggers
-------------------
-- demonstrate how to enable trg_prevent_negative_money
-- when trying to insert or update a contract record with a negative money amount
INSERT INTO contract VALUES (contract_sequence.NEXTVAL,
    TO_DATE('2024-03-01', 'YYYY-MM-DD'),  -- signed_date
    -320000,                              -- base_price
    NULL,                                 -- additional_cost
    16000,                                -- escrow_amount
    TO_DATE('2024-11-15', 'YYYY-MM-DD'),  -- estimated_completion_date
    NULL,                                 -- completion_date
    TO_DATE('2024-12-01', 'YYYY-MM-DD'),  -- expiration_date
    'Active',                             -- contract_status
    'Loan',                               -- finance_method
    101001,                               -- lot_lot_id
    NULL,                                 -- sale_sale_id
    111001,                               -- buyer_buyer_id
    112004                                -- employee_employee_id (agent)
);

-- demonstrate how to enable trg_prevent_double_sale
-- when trying to adding a contract on a lot that is already under contract or sold
INSERT INTO contract VALUES (contract_sequence.NEXTVAL,
    TO_DATE('2024-03-01', 'YYYY-MM-DD'),  -- signed_date
    320000,                               -- base_price
    NULL,                                 -- additional_cost
    16000,                                -- escrow_amount
    TO_DATE('2024-11-15', 'YYYY-MM-DD'),  -- estimated_completion_date
    NULL,                                 -- completion_date
    TO_DATE('2024-12-01', 'YYYY-MM-DD'),  -- expiration_date
    'Active',                             -- contract_status
    'Loan',                               -- finance_method
    101007,                               -- lot_lot_id
    NULL,                                 -- sale_sale_id
    111001,                               -- buyer_buyer_id
    112004                                -- employee_employee_id (agent)
);


