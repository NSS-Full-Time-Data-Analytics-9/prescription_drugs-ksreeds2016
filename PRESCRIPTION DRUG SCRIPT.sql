SELECT *
FROM prescriber
WHERE nppes_provider_city='NASHVILLE'
ORDER BY nppes_provider_last_org_name ASC

-- 1. 
-- a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.
   
SELECT total_claim_count,total_claim_count _ge65,npi
FROM prescription drugs
GROUP BY total_claim_count, npi
ORDER BY total_claim_count DESC

-- answer: NPI 1912011792, claim 4538 total

-- b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description, and the total number of claims.

SELECT nppes_provider_first_name, nppes_provider_last_org_name, specialty_description, total_claim_count
FROM prescriber
JOIN prescription
ON prescriber.npi=prescription.npi
ORDER BY total_claim_count DESC

2. 
-- a. Which specialty had the most total number of claims (totaled over all drugs)?

SELECT nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description, total_claim_count
FROM prescriber
JOIN prescription
ON prescriber.npi=prescription.npi
ORDER BY total_claim_count DESC

-- answer: Family practice 

-- b. Which specialty had the most total number of claims for opioids?

SELECT nppes_provider_first_name, nppes_provider_last_org_name, specialty_description, total_claim_count, drug.drug_name, opioid_drug_flag
FROM prescriber
JOIN prescription
ON prescriber.npi=prescription.npi
JOIN drug
ON prescription.drug_name = drug.drug_name
WHERE opioid_drug_flag= 'Y'
ORDER BY total_claim_count DESC

-- answer: family practice

-- c. **Challenge Question:** Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?

-- d. **Difficult Bonus:** *Do not attempt until you have solved all other problems!* For each specialty, report the percentage of total claims by that specialty which are for opioids. Which specialties have a high percentage of opioids?

3. 
-- a. Which drug (generic_name) had the highest total drug cost?

SELECT generic_name, total_drug_cost
FROM drug
JOIN prescription
ON drug.drug_name = prescription.drug_name
ORDER BY total_drug_cost DESC

-- answer: PIRFENIDONE at 282,917.30

-- b. Which drug (generic_name) has the hightest total cost per day? **Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.**

SELECT generic_name, total_day_supply, ROUND(total_drug_cost,2) AS drug_cost
FROM drug
LEFT JOIN prescription
ON drug.drug_name = prescription.drug_name
ORDER BY total_day_supply DESC

-- answer: levothyroxine sodium

4. 
-- a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs.

SELECT drug_name, opioid_drug_flag AS opioid, antibiotic_drug_flag AS antibiotic
FROM drug
WHERE opioid_drug_flag = 'Y' or antibiotic_drug_flag = 'Y'

-- b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. Hint: Format the total costs as MONEY for easier comparision.

5. 
-- a. How many CBSAs are in Tennessee? **Warning:** The cbsa table contains information for all states, not just Tennessee.

SELECT COUNT(*)
FROM cbsa
WHERE cbsaname ILIKE '%TN%'

-- answer: 58

-- b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.

SELECT *
FROM population
LEFT JOIN cbsa ON population.fipscounty = cbsa.fipscounty
ORDER BY population DESC

-- answer: Highest CBSA name - Memphis TN-MS-AR w/population at 937847

SELECT *
FROM population
LEFT JOIN cbsa ON population.fipscounty = cbsa.fipscounty
WHERE cbsa IS NOT NULL
AND cbsaname IS NOT NULL
ORDER BY population ASC;

-- answer: Lowest CBSA name - Nashville-Davidson-Murfreesboro-Fanklin, TN w/population at 47169


-- c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.

SELECT *
FROM population
LEFT JOIN cbsa ON population.fipscounty = cbsa.fipscounty
ORDER BY population DESC

6. 
-- a. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.

SELECT drug_name, total_claim_count
FROM prescription
WHERE total_claim_count >=3000
ORDER BY total_claim_count DESC

-- answer: OXYCODONE HCL w/4538 claims 

-- b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.

SELECT prescription.drug_name AS drug , total_claim_count, opioid_drug_flag
FROM prescription
LEFT JOIN drug
ON prescription.drug_name = drug.drug_name
WHERE total_claim_count >=3000
AND opioid_drug_flag='Y'
ORDER BY total_claim_count DESC

-- answer: Oxycodone HCL & Hyrdrocodone

-- c. Add another column to you answer from the previous part which gives the prescriber first and last name associated with each row.

SELECT prescription.drug_name AS drug , total_claim_count, opioid_drug_flag, nppes_provider_last_org_name, nppes_provider_first_name
FROM drug
LEFT JOIN prescription
ON drug.drug_name = prescription.drug_name
LEFT JOIN prescriber
ON prescription.npi=prescriber.npi
WHERE total_claim_count >=3000
AND opioid_drug_flag='Y'
ORDER BY total_claim_count DESC

-- answer: David Coffey 

7. 
-- The goal of this exercise is to generate a full list of all pain management specialists in Nashville and the number of claims they had for each opioid. **Hint:** The results from all 3 parts will have 637 rows.
-- a. First, create a list of all npi/drug_name combinations for pain management specialists (specialty_description = 'Pain Managment') in the city of Nashville (nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opiod_drug_flag = 'Y'). **Warning:** Double-check your query before running it. You will only need to use the prescriber and drug tables since you don't need the claims numbers yet.

-- b. Next, report the number of claims per drug per prescriber. Be sure to include all combinations, whether or not the prescriber had any claims. You should report the npi, the drug name, and the number of claims (total_claim_count).

-- c. Finally, if you have not done so already, fill in any missing values for total_claim_count with 0. Hint - Google the COALESCE function.

SELECT prescriber.npi,specialty_description, nppes_provider_last_org_name, nppes_provider_first_name, nppes_provider_state, nppes_provider_city,prescription.drug_name,opioid_drug_flag,total_claim_count
FROM prescriber
LEFT JOIN prescription
ON prescriber.npi=prescription.npi
LEFT JOIN drug
ON prescription.drug_name=drug.drug_name
WHERE nppes_provider_city= 'NASHVILLE'
AND opioid_drug_flag= 'Y'
ORDER BY specialty_description DESC