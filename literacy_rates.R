# file: literacy_rates.R
# 
# author: AJ
# twitter: dataparadigms
# web: http://www.dataparadigms.com
#
# description:
#   uses the SPARQL package to pull literacy rates by country from the 
#   linked data version of the CIA Factbook available at 
#   http://wifo5-03.informatik.uni-mannheim.de/factbook/
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
    ?litMale 
    ?litFemale 
    ((?litMale - ?litFemale) AS ?litDiff)
  WHERE { 
    ?resource factbook:literacy_female ?litFemale;
      factbook:literacy_male ?litMale; 
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

# make plot structure
p <- ggplot(data, aes(litFemale, litMale, 
                      label = label, 
                      color = litDiff, 
                      size = abs(litDiff))) 

# add in the geoms
p <- p + theme_bw() + 
      geom_text(position = "jitter") + 
      scale_color_gradient(low = "Blue", high = "Red", label = "") +
      scale_x_continuous(breaks = seq(0,100,10), 
                         limits = c(0,100)) + 
      scale_y_continuous(breaks = seq(0,100,10),
                         limites = c(0,100)) +
      labs(title = "Gender Literacy Rates",
           x = "Female Literacy Rate",
           y = "Male Literacy Rate") +
      theme(legend.position = "none") 

# add in the glm model overlay



# swap things around and perform plot etc based on the residual differences from 
# the model
  
