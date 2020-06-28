clear
capture log close
cls

**  GENERAL DO-FILE COMMENTS
**  Program:		COVID_KABP_005.do
**  Project:      	LGTBQI COVID-19 KABP 
**  Analyst:		Kern Rocke
**	Date Created:	28/06/2020
**	Date Modified: 	28/06/2020
**  Algorithm Task: Analysis for Patient Health Questionnaire-4 (for CGeorge & EAugustus)


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 200


*Setting working directories

*MAC OS
**Datasets to encrypted folder
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p153"
**Logfiles to unencrypted folder
local logpath "/Volumes/Secomba/kernrocke/Boxcryptor/OneDrive - The University of the West Indies/Github Repositories/repo_p153"
**Result outputs to unencrypted folder
local outputpath "/Volumes/Secomba/kernrocke/Boxcryptor/The University of the West Indies/DataGroup - PROJECT_p153/05_Outputs"
cd "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p153"

** Close any open log files and open new log file
capture log close


*Load in data from encrypted location
use "/Users/kernrocke/Downloads/LGBT COVID-19edenSurvey.dta"


*Create variable for PHQ_2
egen PHQ_2 = rowtotal(q0021 q0022)
label var PHQ_2 "Depression"

*Create variable for GAD-2
egen GAD_2 = rowtotal(q0019 q0020)
label var GAD_2 "Anxiety"

*Create variable for PHQ-4
egen PHQ_4 = rowtotal(q0019 q0020 q0021 q0022)
label var PHQ_4 "Patient Health Questionnaire"

gen PHQ_cat =.
replace PHQ_cat = 1 if PHQ_4>=6
replace PHQ_cat = 1 if PHQ_2>=3 | GAD_2>=3
replace PHQ_cat = 2 if PHQ_4>=9
replace PHQ_cat = 2 if PHQ_2>=5 | GAD_2>=5
label var PHQ_cat "Patient Helath Questionnaire Categories"
label define PHQ_cat 1"Yellow-flag" 2"Red-flag"
label value PHQ_cat PHQ_cat

*-------------------------------------------------------------------------------

*Showing frequencies for PHQ-4 variables
tab1 q0019- q0022  

*Reliability of PHQ-4
alpha q0019- q0022 


*Descriptives

**Overall
tabstat PHQ_2 GAD_2 PHQ_4, stat(mean sem) col(stat) long format(%9.2f)
tab PHQ_cat

*Assoication between each PHQ variable and COVID bioweapon
foreach x in q0019 q0020 q0021 q0022 PHQ_cat {

	tab `x' q0062, col chi2
	
	}
	
*Differences in PHQ-4 scores for COVID bioweapon
foreach y in PHQ_2 GAD_2 PHQ_4 {

	ttest `y', by(q0062)
	
	}
*-------------------------------------------------------------------------------




