## Pathways towards more sustainable food systems proposed by countries at the UNFSS

Analysis as a part of the IPBES Nexus Assessment - Chapter 5.food

Author: Andrea Pacheco (pacheco.gracia@gmail.com)


This repository contains the data and code to generate the treemap that visualizes the pathways towards more sustainable food systems - and their connections to nexus elements - proposed during the UN Food Systems Summit (UNFSS)

### Steps in this analysis:
1. Downloading data from the FAO's site about the UNFSS https://datalab.fao.org/datalab/dashboard/food-systems-summit/
2. Cleaning and processing the data, which considers the "Measures.in.Pathways" to be the variable of interest, removing duplicate rows, and grouping this variable by the columns "Nexus" and "Theme" (see the code "analyze.country-foodROs.R" for details)
3. Plotting the _**treemap**_, which is a way to visualize data in rectangular "boxes" that are organized by a hierarchy.
    - Here, the rectangles we plot are the **Themes** of pathways proposed by countries during the UNFSS.
    - The **size of these rectangles is determined by the number of countries** that proposed pathways (Measures.in.Pathway) under a given theme. Themes are grouped per each of the element of the nexus (this categorization was carried out by the chapter experts). 

Note the following abbreviations used in the treemap:
- RGSS = Restoring grasslands and shrublands and savannahs
- RSV = Resilience to Stress and Vulnerabilities


This repository is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License. 
