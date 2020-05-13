clear
capture log close
cls

**  GENERAL DO-FILE COMMENTS
**  Program:		COVID_KABP_002.do
**  Project:      	COVID-19 KABP Barbados
**  Analyst:		Kern Rocke
**	Date Created:	12/05/2020
**	Date Modified: 	12/05/2020
**  Algorithm Task: Inital Descriptives for MoHW


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 200

/*
NOTE:
The working directories here are set to both Windows and MAC OS

Thus before running this algorithm please ensure the appropriate *
are place under either MAC OS or Windows OS

For example if you are using Windows
Remove the * from all the code below WINDOW OS but leave the * under
MAC OS

*/


*Setting working directories

*WINDOWS OS
**Datasets to encrypted folder
local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p153"
**Graph outputs to encrypted folder
local outputpath "X:/The University of the West Indies/DataGroup - repo_data/data_p153/version01/3-output"
cd "X:/The University of the West Indies/DataGroup - repo_data/data_p153"

*MAC OS
**Datasets to encrypted folder
*local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p153"
**Logfiles to unencrypted folder
*local logpath "/Volumes/Secomba/kernrocke/Boxcryptor/OneDrive - The University of the West Indies/Github Repositories/repo_p153"
**Graph outputs to encrypted folder
*local outputpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p153/version01/3-output"
*cd "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p153"

** Close any open log files and open new log file
capture log close
*log using "`logpath'/COVID_BIM_KABP_Descriptives", replace


*Load in data from encrypted location
use "`datapath'/version01/1-input/BarbadosCovid19_KABP.dta", clear

/*
This algorithm provides basic descriptives for key variables for reporting of 
results of the COVID-19 KABP Barbados study. 
*/


*-------------------------------------------------------------------------------

*Descriptives

*Age
rename q0001 age
destring age, replace

*Age categories (10-year bands)
gen agegrp = age
recode agegrp (18/29=1) (30/39=2) (40/49=3) (50/59=4) (60/69=5) (70/max=6)
label var agegrp "Age Category (10-year bands)"
label define agegrp 1	"18-29" ///
					2	"30-39" ///
					3	"40-49" ///
					4	"50-59" ///
					5	"60-69" ///
					6	"70 & over"
label value agegrp agegrp


//Keep male and female
rename q0004 gender
gen sex = .
replace sex =1 if gender == 1 // Female
replace sex =2 if gender == 2 // Male
label var sex "Sex"
label define sex 1"Female" 2"Male"
label value sex sex
*Note others (transgender women; gender fluid)

*Education
gen education = .
replace education = 1 if q0012 == 1 //no primary school
replace education = 1 if q0012 == 2 //primary school
replace education = 2 if q0012 == 3 //some secondary school
replace education = 2 if q0012 == 4 //completed secondary school
replace education = 3 if q0012 == 5 //polytechnic/ BCC
replace education = 4 if q0012 == 6 //University
label var education "Education"
label define education 1"Primary/less" 2"Secondary" 3"Polytechnic/BCC" 4"University"
label value education education
*How should we deal with q0012_other [other education]   CH: there are 196 text entries that could be backcoded, but I don't think we should have to do that now. ///
I think it could have been avoided if the wording was more clear (e.g. stressed highest completed level). I will make a note when we present results

*Ethnicity
gen ethnic = . 
replace ethnic = 1 if q0013 == 1 // Black or African-decent
replace ethnic = 2 if q0013 == 5 // Indo-decent
replace ethnic = 3 if q0013 == 7 // Multiracial
replace ethnic = 4 if q0013 == 4 // White
replace ethnic = 5 if q0013 == 0 // Other
replace ethnic = 5 if q0013 == 2 // Other
replace ethnic = 5 if q0013 == 3 // Other
replace ethnic = 5 if q0013 == 8 // Other
label var ethnic "Ethnic Groups"
label define ethnic 1"Black or African" ///
					2"Indo-decent" ///
					3"Multiracial" ///
					4"White" ///
					5"Other"
label value ethnic ethnic

