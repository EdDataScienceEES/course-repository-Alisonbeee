# Week 7

#### Class tutorials

* `Linear_mixed_models.R` [Intro to mixed effects models](https://ourcodingclub.github.io/2017/03/15/mixed-models.html)

#### Readings:

1. [There’s Madness in our Methods: Improving inference in ecology and evolution](https://methodsblog.wordpress.com/2015/11/26/madness-in-our-methods/)

2. [R for Data Science Part IV Model Chapters 22 - 25](http://r4ds.had.co.nz/model-basics.html)



# Mixed Effects Models Notes
#### What is mixed effects modelling and why does it matter?

* They where created to deal with messy data with low sample sizes, different grouping factors and many parameters.  
* Also mixed models can save the degrees of freedom.


#### Fixed and random effects
* It’s important to not that this difference has little to do with the variables themselves, and a lot to do with your research question! 
* Fixed effects are variables that we expect will have an effect on the dependent/response variable: (They’re what you call explanatory variables in a standard linear regression)
* Random effects are usually grouping factors for which we are trying to control. They are always **categorical**.
* The data for our random effect is just a sample of all the possibilities

*EXAMPLE: We don’t care about estimating how much better pupils in school A have done compared to pupils in school B, but we know that their respective teachers might be a reason why their scores would be different, and we’d like to know how much variation is attributable to this when we predict scores for pupils in school Z.*

#### More about random effects
* Note that the golden rule is that you generally want your random effect to have at least five levels. So, for instance, if we wanted to control for the effects of dragon’s sex on intelligence, we would fit sex (a two level factor: male or female) as a fixed, not random, effect.
- because estimating variance on few data points is very imprecise. 
* In the end, the big questions are: what are you trying to do? What are you trying to make predictions about? What is just variation (a.k.a “noise”) that you need to control for?


#### Crossed random effects 
Example: Let’s repeat with another example: an effect is (fully) crossed when all the subjects have experienced all the levels of that effect. For instance, if you had a fertilisation experiment on seedlings growing in a seasonal forest and took repeated measurements over time (say 3 years) in each season, you may want to have a crossed factor called season (Summer1, Autumn1, Winter1, Spring1, Summer2, …, Spring3), i.e. a factor for each season of each year. This grouping factor would account for the fact that all plants in the experiment, regardless of the fixed (treatment) effect (i.e. fertilised or not), may have experienced a very hot summer in the second year, or a very rainy spring in the third year, and those conditions could cause interference in the expected patterns. You don’t even need to have associated climate data to account for it! You just know that all observations from spring 3 may be more similar to each other because they experienced the same environmental quirks rather than because they’re responding to your treatment.

#### Nested random effects
If you’re not sure what nested random effects are, think of those Russian nesting dolls. We’ve already hinted that we call these models hierarchical: there’s often an element of scale, or sampling stratification in there.
Example: 5 leaves x 50 plants x 20 beds x 4 seasons x 3 years….. 60 000 measurements!
if you were to run the analysis using a simple linear regression, eg. leafLength ~ treatment , you would be committing the crime (!!) of pseudoreplication, or massively increasing your sampling size by using non-independent data. 
*It violates the assumption of independance of observations*
 
You could therefore add a random effect structure that accounts for this nesting:
`leafLength ~ treatment + (1|Bed/Plant/Leaf)`

What about the crossed effects we mentioned earlier?
`leafLength ~ treatment + (1|Bed/Plant/Leaf) + (1|Season)`


You will inevitably look for a way to assess your model though so here are a few solutions on how to go about hypothesis testing in linear mixed models (LMMs):

From worst to best:
* Wald Z-tests
* Wald t-tests (but LMMs need to be balanced and nested)
* Likelihood ratio tests (via anova() or drop1())
* MCMC or parametric bootstrap confidence intervals





