<html>
<head>
<style>
table, th, td {
    border: 1px solid black;
    border-collapse: collapse;
}
</style>

</head>
<body>
<div id="header">

<!--CofC Logo-->
<a href="http://www.cofc.edu"><img src="https://lh3.googleusercontent.com/m-VgMx9Rzpj_Sx_ca88CPlD4_QbONpnfJo4I0rTiL1rn8o7lMOcP-0sys7EslT4L4JzUP2Mw2fw1hcJw645yRYwT5kitBkUUEYHkYbNs4RgTQeWS4oxunNtAz1HCsOnQGeQGYWdjdrVLy-u72SPg5dIeVxkQfkphhFb52oR5Iu2i2TK6RbvYNqKCIZCkAP0wH3vWf6-k7CtgYRcKHJUdi9-Z1fvsVDjKGG2PQIcYuQFRMhAKHL8Jbt4h13WLPJkOf78VU9cy7oTv4J77eCc1lrkTMYBNjBVJsfrZB_f5wViRxXTntXl5c84Rkt4aU7C1Kh08ugurmjJqBay1OOjPv66TLxNJSZmQs_MlHDikbrLvcgVCzoWyUkEDOzZFshD-xnZE-Jb-6rMmo8tUjMLrcZ_hR2G_w2NH7di5CHcWArUZnsG_o0OcNYSl7p5Jx6GISZfkMUkwLoRzU4eajd-kI9mwvO94BgefCUbpr1TwF-oRUSCv6nKDeAdcnElzTH86xiq-vIRMGiBK-1GgA7Liwe-GJGYXotaWA1iAVHjkrjoAcYjWAFdZv5PzfHypUSliCz4V1bdF3GK_TLjG8R6MV64QwvXI1lqeJwU4sQEO=s160-no" height="50" align="left" hspace="10px"></a>

<!--kaggle Logo-->
<a href="https://www.kaggle.com/"><img src="https://www.kaggle.com/content/v/4e5085eca1ab/kaggle/img/logos/kaggle-logo-transparent-300.png" height="50" align="right" hspace="10px"></a>

<!--Project Title-->
<h2><a id="Wine Review Analysis" class="anchor" aria-hidden="true"><span class="octicon octicon-link"></span></a>Wine Review Analysis</h2>
<h3><a id="CofC MATH 441 Spring 2018" class="anchor" aria-hidden="true"><span class="octicon octicon-link"></span></a>CofC MATH 441 Spring 2018</h3>
</div>
<br>

<!--Contributors-->
<h3>Contributors</h3>
<table style="width:50%">
  <tr>
    <td>John Brunzell</td>
    <td>Chris Ewald</td>    
    <td>Neal Sakash</td>
    <td>Jasmine Smallwood</td>
  </tr>
  <tr>
    <td><a><img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSP_84fFCa1wJX6vwgjiShxcda2clP4eouSKXF5QLq4ZJzaZ7Re" height="100" align="center" hspace="10px"></a></td>
    <td><a><img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSP_84fFCa1wJX6vwgjiShxcda2clP4eouSKXF5QLq4ZJzaZ7Re" height="100" align="center" hspace="10px"></a></td>
    <td><a href="https://github.com/npsakash"><img src="https://avatars0.githubusercontent.com/u/16137166?s=400&u=0f42f218054a840c726471d131017879fc6870a3&v=4" height="100" align="center" hspace="10px"></a></td>
<td><a href="https://github.com/JSmallwood7612"><img src="https://avatars3.githubusercontent.com/u/26583745?s=460&v=4" height="100" align="center" hspace="10px"></a></td>
              
  </tr>
</table>
        
<br>
    
<!--Contents-->
<h3>Contents</h3>
<ul>
<li><a class="active" href="#source-material"><u>Source Material</u></a></li>
<li><a class="active" href="#Abstract"><u>Abstract</u></a></li>
<li><a class="active" href="#project-details">Project Details</a></li>
<li><a class="active" href="#initial-data-analysis">Initial Data Analysis</a></li>
<li><a class="active" href="#applied-statisitical-models-against-the-dataset">Applied Statistical Models Against the Dataset</a></li>
<li><a class="active" href="#findings-and-conclusion">Findings and Conclusion</a></li>
</ul>
</div>
 <br>