*Religion
gen religion = .
replace religion = 1 if q0014 == 1 // Anglican
replace religion = 2 if q0014 == 2 // Catholic
replace religion = 3 if q0014 == 3 // Baptist
replace religion = 4 if q0014 == 4 // Seventh Day Adventist
replace religion = 5 if q0014 == 5 // Muslim
replace religion = 6 if q0014 == 6 // Rastafarian
replace religion = 7 if q0014 == 7 // Hindu
replace religion = 8 if q0014 == 0 // Other
label var religion "Religion"
label define religion 1"Anglican" ///
					  2"Roman Catholic" ///
					  3"Baptist" ///
					  4"Seventh Day Adventist" ///
					  5"Muslim" /// 
					  6"Rastafarian" ///
					  7"Hindu" ///
					  8"Other"
label value religion religion


*Employment
rename q0015 employment
replace employment = 8 if employment == 0
label define q0015 8"Other", modify
label value employment q0015

*Parent guardian of children
gen parent_child = . 
replace parent_child = 1 if q0020_0001 == 1 // Under 6 months old
replace parent_child = 2 if q0020_0002 == 1 // Between 6 and 12 months
replace parent_child = 3 if q0020_0003 == 1 // More than 1 year to 5 years old
replace parent_child = 4 if q0020_0004 == 1 // 6 years to 10 years old
replace parent_child = 5 if q0020_0005 == 1 // 11 years to 15 years old
replace parent_child = 6 if q0020_0006 == 1 // 16 years to 18 years old
replace parent_child = 7 if q0020_0007 == 1 // Older than 18
replace parent_child = 8 if q0020_0008 == 1 // I do not have children
label var parent_child "Are you the parent/ guardian of children of any of the following ages?"
label define parent_child 1 "Under 6 months old" ///
						  2 "Between 6 and 12 months" ///
						  3 "More than 1 year to 5 years old" ///
						  4 "6 years to 10 years old" ///
						  5 "11 years to 15 years old" ///
						  6 "16 years to 18 years old" ///
						  7 "Older than 18" ///
						  8 "I do not have children" 
label value parent_child parent_child
*Note: This question is multiple response and may need to be treated differently


*Job lost due to COVID-19
rename q0022 job_loss

*Savings to pay bills
rename q0023 save_bills
replace save_bills = 8 if save_bills == 0
label define q0023 8"Other", modify
label value save_bills q0023

*Work from home due to COVID
rename q0024 work_home
replace work_home = 5 if work_home == 0
label define q0024 5"Other", modify
label value work_home q0024

*Study from home due to COVID
rename q0025 study_home

//Essential workers
*Health workers
rename q0028 health_worker
*Essential worker
rename q0029 essential_worker

*Chronic Health conditions
gen health_condition = .
replace health_condition = 6 if q0031_0002 == 1 // Eye condititon
replace health_condition = 6 if q0031_0003 == 1 // Ear, nose and/ throat condition
replace health_condition = 5 if q0031_0004 == 1 // Cancer
replace health_condition = 6 if q0031_0005 == 1 // Epilepsy/Seizue
replace health_condition = 3 if q0031_0006 == 1 // Stroke
replace health_condition = 2 if q0031_0007 == 1 // Hypertension
replace health_condition = 3 if q0031_0008 == 1 // Heart disease
replace health_condition = 4 if q0031_0009 == 1 // Asthma
replace health_condition = 4 if q0031_0010 == 1 // Empysema, bronchitis
replace health_condition = 4 if q0031_0011 == 1 // Tuberculosis
replace health_condition = 6 if q0031_0012 == 1 // Thyroid glands
replace health_condition = 1 if q0031_0013 == 1 // Diabetes
replace health_condition = 6 if q0031_0014 == 1 // Hyperlipidemia
replace health_condition = 6 if q0031_0015 == 1 // Kidney condition
replace health_condition = 6 if q0031_0016 == 1 // Liver condition
replace health_condition = 6 if q0031_0017 == 1 // Bowel condition
replace health_condition = 6 if q0031_0018 == 1 // Anaemia
replace health_condition = 6 if q0031_0019 == 1 // Genetic blood disorder
replace health_condition = 6 if q0031_0020 == 1 // Skelettomuscular disorder
replace health_condition = 6 if q0031_0021 == 1 // Autoimmune disorder
replace health_condition = 6 if q0031_0022 == 1 // Skin coniditon
replace health_condition = 7 if q0031_0023 == 1 // Depression
replace health_condition = 7 if q0031_0024 == 1 // Anxiety
replace health_condition = 7 if q0031_0025 == 1 // Schizophrenia
replace health_condition = 6 if q0031_0028 == 1 // Other
replace health_condition = 8 if q0031_0001 == 1 // No health condition
label var health_condition "Health coniditions"
label define health_condition 1 "Diabetes" ///
							  2 "Hypertension" ///
							  3 "Heart Disease" ///
							  4 "Respiratory Disease" ///
							  5 "Cancer" ///
							  6 "Other" ///
							  7 "Mental Disease" ///
							  8 "No chronic conditions"
