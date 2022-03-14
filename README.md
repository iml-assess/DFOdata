# DFOdata

Package to extract data from oracle databases.

*under construction*
*Should work for all species in databases. Only tested for mackerel so far*

# Key functionality

From commercial sample database (pse_iml_ro)
- read in biological data ("carbio")
	function: get.bio
- read in length-frequency data 
	function: get.lf

Other functions to add when needed.

# Installation

devtools::install_github("iml-assess/DFOdata")

# Instructions to make a bridge with ODBC

1. install Oracle 12 Client (x64)
2. windows search "open ODBC DATA Source (64 bit)" and open as administrator
3. click on tab "system DSN", anc click add. Select ODBC.
4. create bridge with the following information:
	DATA SOURCE NAME: IMLP
	DESCRIPTION: IMLP
	TNS SERVICE NAME: IMLP
	USER ID: *** 
5. click "test connection" or ok and provide password ***

# instructions to view Oracle databases with DBeaver

1. install Dbeaver
2. connect to database -> odbc
3. fill in fields.

On the left side all tables in the database are indicated. Click on the main table (between ORDSYS and SDE) and then "Tables". All tables can be explored through e.g. right-click "View Table" or "Export Table".

# Notes

*Reading in bio/length-frequency data.*
There are minor differences with data extracted with SAS/Majpec:
- empty lines (sample id = NA) are not included
- trivial differences in some lengths and weights due to rounding