<div id="section">

<h3><a id="source-material" class="anchor" href="#source-material" aria-hidden="true"><span class="octicon octicon-link"></span></a>Source Material</h3>
<dl>
<dt><a href="https://www.kaggle.com/zynicide/wine-reviews">Kaggle | Wine Reviews</a</dt>
</dl>

<h3>
<a id="Abstract" class="anchor" href="#Abstract" aria-hidden="true"><span class="octicon octicon-link"></span></a>Abstract</h3>

<p>
Using data gathered from Wine Enthusiast, Zack Thoutt tried to create a predictive model to identify wines through blind tasting like a master sommelier would.  His goal was to create a model that could identify the variety, winery, and location of a wine based on a description that a sommelier would give.  We decided to use some of the same data that Zack used to try and make a predictive model that could predict the price of a wine based on some predictor variables such as country or region of origin and point value assessed by a sommelier.
</p> 
<h3>
<a id="project-details" class="anchor" href="#project-details" aria-hidden="true"><span class="octicon octicon-link"></span></a>Project Details</h3>
<p>
Wine Enthusiast wine tasters and contributing editors tasted hundreds of thousands of wines from around the world.  Each wine was given a robust verbal description along with a wine rating and paired with the cost of the wine.  The wine rating was based on a scale developed by Robert M. Parker Jr. which uses a scale from 50 - 100.  This roughly translates to receiving a grade from A through F, with a 100 being the top and 50 being the bottom.  Our project focused on the analysis of a wine review dataset imported from the data science and machine learning hosting site Kaggle.  The dataset was curated by a Kaggle user after scraping the review website Wine Enthusiast.  Before preprocessing, the raw dataset used contained just under 130,000 entry rows and 10 descriptive columns of distinct wines found from all over the world. Prominent wine producing countries included the United States, France, Italy, Spain, Argentina, and Australia. Other descriptive columns included information relating to region, province, winery, as well as its US price and the rating/review given by each Wine Enthusiast taster. 
</p> 
<h3>
<a id="initial-data-analysis" class="anchor" href="#initial-data-analysis" aria-hidden="true"><span class="octicon octicon-link"></span></a>Initial Data Analysis</h3>

<p>
We began our project by cleaning and manipulating the dataset in order to help facilitate meaningful analysis.  We removed all entries with N/A or null values.  During this phase we did some transformations that allowed us to parse out a wine’s vintage.  To factor in the length of review, we also added a column that contained a numeric value that represented the character length of the review.  Lastly, we gathered the latitude, longitude and elevation from each distinct winery and merged this information to make our final data frame.
</p>
<p>
(Figure One)
(Sample of the cleaned dataset without the addition of the latitude-longitude data)
    </p>
    
<p>
Once we had all of the data we needed, we moved onto the data exploration phase. To better help understand the story, we attempted to visualize as much of it as we could.  Some of our initial analysis including looking at how the data was grouped and what types of distributions we might see.  
</p>
<p>
    (Figure Two)
(Point distribution of all wine in the dataset)

(Figure Three)
(Distribution of wine by country)

(Figure 4)
(Basic information from dataset)

We made the decision to narrow our focus to French and California wines.  With the understanding of the long battle between the two areas, we wanted to see if we could discover anything in particular that made one province stick out over the other. This led us into narrowing our visuals down to contain only data from the two areas.
</p>
<p>
Looking at the distributions of the price of French and California wines, we see there distributions are very similar.  This was important to note in that we were comparing wines with similar price distributions and not high-priced wines from one region against low-priced wines from another region.
    (Price Distributions)
</p>
<p>The case was similar when comparing the distributions of wine point values of French wines with California wines.  Again, the distributions were similar, so we were not comparing highly rated wines from one region against low rated wines from another region.
(Point Distributions)
</p>
    <p>One point to note with the data from the point distributions is that French wines have an average rating two-points higher than the average rating of California wines.  This could be a result of French wines being a little better on average than California wines, but it could also be a bias in the ratings given by the tasters who knew what wine they were tasting ahead of time.  However, when comparing the average ratings and prices of the four tasters, there appears to be no bias as the average points for all tasters was 84 for all wines, French wines, and California wines and the average price of the wine tasted for all tasters was $35 for all wines, French wines, and California wines.  </p>