label value health_condition health_condition

//Heart Disease
gen heart_disease = .
replace heart_disease = 1 if q0031_0006 == 1 // Stroke
replace heart_disease = 1 if q0031_0008 == 1 // Heart disease
label var heart_disease "Heart Disease"
label define heart_disease 1 "Heart Disease"
label value heart_disease heart_disease

//Diabetes
gen diabetes = .
replace diabetes = 1 if q0031_0013 == 1 // Diabetes
label var diabetes "Diabetes"
label define diabetes 1 "Diabetes"
label value diabetes diabetes

//Hypertension
gen hypertension = .
replace hypertension = 1 if q0031_0007 == 1 // Hypertension
label var hypertension "Hypertension"
label define hypertension 1 "Hypertension"
label value hypertension hypertension

//Respiratory Disease
gen resp_disease = .
replace resp_disease = 1 if q0031_0010 == 1 // Empysema, bronchitis
replace resp_disease = 1 if q0031_0011 == 1 // Tuberculosis
replace resp_disease = 1 if q0031_0009 == 1 // Asthma
label var resp_disease "Respiratory Disease"
label define resp_disease 1 "Respiratory Disease"
label value resp_disease resp_disease

//Cancer
gen cancer = .
replace cancer = 1 if q0031_0004 == 1 // Cancer
label var cancer "Cancer"
label define cancer 1"Cancer"
label value cancer cancer

// Mental Health Disease
gen men_disease = .
replace men_disease = 1 if q0031_0023 == 1 // Depression
replace men_disease = 1 if q0031_0024 == 1 // Anxiety
replace men_disease = 1 if q0031_0025 == 1 // Schizophrenia
label var men_disease "Mental Health Disease"
label define men_disease 1" Mental Health Disease"
label value men_disease men_disease

//Other Disease
gen other_disease = .
replace other_disease = 1 if q0031_0002 == 1 // Eye condititon
replace other_disease = 1 if q0031_0003 == 1 // Ear, nose and/ throat condition
replace other_disease = 1 if q0031_0005 == 1 // Epilepsy/Seizue
replace other_disease = 1 if q0031_0012 == 1 // Thyroid glands
replace other_disease = 1 if q0031_0014 == 1 // Hyperlipidemia
replace other_disease = 1 if q0031_0015 == 1 // Kidney condition
replace other_disease = 1 if q0031_0016 == 1 // Liver condition
replace other_disease = 1 if q0031_0017 == 1 // Bowel condition
replace other_disease = 1 if q0031_0018 == 1 // Anaemia
replace other_disease = 1 if q0031_0019 == 1 // Genetic blood disorder
replace other_disease = 1 if q0031_0020 == 1 // Skelettomuscular disorder
replace other_disease = 1 if q0031_0021 == 1 // Autoimmune disorder
replace other_disease = 1 if q0031_0022 == 1 // Skin coniditon
replace other_disease = 1 if q0031_0028 == 1 // Other
label var other_disease "Other health condition"
label define other_disease 1 "Other"
label value other_disease other_disease

*Note: Should q0033 be analyzed?

*Worried about COVID-19
rename q0048 worried_covid

*Would like to be tested
rename q0050 test_interest

*Likely to be infected 
rename q0052 likely_infected

