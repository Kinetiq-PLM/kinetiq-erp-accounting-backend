--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: accounting; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA accounting;


ALTER SCHEMA accounting OWNER TO postgres;

--
-- Name: status_enum; Type: TYPE; Schema: accounting; Owner: postgres
--

CREATE TYPE accounting.status_enum AS ENUM (
    'Active',
    'Inactive'
);


ALTER TYPE accounting.status_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: chart_of_accounts; Type: TABLE; Schema: accounting; Owner: postgres
--

CREATE TABLE accounting.chart_of_accounts (
    account_code character varying(255) NOT NULL,
    account_name character varying(255) NOT NULL,
    account_type character varying(50) DEFAULT NULL::character varying
);


ALTER TABLE accounting.chart_of_accounts OWNER TO postgres;

--
-- Name: general_ledger_accounts; Type: TABLE; Schema: accounting; Owner: postgres
--

CREATE TABLE accounting.general_ledger_accounts (
    gl_account_id character varying(255) NOT NULL,
    account_name character varying(255) NOT NULL,
    account_code character varying(255) NOT NULL,
    account_id character varying(255),
    status accounting.status_enum,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE accounting.general_ledger_accounts OWNER TO postgres;

--
-- Name: chart_of_accounts_view; Type: VIEW; Schema: accounting; Owner: postgres
--

CREATE VIEW accounting.chart_of_accounts_view AS
 SELECT coa.account_type,
    gla.account_name,
    gla.created_at
   FROM (accounting.general_ledger_accounts gla
     JOIN accounting.chart_of_accounts coa ON (((gla.account_code)::text = (coa.account_code)::text)));


ALTER VIEW accounting.chart_of_accounts_view OWNER TO postgres;

--
-- Name: currency; Type: TABLE; Schema: accounting; Owner: postgres
--

CREATE TABLE accounting.currency (
    currency_id character varying(255) NOT NULL,
    currency_name character varying(255) NOT NULL,
    exchange_rate numeric(15,6) NOT NULL,
    is_active boolean DEFAULT true NOT NULL
);


ALTER TABLE accounting.currency OWNER TO postgres;

--
-- Name: journal_entry_lines; Type: TABLE; Schema: accounting; Owner: postgres
--

CREATE TABLE accounting.journal_entry_lines (
    entry_line_id character varying(255) NOT NULL,
    gl_account_id character varying(255) DEFAULT NULL::character varying,
    journal_id character varying(255),
    debit_amount numeric(15,2) NOT NULL,
    credit_amount numeric(15,2) NOT NULL,
    description character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE accounting.journal_entry_lines OWNER TO postgres;

--
-- Name: general_ledger_jel_view; Type: VIEW; Schema: accounting; Owner: postgres
--

CREATE VIEW accounting.general_ledger_jel_view AS
 SELECT jel.entry_line_id,
    jel.gl_account_id,
    coa.account_name,
    jel.journal_id,
    jel.debit_amount,
    jel.credit_amount,
    jel.description
   FROM ((accounting.journal_entry_lines jel
     JOIN accounting.general_ledger_accounts gla ON (((jel.gl_account_id)::text = (gla.gl_account_id)::text)))
     JOIN accounting.chart_of_accounts coa ON (((gla.account_code)::text = (coa.account_code)::text)));


ALTER VIEW accounting.general_ledger_jel_view OWNER TO postgres;

--
-- Name: journal_entries; Type: TABLE; Schema: accounting; Owner: postgres
--

CREATE TABLE accounting.journal_entries (
    journal_id character varying(255) NOT NULL,
    journal_date date NOT NULL,
    description character varying(255) DEFAULT NULL::character varying,
    total_debit numeric(15,2) NOT NULL,
    total_credit numeric(15,2) NOT NULL,
    invoice_id character varying(255) DEFAULT NULL::character varying,
    currency_id character varying(255) NOT NULL
);


ALTER TABLE accounting.journal_entries OWNER TO postgres;

--
-- Name: general_ledger_view; Type: VIEW; Schema: accounting; Owner: postgres
--

CREATE VIEW accounting.general_ledger_view AS
 SELECT je.journal_id,
    gla.account_name,
    je.description,
    jel.debit_amount,
    jel.credit_amount,
    je.journal_date
   FROM ((accounting.journal_entries je
     JOIN accounting.journal_entry_lines jel ON (((je.journal_id)::text = (jel.journal_id)::text)))
     JOIN accounting.general_ledger_accounts gla ON (((jel.gl_account_id)::text = (gla.gl_account_id)::text)));


ALTER VIEW accounting.general_ledger_view OWNER TO postgres;

--
-- Name: official_receipts; Type: TABLE; Schema: accounting; Owner: postgres
--

CREATE TABLE accounting.official_receipts (
    or_id character varying(255) NOT NULL,
    invoice_id character varying(255) DEFAULT NULL::character varying,
    customer_id character varying(255) DEFAULT NULL::character varying,
    or_date date NOT NULL,
    settled_amount numeric(15,2) NOT NULL,
    remaining_amount numeric(15,2) NOT NULL,
    payment_method character varying(50) NOT NULL,
    reference_number character varying(100),
    created_by character varying(255)
);


ALTER TABLE accounting.official_receipts OWNER TO postgres;

--
-- Data for Name: chart_of_accounts; Type: TABLE DATA; Schema: accounting; Owner: postgres
--

COPY accounting.chart_of_accounts (account_code, account_name, account_type) FROM stdin;
ACC-COA-2025-CA1010	Cash on Hand	Current Asset
ACC-COA-2025-CA1020	Cash in Bank	Current Asset
ACC-COA-2025-CA1030	Accounts Receivable	Current Asset
ACC-COA-2025-CA1040	Allowance for Doubtful Accounts	Contra-Asset
ACC-COA-2025-CA1050	Raw Materials Inventory	Current Asset
ACC-COA-2025-CA1060	Work-in-Process (WIP) Inventory	Current Asset
ACC-COA-2025-CA1070	Finished Goods Inventory	Current Asset
ACC-COA-2025-CA1080	Prepaid Expenses	Current Asset
ACC-COA-2025-CA1090	Supplier Advances	Current Asset
ACC-COA-2025-NA1100	Land & Buildings	Non-Current Asset
ACC-COA-2025-NA1110	Machinery & Equipment	Non-Current Asset
ACC-COA-2025-NA1120	Vehicles	Non-Current Asset
ACC-COA-2025-NA1130	Office Furniture & Fixtures	Non-Current Asset
ACC-COA-2025-NA1140	Computers & IT Equipment	Non-Current Asset
ACC-COA-2025-NA1150	Intangible Assets	Non-Current Asset
ACC-COA-2025-NA1160	Accumulated Depreciation	Contra-Asset
ACC-COA-2025-CL2010	Accounts Payable	Current Liability
ACC-COA-2025-CL2020	Accrued Expenses	Current Liability
ACC-COA-2025-CL2030	Taxes Payable	Current Liability
ACC-COA-2025-CL2040	Short-Term Loans Payable	Current Liability
ACC-COA-2025-CL2050	Customer Deposits	Current Liability
ACC-COA-2025-NL2100	Long-Term Loans Payable	Non-Current Liability
ACC-COA-2025-NL2110	Bonds Payable	Non-Current Liability
ACC-COA-2025-NL2120	Lease Liabilities	Non-Current Liability
ACC-COA-2025-EE3010	Owners Capital / Shareholders Equity	Equity
ACC-COA-2025-EE3020	Retained Earnings	Equity
ACC-COA-2025-EE3030	Dividends Payable	Equity
ACC-COA-2025-RR4010	Sales Revenue	Revenue
ACC-COA-2025-RR4020	Service Revenue	Revenue
ACC-COA-2025-RR4030	Discounts Allowed	Contra-Revenue
ACC-COA-2025-CG5010	Raw Materials Used	Cost of Goods Sold
ACC-COA-2025-CG5020	Direct Labor	Cost of Goods Sold
ACC-COA-2025-CG5030	Factory Overhead	Cost of Goods Sold
ACC-COA-2025-CG5040	Work-in-Process Adjustments	Cost of Goods Sold
ACC-COA-2025-CG5050	Cost of Finished Goods Sold	Cost of Goods Sold
ACC-COA-2025-AE6010	Salaries & Wages	Operating Expense
ACC-COA-2025-AE6020	Office Supplies & Equipment	Operating Expense
ACC-COA-2025-AE6030	Rent & Utilities	Operating Expense
ACC-COA-2025-AE6040	Depreciation	Operating Expense
ACC-COA-2025-AE6050	Software & IT Expenses	Operating Expense
ACC-COA-2025-AE6060	Legal & Professional Fees	Operating Expense
ACC-COA-2025-SD6100	Marketing & Advertising	Operating Expense
ACC-COA-2025-SD6110	Sales Commissions	Operating Expense
ACC-COA-2025-SD6120	Shipping & Freight Costs	Operating Expense
ACC-COA-2025-SD6130	Packaging Costs	Operating Expense
ACC-COA-2025-OI7010	Interest Income	Other Income
ACC-COA-2025-OI7020	Gain on Sale of Assets	Other Income
ACC-COA-2025-OI7030	Investment Income	Other Income
ACC-COA-2025-OE7100	Interest Expense	Other Expense
ACC-COA-2025-OE7110	Exchange Rate Losses	Other Expense
ACC-COA-2025-OE7120	Penalties & Fines	Other Expense
\.


--
-- Data for Name: currency; Type: TABLE DATA; Schema: accounting; Owner: postgres
--

COPY accounting.currency (currency_id, currency_name, exchange_rate, is_active) FROM stdin;
ACC-CUR-2025-X1Y2Z3	Philippine Peso	1.000000	t
ACC-CUR-2025-A4B5C6	US Dollar	0.017500	t
ACC-CUR-2025-D7E8F9	Euro	0.016260	t
ACC-CUR-2025-G1H2I3	British Pound	0.013930	t
ACC-CUR-2025-J4K5L6	Japanese Yen	0.002650	t
ACC-CUR-2025-M7N8O9	Canadian Dollar	0.023940	t
ACC-CUR-2025-P1Q2R3	Australian Dollar	0.026380	t
ACC-CUR-2025-S4T5U6	Swiss Franc	0.015570	t
ACC-CUR-2025-V7W8X9	Chinese Yuan	0.127400	t
ACC-CUR-2025-Y1Z2A3	Hong Kong Dollar	0.128500	t
ACC-CUR-2025-B4C5D6	Singapore Dollar	0.023740	t
ACC-CUR-2025-E7F8G9	South Korean Won	0.000750	t
ACC-CUR-2025-H1I2J3	United Arab Emirates Dirham	0.004760	t
ACC-CUR-2025-K4L5M6	Saudi Riyal	0.004690	t
ACC-CUR-2025-N7O8P9	Thai Baht	0.027820	t
ACC-CUR-2025-Q1R2S3	Vietnamese Dong	0.000044	t
ACC-CUR-2025-T4U5V6	Indonesian Rupiah	0.000064	t
ACC-CUR-2025-W7X8Y9	Indian Rupee	0.013500	t
ACC-CUR-2025-Z1A2B3	Malaysian Ringgit	0.023400	t
ACC-CUR-2025-C4D5E6	New Zealand Dollar	0.028800	t
\.


--
-- Data for Name: general_ledger_accounts; Type: TABLE DATA; Schema: accounting; Owner: postgres
--

COPY accounting.general_ledger_accounts (gl_account_id, account_name, account_code, account_id, status, created_at) FROM stdin;
ACC-GLA-2025-D4E5F6	Bank - 1122	ACC-COA-2025-CA1020	\N	Active	2025-03-08 02:00:00
ACC-GLA-2025-G7H8I9	Inventory	ACC-COA-2025-CA1070	\N	Active	2025-03-08 02:00:00
ACC-GLA-2025-J1K2L3	Mr. Zubair & Co.	ACC-COA-2025-CL2010	\N	Active	2025-03-08 02:00:00
ACC-GLA-2025-M4N5O6	Kazim Ahmed	ACC-COA-2025-CL2050	\N	Active	2025-03-08 02:00:00
ACC-GLA-2025-P7Q8R9	Kineteq/Oweners Equity	ACC-COA-2025-EE3010	\N	Active	2025-03-08 02:00:00
ACC-GLA-2025-S1T2U3	Salary Expense	ACC-COA-2025-AE6010	\N	Active	2025-03-08 02:00:00
ACC-GLA-2025-V4W5X6	Sales Revenue	ACC-COA-2025-RR4010	\N	Active	2025-03-08 02:00:00
ACC-GLA-2025-Y7Z8A9	Cost of Goods Sold	ACC-COA-2025-CG5050	\N	Active	2025-03-08 02:00:00
ACC-GLA-2025-B1C2D3	Electricity Expense	ACC-COA-2025-AE6030	\N	Active	2025-03-08 02:00:00
ACC-GLA-2025-E4F5G6	Government Taxes Payable	ACC-COA-2025-CL2030	\N	Active	2025-03-08 02:00:00
ACC-GLA-2025-H7I8J9	Raw Materials Used	ACC-COA-2025-CG5010	\N	Active	2025-03-18 08:15:14
ACC-GLA-2025-K1L2M3	BANK - BDO	ACC-COA-2025-CL2010	\N	Active	2025-03-08 02:00:00
ACC-GLA-2025-N4O5P6	Shipping Cost	ACC-COA-2025-SD6120	\N	Active	2025-03-18 21:06:48
ACC-GLA-2025-N1O346	Work-in-Process Inventory 	ACC-COA-2025-CA1060	\N	Active	2025-03-18 21:06:48
ACC-GLA-2025-N98146	Raw Materials Inventory 	ACC-COA-2025-CA1050	\N	Active	2025-03-18 21:06:48
ACC-GLA-2025-M9171I	Raw Materials Used 	ACC-COA-2025-CG5010	\N	Active	2025-03-18 21:06:48
ACC-GLA-2025-BFC001	Vendor- BioFlex Composites	ACC-COA-2025-CL2010	ADMIN-VENDOR-2025-AB12CD	Active	2025-03-18 21:23:27
ACC-GLA-2025-BMG002	Vendor- BioGrade Metals	ACC-COA-2025-CL2010	ADMIN-VENDOR-2025-EF34GH	Active	2025-03-18 21:23:27
ACC-GLA-2025-CBP003	Vendor- CryoBond Precision	ACC-COA-2025-CL2010	ADMIN-VENDOR-2025-IJ56KL	Active	2025-03-18 21:23:27
ACC-GLA-2025-DPL004	Vendor- DuraWell Pro Ltd.	ACC-COA-2025-CL2010	ADMIN-VENDOR-2025-MN78OP	Active	2025-03-18 21:23:27
ACC-GLA-2025-MTC005	Vendor- MedicalTradingCorps	ACC-COA-2025-CL2010	ADMIN-VENDOR-2025-QR90ST	Active	2025-03-18 21:23:27
ACC-GLA-2025-MMI006	Vendor- MediCore Materials Inc.	ACC-COA-2025-CL2010	ADMIN-VENDOR-2025-UV12WX	Active	2025-03-18 21:23:27
ACC-GLA-2025-NIL007	Vendor- NeoCarewell Industries Ltd.	ACC-COA-2025-CL2010	ADMIN-VENDOR-2025-YZ34AB	Active	2025-03-18 21:23:27
ACC-GLA-2025-PTL008	Vendor- PharmaTools Ltd.	ACC-COA-2025-CL2010	ADMIN-VENDOR-2025-CD56EF	Active	2025-03-18 21:23:27
ACC-GLA-2025-PFM009	Vendor- PureForm Medical	ACC-COA-2025-CL2010	ADMIN-VENDOR-2025-GH78IJ	Active	2025-03-18 21:23:27
ACC-GLA-2025-PFM031	Employee- Kate Tan	ACC-COA-2025-AE6010	HR-EMP-2025-D9B88B	Active	2025-03-18 21:23:27
ACC-GLA-2025-P15131	Employee- James Marticio	ACC-COA-2025-AE6010	HR-EMP-2025-B206D1	Active	2025-03-18 21:23:27
ACC-GLA-2025-NF1131	Employee- Robert Santiago	ACC-COA-2025-AE6010	HR-EMP-2025-A16258	Active	2025-03-18 21:23:27
ACC-GLA-2025-MF6031	Employee- Maria Lopez	ACC-COA-2025-AE6010	HR-EMP-2025-7170D9	Active	2025-03-18 21:23:27
ACC-GLA-2025-PP9821	Employee- David Cruz	ACC-COA-2025-AE6010	HR-EMP-2025-01052C	Active	2025-03-18 21:23:27
ACC-GLA-2025-N1O1P1	Customer - Philippines General Hospital	ACC-COA-2025-CA1030	SALES-CUST-2025-TU12VW	Active	2025-03-18 21:06:48
ACC-GLA-2025-N1O5P7	Customer - botik	ACC-COA-2025-CA1030	SALES-CUST-2025-XA12BC	Active	2025-03-18 21:23:27
ACC-GLA-2025-N2O5P9	Customer - Makati Medical Center	ACC-COA-2025-CA1030	SALES-CUST-2025-HI56JK	Active	2025-03-18 21:06:48
ACC-GLA-2025-N2Q1N9	Customer - Capitol Medical Center	ACC-COA-2025-CA1030	SALES-CUST-2025-GH78IJ	Active	2025-03-18 21:06:48
ACC-GLA-2025-N3O1G1	Customer - Metro Manila Medical Center	ACC-COA-2025-CA1030	SALES-CUST-2025-CD56EF	Active	2025-03-18 21:06:48
ACC-GLA-2025-N6O1A6	Customer - World Citi Medical Center	ACC-COA-2025-CA1030	SALES-CUST-2025-YZ34AB	Active	2025-03-18 21:06:48
ACC-GLA-2025-N6O5P1	Customer - Manila Doctors Hospital	ACC-COA-2025-CA1030	SALES-CUST-2025-LM78NO	Active	2025-03-18 21:06:48
ACC-GLA-2025-N7O5P8	Customer - St. Luke Medical Center	ACC-COA-2025-CA1030	SALES-CUST-2025-DE34FG	Active	2025-03-18 21:06:48
ACC-GLA-2025-N8O5P2	Customer - Cardinal Santos Medical Center	ACC-COA-2025-CA1030	SALES-CUST-2025-PQ90RS	Active	2025-03-18 21:06:48
\.


--
-- Data for Name: journal_entries; Type: TABLE DATA; Schema: accounting; Owner: postgres
--

COPY accounting.journal_entries (journal_id, journal_date, description, total_debit, total_credit, invoice_id, currency_id) FROM stdin;
ACC-JOE-2025-A1B2C3	2022-01-05	Sales Order	77984.53	77984.53	SALES-ORD-2025-A1B2C3	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-X9Y8Z7	2022-01-05	Sales Order	3544677.76	3544677.76	SALES-ORD-2025-X9Y8Z7	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-K4M5N6	2022-01-05	Sales Order	437073.00	437073.00	SALES-ORD-2025-K4M5N6	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-Y2X3Z4	2022-01-05	Sales Order	1073.00	1073.00	SALES-ORD-2025-Y2X3Z4	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-T1R2Q3	2022-01-05	Sales Order	1100.00	1100.00	SALES-ORD-2025-T1R2Q3	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-P5O6L7	2022-01-05	Sales Order	1125.50	1125.50	SALES-ORD-2025-P5O6L7	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-V8U9W1	2022-01-05	Sales Order	1098.75	1098.75	SALES-ORD-2025-V8U9W1	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-J3H4G5	2022-01-05	Sales Order	1150.25	1150.25	SALES-ORD-2025-J3H4G5	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-D6E7F8	2022-01-05	Sales Order	1087.90	1087.90	SALES-ORD-2025-D6E7F8	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-M9N8B7	2022-01-06	Production Document Transaction	150.00	150.00	OPS-DOH-2025-A1B2C3	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-Q4R5S6	2022-01-06	Production Document Transaction	175.00	175.00	OPS-DOH-2025-D4E5F6	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-T7Y8U9	2022-01-06	Production Document Transaction	200.00	200.00	OPS-DOH-2025-G7H8I9	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-V3B4N5	2022-01-06	Production Document Transaction	225.00	225.00	OPS-DOH-2025-J1K2L3	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-W6X7Y8	2022-01-06	Production Document Transaction	250.00	250.00	OPS-DOH-2025-M4N5O6	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-Z1X2C3	2022-01-07	MRP Overall Production Cost	2000.00	2000.00	MRP-CST-2025-A1B2C3	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-N5M6B7	2022-01-07	MRP Overall Production Cost	1830.00	1830.00	MRP-CST-2025-D4E5F6	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-L8K9J0	2022-01-07	MRP Overall Production Cost	2600.00	2600.00	MRP-CST-2025-G7H8I9	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-W3E4R5	2022-01-08	MRP Overall Production Cost	2150.00	2150.00	MRP-CST-2025-J1K2L3	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-T6Y7U8	2022-01-08	MRP Overall Production Cost	1985.75	1985.75	MRP-CST-2025-M4N5O6	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-O9I8U7	2022-01-08	MRP Overall Production Cost	2750.50	2750.50	MRP-CST-2025-P7Q8R9	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-G5F4D3	2022-01-08	Payroll Expense	5854.55	5854.55	HR-PAY-2025-A1B2C3	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-H2J3K4	2022-01-08	Payroll Expense	1850.00	1850.00	HR-PAY-2025-D4E5F6	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-G5FFAA	2022-01-08	Payroll Expense	5814.15	5814.15	HR-PAY-2025-G7H8I9	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-H2JEFE	2022-01-08	Payroll Expense	4850.00	4850.00	HR-PAY-2025-J1K2L3	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-X9WJAA	2022-01-08	Payroll Expense	3200.75	3200.75	HR-PAY-2025-M4N5O6	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-C1V2B3	2022-01-09	Production Order Cost	1500.00	1500.00	PROD-POD-2025-A1B2C3	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-A3X4Y5	2022-01-09	Production Order Cost	800.00	800.00	PROD-POD-2025-D4E5F6	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-L1K2J3	2022-01-10	Purchased Item	1521.00	1521.00	PURCHASING-PUI-2025-A7X3K9	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-Q2W3E4	2022-01-11	Purchased Item	1785.50	1785.50	PURCHASING-PUI-2025-L2M8P4	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-M7N8B9	2022-01-12	Purchased Item	1342.75	1342.75	PURCHASING-PUI-2025-Q5Z7T1	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-O4I5U6	2022-01-13	Purchased Item	1899.00	1899.00	PURCHASING-PUI-2025-V3B6Y8	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-Z7X8C9	2022-01-14	Purchased Item	1650.25	1650.25	PURCHASING-PUI-2025-W9D2N5	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-T5R6Q7	2022-01-15	Purchased Item	1420.00	1420.00	PURCHASING-PUI-2025-J1F4C7	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-X2Y3Z4	2022-01-16	Purchased Item	1755.30	1755.30	PURCHASING-PUI-2025-X8U5H2	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-P3O4L5	2022-01-17	Purchased Item	1980.00	1980.00	PURCHASING-PUI-2025-Z6O3R9	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-V5U6W7	2022-01-18	Purchased Item	1575.75	1575.75	PURCHASING-PUI-2025-M4Y1K7	ACC-CUR-2025-X1Y2Z3
ACC-JOE-2025-N9M8B7	2022-01-19	Purchased Item	1835.60	1835.60	PURCHASING-PUI-2025-T2V8N5	ACC-CUR-2025-X1Y2Z3
\.


--
-- Data for Name: journal_entry_lines; Type: TABLE DATA; Schema: accounting; Owner: postgres
--

COPY accounting.journal_entry_lines (entry_line_id, gl_account_id, journal_id, debit_amount, credit_amount, description) FROM stdin;
ACC-JEL-2025-6B8DCF	ACC-GLA-2025-N1O5P7	ACC-JOE-2025-A1B2C3	77984.53	0.00	Customer - botik
ACC-JEL-2025-901358	ACC-GLA-2025-V4W5X6	ACC-JOE-2025-A1B2C3	0.00	77984.53	Sales Revenue
ACC-JEL-2025-9C16E9	ACC-GLA-2025-N7O5P8	ACC-JOE-2025-X9Y8Z7	3544677.76	0.00	Customer - St. Luke Medical Center
ACC-JEL-2025-327BBB	ACC-GLA-2025-V4W5X6	ACC-JOE-2025-X9Y8Z7	0.00	3544677.76	Sales Revenue
ACC-JEL-2025-D058D3	ACC-GLA-2025-N2O5P9	ACC-JOE-2025-K4M5N6	437073.00	0.00	Customer - Makati Medical Center
ACC-JEL-2025-B4A70F	ACC-GLA-2025-V4W5X6	ACC-JOE-2025-K4M5N6	0.00	437073.00	Sales Revenue
ACC-JEL-2025-55F259	ACC-GLA-2025-N6O5P1	ACC-JOE-2025-Y2X3Z4	1073.00	0.00	Customer - Manila Doctors Hospital
ACC-JEL-2025-5A0A69	ACC-GLA-2025-V4W5X6	ACC-JOE-2025-Y2X3Z4	0.00	1073.00	Sales Revenue
ACC-JEL-2025-2D35D2	ACC-GLA-2025-N8O5P2	ACC-JOE-2025-T1R2Q3	1100.00	0.00	Customer - Cardinal Santos Medical Center
ACC-JEL-2025-2CCC84	ACC-GLA-2025-V4W5X6	ACC-JOE-2025-T1R2Q3	0.00	1100.00	Sales Revenue
ACC-JEL-2025-7723BE	ACC-GLA-2025-N1O1P1	ACC-JOE-2025-P5O6L7	1125.50	0.00	Customer - Philippines General Hospital
ACC-JEL-2025-EB3647	ACC-GLA-2025-V4W5X6	ACC-JOE-2025-P5O6L7	0.00	1125.50	Sales Revenue
ACC-JEL-2025-6D71D5	ACC-GLA-2025-N6O1A6	ACC-JOE-2025-V8U9W1	1098.75	0.00	Customer - World Citi Medical Center
ACC-JEL-2025-18286A	ACC-GLA-2025-V4W5X6	ACC-JOE-2025-V8U9W1	0.00	1098.75	Sales Revenue
ACC-JEL-2025-06EB72	ACC-GLA-2025-N3O1G1	ACC-JOE-2025-J3H4G5	1150.25	0.00	Customer - Metro Manila Medical Center
ACC-JEL-2025-619683	ACC-GLA-2025-V4W5X6	ACC-JOE-2025-J3H4G5	0.00	1150.25	Sales Revenue
ACC-JEL-2025-1D1AB8	ACC-GLA-2025-N2Q1N9	ACC-JOE-2025-D6E7F8	1087.90	0.00	Customer - Capitol Medical Center
ACC-JEL-2025-143E07	ACC-GLA-2025-V4W5X6	ACC-JOE-2025-D6E7F8	0.00	1087.90	Sales Revenue
ACC-JEL-2025-A1B2C3	ACC-GLA-2025-N1O346	ACC-JOE-2025-M9N8B7	150.00	0.00	Work-in-Process Inventory
ACC-JEL-2025-D4E5F6	ACC-GLA-2025-N98146	ACC-JOE-2025-M9N8B7	0.00	150.00	Raw Materials Used for Production
ACC-JEL-2025-G7H8I9	ACC-GLA-2025-N1O346	ACC-JOE-2025-Q4R5S6	175.00	0.00	Work-in-Process Inventory
ACC-JEL-2025-J1K2L3	ACC-GLA-2025-N98146	ACC-JOE-2025-Q4R5S6	0.00	175.00	Raw Materials Used for Production
ACC-JEL-2025-M4N5O6	ACC-GLA-2025-N1O346	ACC-JOE-2025-T7Y8U9	200.00	0.00	Work-in-Process Inventory
ACC-JEL-2025-P7Q8R9	ACC-GLA-2025-N98146	ACC-JOE-2025-T7Y8U9	0.00	200.00	Raw Materials Used for Production
ACC-JEL-2025-S1T2U3	ACC-GLA-2025-N1O346	ACC-JOE-2025-V3B4N5	225.00	0.00	Work-in-Process Inventory
ACC-JEL-2025-V4W5X6	ACC-GLA-2025-N98146	ACC-JOE-2025-V3B4N5	0.00	225.00	Raw Materials Used for Production
ACC-JEL-2025-Y7Z8A9	ACC-GLA-2025-N1O346	ACC-JOE-2025-W6X7Y8	250.00	0.00	Work-in-Process Inventory
ACC-JEL-2025-B1C2D3	ACC-GLA-2025-N98146	ACC-JOE-2025-W6X7Y8	0.00	250.00	Raw Materials Used for Production
ACC-JEL-2025-K1L2M3	ACC-GLA-2025-Y7Z8A9	ACC-JOE-2025-Z1X2C3	2000.00	0.00	Cost of Finished Goods Sold
ACC-JEL-2025-N4O5P6	ACC-GLA-2025-V4W5X6	ACC-JOE-2025-Z1X2C3	0.00	2000.00	Sales Revenue
ACC-JEL-2025-Q7R8S9	ACC-GLA-2025-Y7Z8A9	ACC-JOE-2025-N5M6B7	1830.00	0.00	Cost of Finished Goods Sold
ACC-JEL-2025-T1U2V3	ACC-GLA-2025-V4W5X6	ACC-JOE-2025-N5M6B7	0.00	1830.00	Sales Revenue
ACC-JEL-2025-W4X5Y6	ACC-GLA-2025-Y7Z8A9	ACC-JOE-2025-L8K9J0	2600.00	0.00	Cost of Finished Goods Sold
ACC-JEL-2025-Z7A8B9	ACC-GLA-2025-V4W5X6	ACC-JOE-2025-L8K9J0	0.00	2600.00	Sales Revenue
ACC-JEL-2025-C1D2E3	ACC-GLA-2025-Y7Z8A9	ACC-JOE-2025-W3E4R5	2150.00	0.00	Cost of Finished Goods Sold
ACC-JEL-2025-F4G5H6	ACC-GLA-2025-V4W5X6	ACC-JOE-2025-W3E4R5	0.00	2150.00	Sales Revenue
ACC-JEL-2025-I7J8K9	ACC-GLA-2025-Y7Z8A9	ACC-JOE-2025-T6Y7U8	1985.75	0.00	Cost of Finished Goods Sold
ACC-JEL-2025-L1M2N3	ACC-GLA-2025-V4W5X6	ACC-JOE-2025-T6Y7U8	0.00	1985.75	Sales Revenue
ACC-JEL-2025-O4P5Q6	ACC-GLA-2025-Y7Z8A9	ACC-JOE-2025-O9I8U7	2750.50	0.00	Cost of Finished Goods Sold
ACC-JEL-2025-R7S8T9	ACC-GLA-2025-V4W5X6	ACC-JOE-2025-O9I8U7	0.00	2750.50	Sales Revenue
ACC-JEL-2025-A1BQG3	ACC-GLA-2025-PFM031	ACC-JOE-2025-G5F4D3	5854.55	0.00	Employee- Kate Tan
ACC-JEL-2025-DWHW2H	ACC-GLA-2025-D4E5F6	ACC-JOE-2025-G5F4D3	0.00	5854.55	Payroll Payment
ACC-JEL-2025-F7G8H9	ACC-GLA-2025-P15131	ACC-JOE-2025-H2J3K4	1850.00	0.00	Employee- James Marticio
ACC-JEL-2025-I1J2K3	ACC-GLA-2025-D4E5F6	ACC-JOE-2025-H2J3K4	0.00	1850.00	Payroll Payment
ACC-JEL-2025-L4M5N6	ACC-GLA-2025-NF1131	ACC-JOE-2025-G5F4D3	5814.15	0.00	Employee- Robert Santiago
ACC-JEL-2025-O7P8Q9	ACC-GLA-2025-D4E5F6	ACC-JOE-2025-G5F4D3	0.00	5814.15	Payroll Payment
ACC-JEL-2025-R1S2T3	ACC-GLA-2025-MF6031	ACC-JOE-2025-H2J3K4	4850.00	0.00	Employee- Maria Lopez
ACC-JEL-2025-U4V5W6	ACC-GLA-2025-D4E5F6	ACC-JOE-2025-H2J3K4	0.00	4850.00	Payroll Payment
ACC-JEL-2025-X7Y8Z9	ACC-GLA-2025-PP9821	ACC-JOE-2025-X9Y8Z7	3200.75	0.00	Employee- David Cruz
ACC-JEL-2025-A2B3C4	ACC-GLA-2025-D4E5F6	ACC-JOE-2025-X9Y8Z7	0.00	3200.75	Payroll Payment
ACC-JEL-2025-Q1W2E3	ACC-GLA-2025-N1O346	ACC-JOE-2025-C1V2B3	1500.00	0.00	Work-in-Process Inventory Increase
ACC-JEL-2025-R4T5Y6	ACC-GLA-2025-M9171I	ACC-JOE-2025-C1V2B3	0.00	1500.00	Raw Materials Used
ACC-JEL-2025-U7I8O9	ACC-GLA-2025-N1O346	ACC-JOE-2025-A3X4Y5	800.00	0.00	Work-in-Process Inventory Increase
ACC-JEL-2025-P2L3K4	ACC-GLA-2025-M9171I	ACC-JOE-2025-A3X4Y5	0.00	800.00	Raw Materials Used
ACC-JEL-2025-XZ1001	ACC-GLA-2025-BMG002	ACC-JOE-2025-L1K2J3	1521.00	0.00	Vendor- BioGrade Metals
ACC-JEL-2025-YZ2002	ACC-GLA-2025-D4E5F6	ACC-JOE-2025-L1K2J3	0.00	1521.00	Bank Asset
ACC-JEL-2025-XZ1003	ACC-GLA-2025-CBP003	ACC-JOE-2025-Q2W3E4	1785.50	0.00	Vendor- CryoBond Precision
ACC-JEL-2025-YZ2004	ACC-GLA-2025-D4E5F6	ACC-JOE-2025-Q2W3E4	0.00	1785.50	Bank Asset
ACC-JEL-2025-XZ1005	ACC-GLA-2025-DPL004	ACC-JOE-2025-M7N8B9	1342.75	0.00	Vendor- DuraWell Pro Ltd.
ACC-JEL-2025-YZ2006	ACC-GLA-2025-D4E5F6	ACC-JOE-2025-M7N8B9	0.00	1342.75	Bank Asset
ACC-JEL-2025-XZ1007	ACC-GLA-2025-MTC005	ACC-JOE-2025-O4I5U6	1899.00	0.00	Vendor- MedicalTradingCorps
ACC-JEL-2025-YZ2008	ACC-GLA-2025-D4E5F6	ACC-JOE-2025-O4I5U6	0.00	1899.00	Bank Asset
ACC-JEL-2025-XZ1009	ACC-GLA-2025-MMI006	ACC-JOE-2025-Z7X8C9	1650.25	0.00	Vendor- MediCore Materials Inc.
ACC-JEL-2025-YZ2010	ACC-GLA-2025-D4E5F6	ACC-JOE-2025-Z7X8C9	0.00	1650.25	Bank Asset
ACC-JEL-2025-XZ1011	ACC-GLA-2025-NIL007	ACC-JOE-2025-T5R6Q7	1420.00	0.00	Vendor- NeoCarewell Industries Ltd.
ACC-JEL-2025-YZ2012	ACC-GLA-2025-D4E5F6	ACC-JOE-2025-T5R6Q7	0.00	1420.00	Bank Asset
ACC-JEL-2025-XZ1013	ACC-GLA-2025-PTL008	ACC-JOE-2025-X2Y3Z4	1755.30	0.00	Vendor- PharmaTools Ltd.
ACC-JEL-2025-YZ2014	ACC-GLA-2025-D4E5F6	ACC-JOE-2025-X2Y3Z4	0.00	1755.30	Bank Asset
ACC-JEL-2025-XZ1015	ACC-GLA-2025-PFM009	ACC-JOE-2025-P3O4L5	1980.00	0.00	Vendor- PureForm Medical
ACC-JEL-2025-YZ2016	ACC-GLA-2025-D4E5F6	ACC-JOE-2025-P3O4L5	0.00	1980.00	Bank Asset
ACC-JEL-2025-XZ1017	ACC-GLA-2025-BMG002	ACC-JOE-2025-V5U6W7	1575.75	0.00	Vendor- BioGrade Metals
ACC-JEL-2025-YZ2018	ACC-GLA-2025-D4E5F6	ACC-JOE-2025-V5U6W7	0.00	1575.75	Bank Asset
ACC-JEL-2025-XZ1019	ACC-GLA-2025-CBP003	ACC-JOE-2025-N9M8B7	1835.60	0.00	Vendor- CryoBond Precision
ACC-JEL-2025-YZ2020	ACC-GLA-2025-D4E5F6	ACC-JOE-2025-N9M8B7	0.00	1835.60	Bank Asset
\.


--
-- Data for Name: official_receipts; Type: TABLE DATA; Schema: accounting; Owner: postgres
--

COPY accounting.official_receipts (or_id, invoice_id, customer_id, or_date, settled_amount, remaining_amount, payment_method, reference_number, created_by) FROM stdin;
ACC-OFR-2025-6UJWP	SALES-INV-2025-RR17H	SALES-CUST-2025-ZI9G5	2025-04-02	250.00	250.00	Credit Card	REF-1001	Admin
ACC-OFR-2025-DRLNG	SALES-INV-2025-T3AKZ	SALES-CUST-2025-3AK0N	2025-03-20	1200.00	0.00	Bank Transfer	REF-1002	Admin
ACC-OFR-2025-08ZYP	SALES-INV-2025-YROTR	SALES-CUST-2025-VMAZ2	2025-03-12	1000.00	1500.00	Cash	REF-1003	Admin
ACC-OFR-2025-KJXTE	SALES-INV-2025-CDKTR	SALES-CUST-2025-LHI75	2025-03-25	1800.00	0.00	Credit Card	REF-1004	Admin
ACC-OFR-2025-N1LB7	SALES-INV-2025-81JF0	SALES-CUST-2025-HMMTK	2025-04-06	400.00	350.00	Bank Transfer	REF-1005	Admin
ACC-OFR-2025-TN182	SALES-INV-2025-7765D	SALES-CUST-2025-9QIL6	2025-03-17	1500.00	1500.00	Cash	REF-1006	Admin
ACC-OFR-2025-VSET2	SALES-INV-2025-M21A3	SALES-CUST-2025-1THW3	2025-03-22	950.00	0.00	Credit Card	REF-1007	Admin
ACC-OFR-2025-HCZKD	SALES-INV-2025-I8FFQ	SALES-CUST-2025-X4EHM	2025-04-11	2000.00	2000.00	Bank Transfer	REF-1008	Admin
ACC-OFR-2025-X98QI	SALES-INV-2025-CNVQI	SALES-CUST-2025-O5PEX	2025-03-14	750.00	2000.00	Cash	REF-1009	Admin
ACC-OFR-2025-XOE4Y	SALES-INV-2025-DYTMN	SALES-CUST-2025-YMX5Q	2025-03-18	600.00	0.00	Credit Card	REF-1010	Admin
ACC-OFR-2025-CKYXC	SALES-INV-2025-K7FZ6	SALES-CUST-2025-KZ69E	2025-04-05	300.00	100.00	Credit Card	REF-1011	Admin
ACC-OFR-2025-PK5YT	SALES-INV-2025-LD9H2	SALES-CUST-2025-EI95D	2025-03-29	1100.00	200.00	Bank Transfer	REF-1012	Admin
ACC-OFR-2025-CLSQR	SALES-INV-2025-EMAR4	SALES-CUST-2025-IPIP5	2025-03-10	700.00	500.00	Cash	REF-1013	Admin
ACC-OFR-2025-KB15T	SALES-INV-2025-K0Z4A	SALES-CUST-2025-V109I	2025-04-03	2500.00	0.00	Credit Card	REF-1014	Admin
ACC-OFR-2025-WMZHJ	SALES-INV-2025-DI842	SALES-CUST-2025-CMSU1	2025-03-26	900.00	100.00	Bank Transfer	REF-1015	Admin
ACC-OFR-2025-L3I48	SALES-INV-2025-XZXFH	SALES-CUST-2025-Q55EP	2025-04-08	1400.00	0.00	Cash	REF-1016	Admin
ACC-OFR-2025-F9AH8	SALES-INV-2025-M3Z4Y	SALES-CUST-2025-DO945	2025-03-15	600.00	400.00	Credit Card	REF-1017	Admin
ACC-OFR-2025-RSQ2Z	SALES-INV-2025-AIE77	SALES-CUST-2025-QHI0A	2025-04-12	1700.00	300.00	Bank Transfer	REF-1018	Admin
ACC-OFR-2025-YTZRF	SALES-INV-2025-W7IZO	SALES-CUST-2025-WNV5O	2025-03-30	800.00	200.00	Cash	REF-1019	Admin
ACC-OFR-2025-SDWXL	SALES-INV-2025-P57B7	SALES-CUST-2025-1LBPZ	2025-04-09	2200.00	0.00	Credit Card	REF-1020	Admin
\.


--
-- Name: chart_of_accounts chart_of_accounts_pkey; Type: CONSTRAINT; Schema: accounting; Owner: postgres
--

ALTER TABLE ONLY accounting.chart_of_accounts
    ADD CONSTRAINT chart_of_accounts_pkey PRIMARY KEY (account_code);


--
-- Name: currency currency_pkey; Type: CONSTRAINT; Schema: accounting; Owner: postgres
--

ALTER TABLE ONLY accounting.currency
    ADD CONSTRAINT currency_pkey PRIMARY KEY (currency_id);


--
-- Name: general_ledger_accounts general_ledger_accounts_pkey; Type: CONSTRAINT; Schema: accounting; Owner: postgres
--

ALTER TABLE ONLY accounting.general_ledger_accounts
    ADD CONSTRAINT general_ledger_accounts_pkey PRIMARY KEY (gl_account_id);


--
-- Name: journal_entries journal_entries_pkey; Type: CONSTRAINT; Schema: accounting; Owner: postgres
--

ALTER TABLE ONLY accounting.journal_entries
    ADD CONSTRAINT journal_entries_pkey PRIMARY KEY (journal_id);


--
-- Name: journal_entry_lines journal_entry_lines_pkey; Type: CONSTRAINT; Schema: accounting; Owner: postgres
--

ALTER TABLE ONLY accounting.journal_entry_lines
    ADD CONSTRAINT journal_entry_lines_pkey PRIMARY KEY (entry_line_id);


--
-- Name: official_receipts official_receipts_pkey; Type: CONSTRAINT; Schema: accounting; Owner: postgres
--

ALTER TABLE ONLY accounting.official_receipts
    ADD CONSTRAINT official_receipts_pkey PRIMARY KEY (or_id);


--
-- Name: general_ledger_accounts fk_general_ledger_accounts_chart_of_accounts; Type: FK CONSTRAINT; Schema: accounting; Owner: postgres
--

ALTER TABLE ONLY accounting.general_ledger_accounts
    ADD CONSTRAINT fk_general_ledger_accounts_chart_of_accounts FOREIGN KEY (account_code) REFERENCES accounting.chart_of_accounts(account_code);


--
-- Name: journal_entries fk_journal_entries_currency; Type: FK CONSTRAINT; Schema: accounting; Owner: postgres
--

ALTER TABLE ONLY accounting.journal_entries
    ADD CONSTRAINT fk_journal_entries_currency FOREIGN KEY (currency_id) REFERENCES accounting.currency(currency_id);


--
-- Name: journal_entry_lines fk_journal_entry_lines_gl_account; Type: FK CONSTRAINT; Schema: accounting; Owner: postgres
--

ALTER TABLE ONLY accounting.journal_entry_lines
    ADD CONSTRAINT fk_journal_entry_lines_gl_account FOREIGN KEY (gl_account_id) REFERENCES accounting.general_ledger_accounts(gl_account_id);


--
-- Name: journal_entry_lines fk_journal_entry_lines_journal; Type: FK CONSTRAINT; Schema: accounting; Owner: postgres
--

ALTER TABLE ONLY accounting.journal_entry_lines
    ADD CONSTRAINT fk_journal_entry_lines_journal FOREIGN KEY (journal_id) REFERENCES accounting.journal_entries(journal_id);


--
-- PostgreSQL database dump complete
--

