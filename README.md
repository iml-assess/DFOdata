# DFOdata

Package to extract data from DFO oracle databases.

# Key functionality
See example.Rmd

From commercial sample database (IMLP)
* read in biological data ("carbio") function: get.bio
    + mackerel
    + cod
    + needs validation for other species. 
        - See data-raw/odbc_data_selection.csv for details on what is extracted
* read in length-frequency data function: get.lf
    + mackerel
    + cod
    + needs validation for other species
        - See data-raw/odbc_data_selection.csv for details on what is extracted

From ichtyoplankton sample database (BIOCHEMP)
* read in bongo sample data (mackerel egg stations and counts): get.eggs

# Installation

1. Install "devtools" through an executable (download online) or the software manager
2. Install rools package directly in R
3. Make a bridge with ODBC;

	* install Oracle 12 Client (x64)
	* windows search "open ODBC DATA Source (64 bit)" and open as administrator/privelige manager
	* click on tab "system DSN", anc click add. Select ODBC.
	* create bridge with the following information (IMLP for get.bio and get.lf, BIOCHEMP for get.eggs):
		+ DATA SOURCE NAME: IMLP / BIOCHEMP
		+ TNS SERVICE NAME: OKENP27 / BIOCHEMP
		+ USER ID: *** 
	* click "test connection" or ok and provide password

4. Install DFOdata package in r, by copying the following code;
devtools::install_github("iml-assess/DFOdata")

# instructions to view Oracle databases with SQL developer

1. install SQL developer (available in software center) or alternative (e.g. DBeaver)
2. create new database connection
2. select database (IMLP / BIOCHEMP) in list
3. if using SQL developer, add connection info:
	+ Name: Pec_pro
	+ User name and pass 
	+ Host name: natp71.nat.dfo-mpo.ca
	+ Port: 1523
	+ Service name: OKENP27

# Notes

*Reading in bio/length-frequency data.*
There are minor differences with data extracted with SAS/Majpec:
- empty lines (sample id = NA) are not included
- trivial differences in some lengths and weights due to rounding

# Version history
As of V1.2, get.bio results in 3 extra columns (length.type, station and remarks). Station numbers can be used to link with survey data (e.g., bottom trawl surveys).