*Infection expectation
rename q0053 expect_infected

*Method of virus transmission
foreach x in q0054_0001 q0054_0002 q0054_0003 q0054_0004 q0054_0005 q0054_0006 ///
			 q0054_0007 q0054_0008 q0054_0009 q0054_0010 q0054_0011 {

recode `x' (1/2 =1) (4/5=2) (3=3) (6=4)
label define `x'       1 "Likely"  ///
					   2 "Unlikely"  ///
					   3 "Neither likely or unlikely" ///
					   4 "Don't know", modify
label value `x' `x'
}

*lockdown experience
gen lockexp=.
replace lockexp=1 if q0058_0001 !=. // It has affected my mental health
replace lockexp=2 if q0058_0002 !=. // I find it difficult to find my own space in my household
replace lockexp=3 if q0058_0003 !=. // I find it difficult to get supplies, (e.g. food, medicines, etc.)
replace lockexp=4 if q0058_0004 !=. // I am caring for others and cannot find someone to help out 
replace lockexp=5 if q0058_0005 !=. // It has affected my social life
replace lockexp=6 if q0058_0006 !=. // I have less money
replace lockexp=7 if q0058_0007 !=. // My studies or education has suffered
replace lockexp=8 if q0058_0008 !=. // Don't know
replace lockexp=9 if q0058_0009 !=. // No problem 
replace lockexp=10 if q0058_0010 !=. // Other
label variable lockexp "lockdown problems"
label define lockexp 1 "mental health" 2 "Space in household" 3 "Obtaining supplies" 4 "Carer with no help" 5 "Social life" 6 "financial" 7 "Impact on education" 8 "don't know" 9 "No problems" 10 "Other"
label values lockexp lockexp 

*Sources of information
gen infosource=.
replace infosource=1 if q0079_0001 !=. 
replace infosource=2 if q0079_0002 !=. 
replace infosource=3 if q0079_0003 !=. 
replace infosource=4 if q0079_0004 !=. 
replace infosource=5 if q0079_0005 !=. 
replace infosource=6 if q0079_0006 !=. 
replace infosource=7 if q0079_0007 !=. 
replace infosource=8 if q0079_0008 !=.
replace infosource=9 if q0079_0009 !=. 
replace infosource=10 if q0079_0010 !=. 
replace infosource=11 if q0079_0011 !=.  
replace infosource=12 if q0079_0012 !=.
replace infosource=13 if q0079_0013 !=. 
label variable infosource "Source of COVID information"
label define infosource 1 "newspaper" 2 "magazine" 3 "radio" 4 "CBC" 5 "International TV" 6 "Official websites" 7 "Unofficial websites" 8 "social media" 9 "My doctor" 10 "Other healthcare professional" 11 "family or friends" 12 "work or school" 13 "No information"
label values infosource infosource 

*Preference for information
gen infopref=.
replace infopref=1 if q0080_0001 !=. 
replace infopref=2 if q0080_0002 !=. 
replace infopref=3 if q0080_0003 !=. 
replace infopref=4 if q0080_0004 !=.  
replace infopref=5 if q0080_0005 !=. 
replace infopref=6 if q0080_0006 !=. 
replace infopref=7 if q0080_0007 !=. 
replace infopref=8 if q0080_0008 !=. 
replace infopref=9 if q0080_0009 !=. 
replace infopref=10 if q0080_0010 !=. 
replace infopref=11 if q0080_0011 !=. 
replace infopref=12 if q0080_0012 !=. 
replace infopref=13 if q0080_0013 !=. 
replace infopref=14 if q0080_0014 !=. 
label variable infopref "Preference for information"
label define infopref 1 "Research" 2 "Common signs" 3 "Less common signs" 4 "How to know if infected" 5 "Info on transmission" 6 "Info on prevention" 7 "High risk groups" 8 "Number of cases (Barbados)" 9 "Distribution cases (Bds)" 10 "Infection risk (Bds)" 11 "NPIs (Bds)" 12 "NPIs (Other countries)" 13 "NPIs (international organisations)" 14 "don't want info"
label values infopref infopref 



*PCOVID-19 Bioweapon
rename q0081 covid_bio

