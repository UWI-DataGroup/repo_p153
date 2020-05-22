clear
capture log close
cls

**  GENERAL DO-FILE COMMENTS
**  Program:		COVID_KABP_004.do
**  Project:      	COVID-19 KABP Barbados
**  Analyst:		Kern Rocke
**	Date Created:	22/05/2020
**	Date Modified: 	22 /05/2020
**  Algorithm Task: HADS Analysis 


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
use "`datapath'/version01/1-input/BarbadosCovid19_KABP.dta", clear

*Recode HADS variables
recode q0034 (4=0) (3=1) (2=2) (1=3)
recode q0035 (4=0) (3=1) (2=2) (1=3)
recode q0036 (4=0) (3=1) (2=2) (1=3)
recode q0037 (4=0) (3=1) (2=2) (1=3)
recode q0038 (4=0) (3=1) (2=2) (1=3)
recode q0039 (4=0) (3=1) (2=2) (1=3)
recode q0040 (4=3) (3=2) (2=1) (1=0) //Reverse coded
recode q0041 (4=0) (3=1) (2=2) (1=3)
recode q0042 (4=0) (3=1) (2=2) (1=3)
recode q0043 (4=3) (3=2) (2=1) (1=0) //Reverse coded
recode q0044 (4=0) (3=1) (2=2) (1=3)
recode q0045 (4=0) (3=1) (2=2) (1=3)
recode q0046 (4=0) (3=1) (2=2) (1=3)
recode q0047 (4=0) (3=1) (2=2) (1=3)

label define hads_rec 0 " Not at all" ///
					  1 "No, not much" ///
					  2 "Yes sometimnes" ///
					  3 "Yes definitiely"
					  
foreach x in q0034 q0035 q0036 q0037 q0038 q0039 q0040 ///
			 q0041 q0042 q0043 q0044 q0045 q0046 q0047 {
			 
	label value `x' hads_rec
	
	}


*Creating Value Label Definition
label define HADS 1"Non-case" 2"Borderline case" 3"Case"

*Create Anxiety Variabels
gen anxiety = q0035 + q0037 + q0039 + q0041 + q0044 + q0045 + q0047
label var anxiety "Anxiety Scores"

gen anxiety_cat = anxiety
recode anxiety_cat (0/7=1) (8/10=2) (11/max=3)
label var anxiety_cat "Anxiety Categories"
label value anxiety_cat HADS


*Create Depression Variabels
gen depression = q0034 + q0036 + q0038 + q0040 + q0042 + q0043 + q0046
label var depression "Depression Scores"
gen depression_cat = depression
recode depression_cat (0/7=1) (8/10=2) (11/max=3)
label var depression_cat "Depression Categories"
label value depression_cat HADS


cls
mean anxiety
mean depression
tab anxiety_cat
tab depression_cat



