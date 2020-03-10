## Summary of the Visualization of Broadband Internet Rate

The data was collected by American Community Survey Program and downloaded from United States Census Bureau.

The tables of TYPES OF COMPUTERS AND INTERNET SUBSCRIPTIONS record the estimates from 2015 to 2018. The items, however, are different between 2015 and the following years. Therefore, I only downloaded the data from 2016-2018.

Before visualizing, I roughly extract the estimates using Python to simplify the process and relief the storage pressure  in tableau.

I focus more on braodband internet, which includs cellular data plan, cable/fiber optic/DSL and satellite internet service. 

Based on the statistics, I use tableau to build a dashboard containing

1. the US map colored by broadband internet own rate
2. Selected state map colored by broadband internet own rate in 2018
3. The proportion of different types of broadband internet
4. The broadband internet own rate by different household annual income

When altering year, 1, 3, 4 will vary to show the situation in different years.

When changing to state level, user can select specific state to see the state level situation.

Here I provide some basic findings

**Findings nationwide**:

- Broadband internet own rate are increasing nationwide. Unitil 2018, only 5 states were below 80%. 
- More than 70% households with broadband internet used cellular data and other broadband internet.
- The broadband own rate was higher in rich families. Meanwhile, the increasing speed of the broadband internet own rate in lower salary family was fastest, from 56% in 2016 to 62% in 2018.

**Findings in Utah 2018 (state with highest own rate in 2018)**:

- The broadband internet own rate in Daggett County was 92.4%. Still, counties in the south still had low own rate.
- The broadband internet own rate in lower salary family of Utah State was 68%, 6% higher than the nationwide data.

**Findings in Mississippi 2018 (state with lowest own rate in 2018)**:

- 83.5% broadband internet own rate in Daggett County was the highest in the state. The broadband own rate in most of the counties were lower than 80%, even lower than 70%. The lowest rate were 38.4% in Holmes County.
- More than 90% broadband users used cellular data plan. However the proportion of households only use cellular data plan was higher than the nationwide statistics.
- The gap between the broadband internet own rate in higher salary family of Mississippi  State and nationwide data was not so big. For lower salary family, the gap was more obvious and may be the reason for the low broadband rate in the state.