*-------------------------------------------------------------------------------
*clear screen for focus on result only
cls			  
*Overall Descriptives
tabstat age, stat(mean median min max) col(stat) format (%9.0f)
tab agegrp, miss
tab sex, miss 
tab education, miss
tab ethnic, miss 
tab religion, miss
tab employment, miss 
tab parent_child, miss 
tab1 q0020_0001 q0020_0002 q0020_0003 q0020_0004 q0020_0005 q0020_0006 ///
	 q0020_0007 q0020_0008
tab job_loss, miss 
tab save_bills, miss 
tab work_home, miss 
tab study_home, miss 
tab health_worker, miss 
tab essential_worker, miss 
tab health_condition, miss
tab1 diabetes hypertension heart_disease resp_disease cancer ///
	 men_disease other_disease
tab worried_covid, miss 
tab test_interest, miss 
tab likely_infected, miss 
tab expect_infected, miss 
*Method of virus transmission
tab1 q0054_0001 q0054_0002 q0054_0003 q0054_0004 q0054_0005 q0054_0006 ///
	 q0054_0007 q0054_0008 q0054_0009 q0054_0010 q0054_0011
*Protect against COVID-19
tab1 q0055_0001	q0055_0002 q0055_0003 q0055_0004 q0055_0005 q0055_0006 q0055_0007  ///
	 q0055_0008	q0055_0009 q0055_0010 q0055_0011 q0055_0012 q0055_0013 q0055_0014  ///
	 q0055_0015	q0055_0016 q0055_0017 q0055_0018 q0055_0019 q0055_0020 q0055_0021  ///
	 q0055_0022	q0055_0023 q0055_0024 
*Self-Isolate ability and willingness
tab1 q0056_0001 q0056_0002
*Lockdown preparation
tab1 q0057_0001 q0057_0002 q0057_0003 q0057_0004 q0057_0005 q0057_0006 q0057_0007 ///
	 q0057_0008
*Lockdown problems
tab1 q0058_0001 q0058_0002 q0058_0003 q0058_0004 q0058_0005 q0058_0006 q0058_0007 ///
	 q0058_0008 q0058_0009 q0058_0010 
tab lockexp, miss	
*Information Source on COVID-19
tab1 q0079_0001 q0079_0002 q0079_0003 q0079_0004 q0079_0005 q0079_0006 q0079_0007 ///
	 q0079_0008 q0079_0009 q0079_0010 q0079_0011 q0079_0012 q0079_0013 q0079_0014
tab infosource, miss
*Types of information on COVID-19 would like to receive	 
tab1 q0080_0001 q0080_0002 q0080_0003 q0080_0004 q0080_0005 q0080_0006 q0080_0007 ///
	 q0080_0008 q0080_0009 q0080_0010 q0080_0011 q0080_0012 q0080_0013 q0080_0014 ///
	 q0080_0015
tab infopref, miss 

**MISCONCEPTIONS
*COVID-19 Bioweapon
tab covid_bio, miss 
tab q0054_0010, miss
tab q0054_0011, miss

*------------------------------------------------------------------------------- 
*Cross-tabulations with sex

*Age
tabstat age, by(sex) stat(mean median min max) col(stat) format (%9.0f)

