data = read.csv('/Users/Dylan/Graduate School/Coursework/PSC205C Struct Eq Model/PTrainCov.csv', header = F)

rownames(data) = c('CDIUndSaysRaw','BayleyCogRaw','BayleyLang','DiffFamNov','Age')
colnames(data) = c('CDIUndSaysRaw','BayleyCogRaw','BayleyLang','DiffFamNov','Age')

data1 = as.matrix(data)

library(lavaan)

path1.lv = 'DiffFamNov ~ BayleyCogRaw + Age
            BayleyLang ~ DiffFamNov + BayleyCogRaw + Age
            CDIUndSaysRaw ~ DiffFamNov + BayleyCogRaw + Age
            
            CDIUndSaysRaw ~~ CDIUndSaysRaw
            BayleyCogRaw ~~ BayleyCogRaw
            BayleyLang ~~ BayleyLang
            DiffFamNov ~~ DiffFamNov
            Age ~~ Age
            
            Age ~~ BayleyCogRaw'
          
fit.path1.lv = lavaan(model=path1.lv, sample.cov = data1, sample.nobs=60, fixed.x=FALSE)

summary(fit.path1.lv)

#lavaan (0.5-12) converged normally after  91 iterations
#
#  Number of observations                            60
#
#  Estimator                                         ML
#  Minimum Function Test Statistic                0.025
#  Degrees of freedom                                 1
#  P-value (Chi-square)                           0.873
#
#Parameter estimates:
#
#  Information                                 Expected
#  Standard Errors                             Standard
#
#                   Estimate  Std.err  Z-value  P(>|z|)
#Regressions:
#  DiffFamNov ~
#    BayleyCogRaw     -0.077    0.099   -0.780    0.435
#    Age              -0.286    0.742   -0.385    0.700
#  BayleyLang ~
#    DiffFamNov        1.281    0.648    1.978    0.048
#    BayleyCogRaw      1.092    0.501    2.181    0.029
#    Age               1.343    3.727    0.360    0.719
#  CDIUndSaysRaw ~
#    DiffFamNov        9.550    5.419    1.762    0.078
#    BayleyCogRaw      8.603    4.188    2.054    0.040
#    Age              67.403   31.174    2.162    0.031
#
#Covariances:
#  BayleyCogRaw ~~
#    Age               0.527    0.260    2.031    0.042
#
#Variances:
#    CDIUndSaysRaw 13985.295 2553.354
#    BayleyCogRaw     14.495    2.646
#    BayleyLang      199.903   36.497
#    DiffFamNov        7.937    1.449
#    Age               0.260    0.047

fitMeasures(fit.path1.lv, fit.measures = "all")

#             fmin             chisq                df            pvalue    baseline.chisq 
#            0.000             0.025             1.000             0.873            26.143 
#      baseline.df   baseline.pvalue               cfi               tli              nnfi 
#           10.000             0.004             1.000             1.604             1.604 
#              rfi               nfi              pnfi               ifi               rni 
#            0.990             0.999             0.100             1.039             1.000 
#             logl unrestricted.logl              npar               aic               bic 
#         -970.590          -970.577            14.000          1969.180          1998.501 
#           ntotal              bic2             rmsea    rmsea.ci.lower    rmsea.ci.upper 
#           60.000          1954.467             0.000             0.000             0.177 
#     rmsea.pvalue               rmr        rmr_nomean              srmr       srmr_nomean 
#            0.882             8.887             8.887             0.004             0.004 
#            cn_05             cn_01               gfi              agfi              pgfi 
#         9063.634         15653.814             1.000             0.997             0.067 
#              mfi              ecvi 
#            1.008             0.467 
 

# Path Model #2 Programmed in Lavaan

path2.lv = 'DiffFamNov ~ BayleyCogRaw
            BayleyLang ~ DiffFamNov + BayleyCogRaw + Age
            CDIUndSaysRaw ~ DiffFamNov + BayleyCogRaw + Age
            
            CDIUndSaysRaw ~~ CDIUndSaysRaw
            BayleyCogRaw ~~ BayleyCogRaw
            BayleyLang ~~ BayleyLang
            DiffFamNov ~~ DiffFamNov
            Age ~~ Age
            
            Age ~~ BayleyCogRaw'
          
fit.path2.lv = lavaan(model=path2.lv, sample.cov = data1, sample.nobs=60, fixed.x=FALSE)

summary(fit.path2.lv)

#lavaan (0.5-12) converged normally after  84 iterations
#
#  Number of observations                            60
#
#  Estimator                                         ML
#  Minimum Function Test Statistic                0.174
#  Degrees of freedom                                 2
#  P-value (Chi-square)                           0.917
#
#Parameter estimates:
#
#  Information                                 Expected
#  Standard Errors                             Standard
#
#                   Estimate  Std.err  Z-value  P(>|z|)
#Regressions:
#  DiffFamNov ~
#    BayleyCogRaw     -0.088    0.096   -0.918    0.358
#  BayleyLang ~
#    DiffFamNov        1.281    0.647    1.980    0.048
#    BayleyCogRaw      1.092    0.501    2.178    0.029
#    Age               1.343    3.722    0.361    0.718
#  CDIUndSaysRaw ~
#    DiffFamNov        9.550    5.413    1.764    0.078
#    BayleyCogRaw      8.603    4.194    2.051    0.040
#    Age              67.403   31.136    2.165    0.030
#
#Covariances:
#  BayleyCogRaw ~~
#    Age               0.527    0.260    2.031    0.042
#
#Variances:
#    CDIUndSaysRaw 13985.295 2553.354
#    BayleyCogRaw     14.495    2.646
#    BayleyLang      199.903   36.497
#    DiffFamNov        7.956    1.453
#    Age               0.260    0.047

fitMeasures(fit.path2.lv, fit.measures = "all")

#             fmin             chisq                df            pvalue    baseline.chisq 
#            0.001             0.174             2.000             0.917            26.143 
#      baseline.df   baseline.pvalue               cfi               tli              nnfi 
#           10.000             0.004             1.000             1.566             1.566 
#              rfi               nfi              pnfi               ifi               rni 
#            0.967             0.993             0.199             1.076             1.000 
#             logl unrestricted.logl              npar               aic               bic 
#         -970.664          -970.577            13.000          1967.328          1994.555 
#           ntotal              bic2             rmsea    rmsea.ci.lower    rmsea.ci.upper 
#           60.000          1953.666             0.000             0.000             0.094 
#     rmsea.pvalue               rmr        rmr_nomean              srmr       srmr_nomean 
#            0.928            25.240            25.240             0.014             0.014 
#            cn_05             cn_01               gfi              agfi              pgfi 
#         2068.810          3179.728             0.999             0.991             0.133 
#              mfi              ecvi 
#            1.015             0.436 