<p>We also ran distributions on the varieties of wines from both France and California to see if there were any overlaps in the types of wines being produced by each region.
(Variety Distributions)
</p>
<p>These distributions for the varieties produced in France and California do show that there are wine varieties that are produced by both regions, so it would be possible to compare like wine types by region as well.  There bar graphs of wine produced also show that France produces a lot of specific wines whereas California produces a wide range of wines and only mass producing 2-3 types. This leads us to wonder whether the main difference between the two has something to do with market goals or if the wines that are being produced in large amounts are the wines scoring the highest or are they cheapest?  We believe further analysis would be able to answer some of these questions. 
</p>
<p>
While observing the price distributions, we noticed that it appeared that prices increased logarithmically with respect to their point values.  So, we looked at these to find this to be true.

    (Log-price by rating, French wines)		   (Log-price by rating, California wines)

With this in mind, we looked at the log-price with respect to the vintage and found no correlation with the price with respect to the wine’s vintage.  We also looked at the log-price with respect to latitude and found no correlation in the price with respect to the latitude.

    (Log-price by vintage, French wines)                           (Log-price by vintage, California wines)
   (Log-price by latitude, France)                                      (Log-price by latitude, California)

After making some initial observations based on the data, we moved forward to exploratory data analysis.  Our team set out to find associations with the price of various wines relative to their taster ratings, growing region, variety, and vintage. Machine learning techniques used for our analysis included random forest and tree classification, and stepwise, partial-least-squares, and lasso regression.

</p>

<h3>
<a id="applied-statisitical-models-against-the-dataset" class="anchor" href="#applied-statisitical-models-against-the-dataset" aria-hidden="true"><span class="octicon octicon-link"></span></a>Applied Statistical Models Against the Dataset</h3>
    <table>
        <tr>
        <th>Method</th>
        <th>France</th>
        <th>California</th>
        </tr>
        <tr>
            <th rowspan="2">PLS</th>
            <td>Mean Outsample Error: 0.3009265</td>
            <td>Mean Outsample Error: 0.247108</td>
        </tr>
        <tr>
<!--            <td></td>-->
            <td>Components: 3</td>
            <td>Components: 3</td>
        </tr>
        <tr></tr>
<!--        lasso-->
        <tr>
            <th rowspan="7">Lasso</th>
            <td>Mean Outsample Error: 0.3007747</td>
            <td>Mean Outsample Error: 0.2477594</td>
        </tr>
        <tr>
<!--            <td></td>-->
            <td>CV Lasso Coefs:</td>
            <td>CV Lasso Coefs:</td>
        </tr>
        <tr>
            <td>(Intercept)  -1.291215e+01</td>
            <td>(Intercept)  -6.308227e+00</td>
        </tr>
        <tr>
            <td>points  1.617092e-01</td>
            <td>points  9.996102e-02</td>
        </tr>
        <tr>
            <td>review_length  -1.222271e-03</td>
            <td>review_length 6.566235e-04</td>
        </tr>
        <tr>
            <td>elevation 4.038411e-04</td>
            <td>elevation  6.897244e-05</td>
        </tr>
        <tr>
            <td>abs_latitude  4.863186e-02</td>
            <td>abs_latitude 1.949269e-02</td>
        </tr>
<!--        Step-->
        <tr>
            <th rowspan="7">Step</th>
            <td>Mean Outsample Error: 0.8089517</td>
            <td>Mean Outsample Error: 0.5525468</td>
        </tr>
        <tr>
            <td>Step Coefs:</td>
            <td>Step Coefs:</td>
        </tr>
        <tr>
            <td>(Intercept)  -1.366806e+01</td>
            <td>(Intercept)  -6.6027099086  </td>
        </tr>
        <tr>
            <td>points  1.693462e-01</td>
            <td>points  0.1013407916</td>
        </tr>
        <tr>
            <td>abs_latitude  5.180491e-02</td>
            <td>abs_latitude  0.0233231990</td>
        </tr>
        <tr>
            <td>review_length  -1.594942e-03</td>
            <td>review_length   0.0007419274</td>
        </tr>
        <tr>
            <td>elevation  4.839848e-04</td>
            <td>elevation  0.0001137839</td>
        </tr>
