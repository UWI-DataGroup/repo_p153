clear
capture log close
cls

**  GENERAL DO-FILE COMMENTS
**  Program:		COVID_KABP_004.do
**  Project:      	COVID-19 KABP Barbados
**  Analyst:		Kern Rocke
**	Date Created:	22/05/2020
**	Date Modified: 	23/05/2020
**  Algorithm Task: HADS Descriptive Analysis - COVID 19 Conference (EAugustus)


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
use "`datapath'/version01/2-working/BarbadosCovid19_KABP_v2.dta", clear

/*Remove obs
Gender = Other
Missing Age
Missing Gender
q0002 != 1
*/
drop if q0002!=1 | gender==. | gender==0 | age==.

*Relabeling variables for HADS analysis
*Anxiety
label var q0034 "Tense"
label var q0035 "Frightened"
label var q0036 "Worrying"
label var q0037 "Relaxed"
label var q0038 "Butterflies"
label var q0039 "Restless"
label var q0040 "Panic"

*Depression
label var q0041 "Enjoy"
label var q0042 "Laugh"
label var q0043 "Cheeful"
label var q0044 "Slowed"
label var q0045 "Appearance"
label var q0046 "Look forward"
label var q0047 "Enjoy Book"


*Recode HADS variables
*Anxiety
recode q0034 (1=3) (2=2) (3=1) (4=0) //Reverse coded
recode q0035 (1=3) (2=2) (3=1) (4=0) //Reverse coded
recode q0036 (1=3) (2=2) (3=1) (4=0) //Reverse coded
recode q0037 (4=3) (3=2) (2=1) (1=0)
recode q0038 (1=3) (2=2) (3=1) (4=0) //Reverse coded
recode q0039 (1=3) (2=2) (3=1) (4=0) //Reverse coded
recode q0040 (1=3) (2=2) (3=1) (4=0) //Reverse coded

*Depression
recode q0041 (4=3) (3=2) (2=1) (1=0)
recode q0042 (4=3) (3=2) (2=1) (1=0)
recode q0043 (4=3) (3=2) (2=1) (1=0)
recode q0044 (1=3) (2=2) (3=1) (4=0) //Reverse coded
recode q0045 (1=3) (2=2) (3=1) (4=0) //Reverse coded
recode q0046 (1=3) (2=2) (3=1) (4=0)
recode q0047 (1=3) (2=2) (3=1) (4=0)

*Create value labels for HADS questions
					  
label define q0034 0 "Not at all" ///
				   1 "From time to time, occasionally" ///
				   2 "A lot of the time" ///
				   3 "Most of the time", modify
label value q0034 q0034
				   
				   
label define q0035 0 "Not at all" ///
				   1 "A little, but it doesn't worry me" ///
				   2 "Yes, but not too badly" ///
				   3 "Very definitely and quite badly" , modify
label value q0035 q0035

label define q0036 0 "Only occasionally" ///
				   1 "From time to time, but not too often" ///
				   2 "A lot of the time" ///
				   3 "A great deal of the time" , modify	
label value q0036 q0036
				   
label define q0037 0 "Definitely" ///
				   1 "Usually" ///
				   2 "Not Often" ///
				   3 "Not at all", modify 
label value q0037 q0037
				   
label define q0038 0 "Not at all" ///
				   1 "Occasionally" ///
				   2 "Quite Often" ///
				   3 "Very Often" , modify
label value q0038 q0038

label define q0039 0 "Not at all" ///
				   1 "Not very much" ///
				   2 "Quite a lot" ///
				   3 "Very much indeed" , modify				   
label value q0039 q0039
				   
label define q0040 0 "Not at all" ///
				   1 "Not very often" ///
				   2 "Quite often" ///
				   3 "Very often indeed" , modify				   
label value q0040 q0040
				   
label define q0041 0 "Definitely as much" ///
				   1 "Not quite so much" ///
				   2 "Only a little" ///
				   3 "Hardly at all" , modify				   
label value q0041 q0041

label define q0042 0 "As much as I always could" ///
				   1 "Not quite so much now" ///
				   2 "Definitely not so much now" ///
				   3 "Not at all", modify 				   
label value q0042 q0042

label define q0043 0 "Most of the time" ///
				   1 "Sometimes" ///
				   2 "Not often" ///
				   3 "Not at all", modify 
label value q0043 q0043
				   
label define q0044 0 "Not at all" ///
				   1 "Sometimes" ///
				   2 "Very often" ///
				   3 "Nearly all the time", modify 				   
label value q0044 q0044

label define q0045 0 "I take just as much care as ever" ///
				   1 "I may not take quite as much care" ///
				   2 "I don't take as much care as I should" ///
				   3 "Definitely" , modify				   
label value q0045 q0045

label define q0046 0 "As much as I ever did" ///
				   1 "Rather less than I used to" ///
				   2 "Defnitely less than I used to" ///
				   3 "Hardly at all" , modify				   
label value q0046 q0046
				   
label define q0047 0 "Often" ///
				   1 "Sometimes" ///
				   2 "Not often" ///
				   3 "Very seldom" , modify				   
label value q0047 q0047
				   
*Creating Value Label Definition
label define HADS 1"Non-case" 2"Borderline case" 3"Case"
label define case 0"normal" 1"case"

*Create Anxiety Variabels
gen anxiety = q0035 + q0037 + q0039 + q0041 + q0044 + q0045 + q0047
label var anxiety "Anxiety Scores"
gen anxiety_cat = anxiety
recode anxiety_cat (0/7=1) (8/10=2) (11/max=3)
label var anxiety_cat "Anxiety Categories"
label value anxiety_cat HADS
gen anxiety_case = anxiety
recode anxiety_case (min/7=0) (8/max=1)
label var anxiety_case "Anixeity Case Categories"
label value anxiety_case case


*Create Depression Variabels
gen depression = q0034 + q0036 + q0038 + q0040 + q0042 + q0043 + q0046
label var depression "Depression Scores"
gen depression_cat = depression
recode depression_cat (0/7=1) (8/10=2) (11/max=3)
label var depression_cat "Depression Categories"
label value depression_cat HADS
gen depression_case = depression
recode depression_case (min/7=0) (8/max=1)
label var depression_case "Depression Case Categories"
label value depression_case case

cls
mean anxiety
mean depression
tab anxiety_cat
tab anxiety_case
tab depression_cat
tab depression_case

*-------------------------------------------------------------------------------
/*
*SEM - gender and age
cls
sem (Anxiety -> q0035 q0037 q0039 q0041 q0044 q0045 q0047)  ////
	 (Anxiety -> sex, ) (Anxiety -> age, ) ///
	(Depression -> q0034 q0036 q0038 q0040 q0042 q0043 q0046 ) ///
	(Depression -> sex, ) (Depression -> age, ), ///
	standardized nolog
	covstruct(_lexogenous, diagonal) vce(robust) latent(Anxiety Depression ) ///
	cov( Anxiety*Depression) nocapslatent method(ml)

*Overall goodness of fit
estat gof, stats(all)
	
*Equation-level goodness of fit
estat eqgof
