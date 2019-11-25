# EF DATA

data = read.table('/Users/Dylan/Desktop/EFdata.csv', sep = ',')

rownames(data) = c('NineBox','NebBarn','DelayAlt','Stroop','GoNoGo','ShapeSchool','SnackDelay')
colnames(data) = c('NineBox','NebBarn','DelayAlt','Stroop','GoNoGo','ShapeSchool','SnackDelay')


library(lavaan)

# Reformating as a matrix 
data2 = as.matrix(data)

# Converting correlations to covariances
data1SDs = c(1.58,0.61,3.62,0.29,0.52,0.42,24.18)
data1 = cor2cov(data2,data1SDs)


# 2 Factor Model
SFA1.lv = 'WorkMem =~ NineBox + NebBarn + DelayAlt
			Inhibition =~ Stroop + GoNoGo + ShapeSchool + SnackDelay
			            
            WorkMem ~~ 1*WorkMem
            Inhibition ~~ 1*Inhibition
            WorkMem~~Inhibition
            
            NineBox ~~ NineBox
            NebBarn ~~ NebBarn
            DelayAlt ~~ DelayAlt
            Stroop ~~ Stroop
            GoNoGo ~~ GoNoGo
            ShapeSchool ~~ ShapeSchool
            SnackDelay ~~ SnackDelay'
          
fit.SFA1.lv = lavaan(model=SFA1.lv, sample.cov = data1, sample.nobs=228, fixed.x=FALSE)

summary(fit.SFA1.lv)

fitMeasures(fit.SFA1.lv, fit.measures="all")

#lavaan (0.5-12) converged normally after  58 iterations
#
#  Number of observations                           228
#
#  Estimator                                         ML
#  Minimum Function Test Statistic               14.208
#  Degrees of freedom                                13
#  P-value (Chi-square)                           0.359
#
#Parameter estimates:
#
#  Information                                 Expected
# Standard Errors                             Standard
#
#                   Estimate  Std.err  Z-value  P(>|z|)
#Latent variables:
#  WorkMem =~
#    NineBox           0.383    0.138    2.773    0.006
#    NebBarn           0.378    0.069    5.458    0.000
#    DelayAlt          1.180    0.317    3.721    0.000
#  Inhibition =~
#    Stroop            0.183    0.023    8.011    0.000
#    GoNoGo            0.211    0.041    5.182    0.000
#    ShapeSchool       0.265    0.033    8.010    0.000
#    SnackDelay        9.506    1.900    5.002    0.000
#
#Covariances:
#  WorkMem ~~
#    Inhibition        0.736    0.127    5.814    0.000
#
#Variances:
#    WorkMem           1.000
#    Inhibition        1.000
#    NineBox           2.339    0.230
#    NebBarn           0.228    0.049
#    DelayAlt         11.654    1.204
#    Stroop            0.050    0.007
#    GoNoGo            0.224    0.023
#    ShapeSchool       0.106    0.015
#    SnackDelay      491.749   50.747
#
#> fitMeasures(fit.SFA1.lv, fit.measures="all")
#             fmin             chisq                df            pvalue    baseline.chisq 
#            0.031            14.208            13.000             0.359           151.968 
#      baseline.df   baseline.pvalue               cfi               tli              nnfi 
#           21.000             0.000             0.991             0.985             0.985 
#              rfi               nfi              pnfi               ifi               rni 
#            0.849             0.907             0.561             0.991             0.991 
#             logl unrestricted.logl              npar               aic               bic 
#        -2574.327         -2567.223            15.000          5178.654          5230.094 
#           ntotal              bic2             rmsea    rmsea.ci.lower    rmsea.ci.upper 
#          228.000          5182.554             0.020             0.000             0.070 
#     rmsea.pvalue               rmr        rmr_nomean              srmr       srmr_nomean 
#            0.790             2.086             2.086             0.039             0.039 
#            cn_05             cn_01               gfi              agfi              pgfi 
#          359.839           445.308             0.983             0.964             0.457 
#              mfi              ecvi 
#            0.997             0.194 

# 2 Factor Model
SFA2.lv = 'EF =~ NineBox + NebBarn + DelayAlt + Stroop + GoNoGo + ShapeSchool + SnackDelay
			            
            EF ~~ 1*EF
            
            NineBox ~~ NineBox
            NebBarn ~~ NebBarn
            DelayAlt ~~ DelayAlt
            Stroop ~~ Stroop
            GoNoGo ~~ GoNoGo
            ShapeSchool ~~ ShapeSchool
            SnackDelay ~~ SnackDelay'
          
fit.SFA2.lv = lavaan(model=SFA2.lv, sample.cov = data1, sample.nobs=228, fixed.x=FALSE)

summary(fit.SFA2.lv)

fitMeasures(fit.SFA2.lv, fit.measures="all")

#lavaan (0.5-12) converged normally after  50 iterations
#
#  Number of observations                           228
#
#  Estimator                                         ML
#  Minimum Function Test Statistic               17.312
#  Degrees of freedom                                14
#  P-value (Chi-square)                           0.240
#
#Parameter estimates:
#
#  Information                                 Expected
#  Standard Errors                             Standard
#
#                   Estimate  Std.err  Z-value  P(>|z|)
#Latent variables:
#  EF =~
#    NineBox           0.260    0.126    2.060    0.039
#    NebBarn           0.293    0.047    6.203    0.000
#    DelayAlt          1.084    0.286    3.788    0.000
#    Stroop            0.182    0.022    8.129    0.000
#    GoNoGo            0.212    0.041    5.226    0.000
#    ShapeSchool       0.260    0.032    7.995    0.000
#    SnackDelay        9.227    1.892    4.876    0.000
#
#Variances:
#    EF                1.000
#    NineBox           2.418    0.230
#    NebBarn           0.285    0.031
#    DelayAlt         11.873    1.168
#    Stroop            0.050    0.007
#    GoNoGo            0.224    0.023
#    ShapeSchool       0.108    0.015
#    SnackDelay      496.978   50.793
#
 
#> fitMeasures(fit.SFA2.lv, fit.measures="all")
#             fmin             chisq                df            pvalue    baseline.chisq 
#            0.038            17.312            14.000             0.240           151.968 
#      baseline.df   baseline.pvalue               cfi               tli              nnfi 
#           21.000             0.000             0.975             0.962             0.962 
#              rfi               nfi              pnfi               ifi               rni 
#            0.829             0.886             0.591             0.976             0.975 
#             logl unrestricted.logl              npar               aic               bic 
#        -2575.878         -2567.223            14.000          5179.757          5227.768 
#           ntotal              bic2             rmsea    rmsea.ci.lower    rmsea.ci.upper 
#          228.000          5183.397             0.032             0.000             0.075 
#     rmsea.pvalue               rmr        rmr_nomean              srmr       srmr_nomean 
#            0.703             2.420             2.420             0.043             0.043 
#            cn_05             cn_01               gfi              agfi              pgfi 
#          312.937           384.800             0.980             0.959             0.490 
#              mfi              ecvi 
#            0.993             0.199 