foreach a in agegrp education ethnic religion employment parent_child q0020_0001 ///
			 q0020_0002 q0020_0003 q0020_0004 q0020_0005 q0020_0006 q0020_0007 ///
			 q0020_0008 job_loss save_bills work_home study_home health_worker ///
			 essential_worker health_condition diabetes hypertension heart_disease ///
			 resp_disease cancer men_disease other_disease worried_covid test_interest ///
			 likely_infected expect_infected q0054_0001 q0054_0002 q0054_0003 q0054_0004 ///
			 q0054_0005 q0054_0006 q0054_0007 q0054_0008 q0054_0009 q0054_0010 q0054_0011 ///
			 q0055_0001 q0055_0002 q0055_0003 q0055_0004 q0055_0005 q0055_0006 q0055_0007 ///
			 q0055_0008 q0055_0009 q0055_0010 q0055_0011 q0055_0012 q0055_0013 q0055_0014 ///
			 q0055_0015 q0055_0016 q0055_0017 q0055_0018 q0055_0019 q0055_0020 q0055_0021 ///
			 q0055_0022 q0055_0023 q0055_0024 q0056_0001 q0056_0002 q0057_0001 q0057_0002 ///
			 q0057_0003 q0057_0004 q0057_0005 q0057_0006 q0057_0007 q0057_0008 q0058_0001 ///
			 q0058_0002 q0058_0003 q0058_0004 q0058_0005 q0058_0006 q0058_0007 q0058_0008 ///
			 q0058_0009 q0058_0010 q0060_0001 q0060_0002 q0060_0003 q0060_0004 q0060_0005 ///
			 q0060_0006 q0060_0007 q0060_0008 q0060_0009 q0060_0010 q0079_0001 q0079_0002 ///
			 q0079_0003 q0079_0004 q0079_0005 q0079_0006 q0079_0007 q0079_0008 q0079_0009 ///
			 q0079_0010 q0079_0011 q0079_0012 q0079_0013 q0079_0014 q0080_0001 q0080_0002 ///
			 q0080_0003 q0080_0004 q0080_0005 q0080_0006 q0080_0007 q0080_0008 q0080_0009 ///
			 q0080_0010 q0080_0011 q0080_0012 q0080_0013 q0080_0014 q0080_0015 ///
			 covid_bio {
			 
			 tab `a' sex, col
			 
			 }
/*-------------------------------------------------------------------------------	 
*Cross-tabulations with age group (10 year bands)

*Age
tabstat age, by(agegrp) stat(mean median min max) col(stat) format (%9.0f)

foreach a in sex education ethnic religion employment parent_child q0020_0001 ///
			 q0020_0002 q0020_0003 q0020_0004 q0020_0005 q0020_0006 q0020_0007 ///
			 q0020_0008 job_loss save_bills work_home study_home health_worker ///
			 essential_worker health_condition diabetes hypertension heart_disease ///
			 resp_disease cancer men_disease other_disease worried_covid test_interest ///
			 likely_infected expect_infected q0054_0001 q0054_0002 q0054_0003 q0054_0004 ///
			 q0054_0005 q0054_0006 q0054_0007 q0054_0008 q0054_0009 q0054_0010 q0054_0011 ///
			 q0055_0001 q0055_0002 q0055_0003 q0055_0004 q0055_0005 q0055_0006 q0055_0007 ///
			 q0055_0008 q0055_0009 q0055_0010 q0055_0011 q0055_0012 q0055_0013 q0055_0014 ///
			 q0055_0015 q0055_0016 q0055_0017 q0055_0018 q0055_0019 q0055_0020 q0055_0021 ///
			 q0055_0022 q0055_0023 q0055_0024 q0056_0001 q0056_0002 q0057_0001 q0057_0002 ///
			 q0057_0003 q0057_0004 q0057_0005 q0057_0006 q0057_0007 q0057_0008 q0058_0001 ///
			 q0058_0002 q0058_0003 q0058_0004 q0058_0005 q0058_0006 q0058_0007 q0058_0008 ///
			 q0058_0009 q0058_0010 q0060_0001 q0060_0002 q0060_0003 q0060_0004 q0060_0005 ///
			 q0060_0006 q0060_0007 q0060_0008 q0060_0009 q0060_0010 q0079_0001 q0079_0002 ///
			 q0079_0003 q0079_0004 q0079_0005 q0079_0006 q0079_0007 q0079_0008 q0079_0009 ///
			 q0079_0010 q0079_0011 q0079_0012 q0079_0013 q0079_0014 q0080_0001 q0080_0002 ///
			 q0080_0003 q0080_0004 q0080_0005 q0080_0006 q0080_0007 q0080_0008 q0080_0009 ///
			 q0080_0010 q0080_0011 q0080_0012 q0080_0013 q0080_0014 q0080_0015 ///
			 covid_bio {
			 
			 tab `a' agegrp, col
			 
			 }
*-------------------------------------------------------------------------------	 
*log close
	 
	 
	 
	 
