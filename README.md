# Eggshell-Home-Builder-RDBMS-System

# Project Overview
Developed as part of a graduate-level database management course at Carnegie Mellon University, this project involved the end-to-end design and implementation of a Relational Database Management System (RDBMS) for Eggshell Home Builder, a real estate development firm. The system automates the full lifecycle of home construction and sales—from tracking lot availability in subdivisions to managing complex, stage-based buyer customizations.

# Key Features
**Comprehensive Schema Design:** Developed a fully normalized schema (16 tables) to manage Subdivisions, Lots, House Styles, Buyers, Contracts, and Construction Progress .

**Business Logic Automation:** Implemented a PL/SQL package (g1_eggshellHomebuilder_pkg) to handle complex operations like calculating total contract prices with dynamic option pricing and updating construction stages.
Data Integrity & Security:

**Triggers:** Prevented negative financial entries and "double sales" of the same lot.

**Role-Based Access (RBAC):** Defined specific roles for Sales and Construction Managers to ensure data security and functional isolation.

**Automated Reporting:** Configured Oracle DBMS_SCHEDULER to automatically generate daily construction progress reports, reducing administrative overhead.

**Performance Optimization:** Implemented denormalization for school district data and created alternate indices on frequently queried lookup tables to enhance retrieval speed.

# Technical Stack

**Database:** Oracle SQL / PL/SQL

**Design Tools:** ERD Modeling (Crow's Foot Notation)

**Automation:** DBMS_SCHEDULER, Triggers, Sequences

# System Architecture

The database follows a modular architecture:

**Core Assets:** Subdivisions, Lots, and House Styles.

**Sales Engine:** Buyers, Banks, Contracts, and Sales records.

**Operations:** Construction Stages, Progress Tracking, and Decorator Choices.

**Community Context:** School Districts and Educational Zones.
