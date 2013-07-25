# file: literacy_rates_prediction.R
# 
# author: AJ
# twitter: dataparadigms
# web: http://www.dataparadigms.com
#
# description:
#   uses the SPARQL package to pull literacy rates by country from the 
#   linked data version of the CIA Factbook available at 
#   http://wifo5-03.informatik.uni-mannheim.de/factbook/
#   prediction fun
#   
# notes:
#   SPARQL endpoint often runs into server issues and is unable to 'create
#   threads'. 
library(SPARQL)
library(ggplot2)

# set up namespace prefixes
pre <- "
PREFIX db: <http://wifo5-04.informatik.uni-mannheim.de/factbook/resource/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX d2r: <http://sites.wiwiss.fu-berlin.de/suhl/bizer/d2r-server/config.rdf#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX map: <file:/var/www/wbsg.de/factbook/factbook.n3#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX factbook: <http://wifo5-04.informatik.uni-mannheim.de/factbook/ns#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>"

# actual query
SPARQL <- '
SELECT 
  DISTINCT ?label 
    ?litMale ?litFemale ?lit_total
    ((?litMale - ?litFemale) AS ?litDiff)
    ?infmort_female ?infmort_male ?infmort_total
    ?inflation
    ?life_female ?life_male ?life_total
    ?medage_female ?medage_male ?medage_total
    ?below_poverty
    ?pop_growth
    ?pop_total
    ?unemploy_rate
    ?mf_ratio
  WHERE { 
    ?resource factbook:literacy_female ?litFemale;
      factbook:literacy_male ?litMale;
      factbook:literacy_totalpopulation ?lit_total;
      factbook:infantmortalityrate_female ?infmort_female;
      factbook:infantmortalityrate_male ?infmort_male;
      factbook:infantmortalityrate_total ?infmort_total;
      factbook:inflationrate_consumerprices ?inflation;
      factbook:lifeexpectancyatbirth_female ?life_female;
      factbook:lifeexpectancyatbirth_male ?life_male;
      factbook:lifeexpectancyatbirth_totalpopulation ?life_total;
      factbook:medianage_female ?medage_female;
      factbook:medianage_male ?medage_male;
      factbook:medianage_total ?medage_total;
      factbook:populationbelowpovertyline ?below_poverty;
      factbook:populationgrowthrate ?pop_growth;
      factbook:population_total ?pop_total;
      factbook:unemploymentrate ?unemploy_rate;
      factbook:sexratio_15_64years ?mf_ratio;
      rdfs:label ?label . }'

# put them together
query <- paste(pre, SPARQL)

# grab the data
data <- SPARQL(url = "http://wifo5-04.informatik.uni-mannheim.de/factbook/sparql",
         query = query)

# convert from 
data <- as.data.frame(data$results)

# output the data
#save(data, file = "factbook.RData")
load("factbook.RData")


