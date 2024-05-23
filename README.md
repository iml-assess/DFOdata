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

devtools::install_github("iml-assess/DFOdata")

# Instructions to make a bridge with ODBC

1. install Oracle 12 Client (x64)
2. windows search "open ODBC DATA Source (64 bit)" and open as administrator
3. click on tab "system DSN", anc click add. Select ODBC.
4. create bridge with the following information:
    + DATA SOURCE NAME: IMLP / BIOCHEMP
    + DESCRIPTION: IMLP / BIOCHEMP
    + TNS SERVICE NAME: IMLP / BIOCHEMP
    + USER ID: *** 
5. click "test connection" or ok and provide password

# instructions to view Oracle databases with SQL developer

1. install SQL developer (available in software center)
2. select database (IMLPP / BIOCHEMP) in list
3. fill use/password


# Notes

*Reading in bio/length-frequency data.*
There are minor differences with data extracted with SAS/Majpec:
- empty lines (sample id = NA) are not included
- trivial differences in some lengths and weights due to rounding

# Version history
As of V1.2, get.bio results in 3 extra columns (length.type, station and remarks). Station numbers can be used to link with survey data (e.g., bottom trawl surveys).