<!--        TreeCV-->
        <tr>
            <th>TreeCV</th>
            <td>Mean Outsample Error 0.1931049</td>
            <td>Mean Outsample Error 0.215169</td>
        </tr>
        <tr>
            <th>Random Forest</th>
            <td>Mean Outsample Error 0.11385284</td>
            <td>Mean Outsample Error 0.1517635</td>
        </tr>
    </table>

<p>
With the models applied to both French and California wines, we notice that our sample error with the step dropped significantly to almost suspicious levels.  This most likely means that our tree models are creating a mess of error.  Lasso performs well, with points remaining as the largest explainer of variability in log price.  If we run the tree models, our mean outsample squared error drops significantly.  This likely indicates that there were too many levels in the categorical data, thus causing us to limit the number of unique categorical variables.
</p> 


<p>When running the TreeCV model, we obtained the following trees:

(TreeCV – French wines predicting log-price)
Interestingly enough, French wines have the most effective split beginning with region.  Our cross-validated tree for classifying log of price suggests that wines within Alsace, Bordeaux, Loire Valley, and Southwest France are less expensive (Burgandy and Champagne are the others).  More importantly, this is a better classifier than first splitting with points, which we continuously see as a strong indicator of price in other models.

(TreeCV – California wines predicting log-price)
The highest split for California wines is at points less than 90, which makes sense since one of our best predictors of log_price is points.  One thing to note though is that on the left side of the tree, we split by abs_latitude three times, which may be overfitting the groups.  These groups translate to northern California (38th), the San Francisco area (greater than 37th, less than 38th), and southern California (LA, San Diego) (less than 33rd).   It indicates that wines in northern California are more expensive, but like I said, maybe overfitting.  On the right branch we see taster_name as a split for wines with points greater than 92.  This is interesting to suggest that the taster themselves may indicate the price of wine.  For example, only the top wines are tasted by the top tasters. 

Random forest barely reduces the outsample error and loses the interpretability of the cv tree model, so this doesn’t help us much.
</p>

<h3>
<a id="findings-and-conclusion" class="anchor" href="#findings-and-conclusion" aria-hidden="true"><span class="octicon octicon-link"></span></a>Findings and Conclusion</h3>
<p>The random forest produced the best results for determining price; however, the tree using cross validation was very close and took less time while providing better interpretability than did the random forest.  Both the random forest and the cross validated tree were much better at predicting price which is what would be expected with the use of many categorical variables that do not follow a linear model.
    </p>
<p>
From the TreeCV on French wines, the highest node purity came on province, with this being the first split.  The highest wine prices came from the two French regions, Champagne and Burgundy.  This leads us to believe that higher priced French wines may be based on region.  The next separation was based on points, which is what we would expect that higher rated wines would produce higher costs.  
    </p>
    <p>
From the TreeCV on California wines, the highest node purity came on points, with this being the first split.  This is what we initially would expect that higher rated wines would cost more.  This leads us to believe that higher priced California wines are based on quality.  This tree also separated the California wines based on region, Northern California, San Francisco, and Los Angeles.
    </p>
    <p>
After comparing the TreeCV on French and California wines, our initial question might be, “Are French wines priced on where they come from whereas California wines are priced based on quality?”  Overall, we were satisfied with the performance of the TreeCV and Random Forest as a predictive model for determining the price of a French or California wine.  
    </p>
    <p>
With more time and additional analysis, we might be able to determine if French wines are truly priced based on locations and if California wines are priced based on rating.  Another area that could be further analyzed would be comparing similar varieties from these two regions to determine, for example, if French Pinot Noir’s are of better quality and/or higher priced than California Pinot Noir’s.
</p>

</div>
</body>
</html>

