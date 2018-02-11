
data = read.table('/Users/Dylan/Graduate School/Coursework/PSC205C Struct Eq Model/Final Project/Correlation Table.csv', sep = ',')

rownames(data) = c('MLU','WordRoot','RDLSComp','RDLSExpress','ELI','VABSComm','Gender','VABSSoc','MomWordRoot','MomMLU','MomVerb','Personality','ParentAtt','ParentKnow','SES')
colnames(data) = c('MLU','WordRoot','RDLSComp','RDLSExpress','ELI','VABSComm','Gender','VABSSoc','MomWordRoot','MomMLU','MomVerb', 'Personality','ParentAtt','ParentKnow','SES')

library(lavaan)

data = as.matrix(data)

# Converting correlations to covariances
dataSDs = c(0.31, 14.28, 1.13, 1.02, 107.83, 11.83, 0.50, 8.18, 32.55, 0.63, 12.66, 9.15, 0.44, 0.05, 10.25)
data1 = cor2cov(data,dataSDs)

# Model 1 Measurement (Initial Model From Borenstein et al)
LVP1.lv = 'MomVocab  =~ 1*MomMLU + MomWordRoot
           ChildVocab =~ 1*MLU + WordRoot + RDLSComp + RDLSExpress + ELI + VABSComm
           
           MomVocab ~~ MomVocab
           ChildVocab ~~ ChildVocab 
           
           MLU ~~ MLU
           WordRoot ~~ WordRoot
           RDLSComp ~~ RDLSComp
           RDLSExpress ~~ RDLSExpress
           ELI ~~ ELI
           VABSComm ~~ VABSComm 
           MomWordRoot ~~ MomWordRoot
           MomMLU ~~ 0*MomMLU
           
           MomVocab ~~ ChildVocab'


          
fit.LVP1.lv = lavaan(model=LVP1.lv, sample.cov = data1, sample.nobs=120, fixed.x=FALSE)

summary(fit.LVP1.lv)

fitMeasures(fit.LVP1.lv, fit.measures = 'all')

# lavaan (0.5-12) converged normally after 124 iterations
# 
#   Number of observations                           120
# 
#   Estimator                                         ML
#   Minimum Function Test Statistic               69.597
#   Degrees of freedom                                20
#   P-value (Chi-square)                           0.000
#
# Parameter estimates:
# 
#   Information                                 Expected
#   Standard Errors                             Standard
#
#                    Estimate  Std.err  Z-value  P(>|z|)
# Latent variables:
#   MomVocab =~
#     MomMLU            1.000
#     MomWordRoot      27.383    4.000    6.847    0.000
#   ChildVocab =~
#     MLU               1.000
#     WordRoot         93.897   24.353    3.856    0.000
#     RDLSComp          4.329    1.365    3.172    0.002
#     RDLSExpress       7.995    2.000    3.998    0.000
#     ELI             851.739  212.800    4.003    0.000
#     VABSComm         80.164   20.643    3.883    0.000
# 
# Covariances:
#   MomVocab ~~
#     ChildVocab        0.001    0.007    0.122    0.903
#
# Variances:
#     MomVocab          0.394    0.051
#     ChildVocab        0.013    0.006
#     MLU               0.083    0.011
#     WordRoot         90.580   13.290
#     RDLSComp          1.029    0.136
#     RDLSExpress       0.222    0.046
#     ELI            2344.440  506.943
#     VABSComm         57.412    8.606
#     MomWordRoot     755.539   97.540
#     MomMLU            0.000
#
# 
#  fitMeasures(fit.LVP1.lv, fit.measures = 'all')
#              fmin             chisq                df            pvalue    baseline.chisq       baseline.df 
#             0.290            69.597            20.000             0.000           434.751            28.000 
#   baseline.pvalue               cfi               tli              nnfi               rfi               nfi 
#             0.000             0.878             0.829             0.829             0.776             0.840 
#              pnfi               ifi               rni              logl unrestricted.logl              npar 
#             0.600             0.880             0.878         -2591.784         -2556.985            16.000 
#               aic               bic            ntotal              bic2             rmsea    rmsea.ci.lower 
#          5215.567          5260.167           120.000          5209.583             0.144             0.108 
#    rmsea.ci.upper      rmsea.pvalue               rmr        rmr_nomean              srmr       srmr_nomean 
#             0.181             0.000            96.875            96.875             0.083             0.083 
#             cn_05             cn_01               gfi              agfi              pgfi               mfi 
#            55.158            65.772             0.883             0.789             0.491             0.813 
#              ecvi 
#             0.847 
            
# Model 2 Structural (Initial Model From Borenstein et al)
LVP2.lv = 'MomVocab  =~ 1*MomMLU + MomWordRoot
           ChildVocab =~ 1*MLU + WordRoot + RDLSComp + RDLSExpress + ELI + VABSComm
           
           MomVocab ~~ MomVocab
           ChildVocab ~~ ChildVocab 
           MLU ~~ MLU
           WordRoot ~~ WordRoot
           RDLSComp ~~ RDLSComp
           RDLSExpress ~~ RDLSExpress
           ELI ~~ ELI
           VABSComm ~~ VABSComm 
           MomWordRoot ~~ MomWordRoot
           MomMLU ~~ MomMLU
           
           MomVerb ~~ MomVerb
           SES~~SES
           VABSSoc ~~ VABSSoc          
           Personality ~~ Personality
           ParentAtt ~~ ParentAtt
           ParentKnow ~~ ParentKnow
           
           MomVocab ~ ChildVocab

           MomVerb ~ MomVocab
           SES ~ MomVocab
           Personality ~ MomVocab
           VABSSoc ~ MomVocab
           ParentAtt ~ MomVocab
           ParentKnow ~ MomVocab
           
           MomVerb ~ ChildVocab
           SES ~ ChildVocab
           Personality ~ ChildVocab
           ParentAtt ~ ChildVocab
           ParentKnow ~ ChildVocab
          
           SES ~~ MomVerb
           MomVerb ~ ParentKnow
           SES ~ ParentKnow
           
           ELI ~~ VABSComm
           RDLSExpress ~~ RDLSComp'
          
fit.LVP2.lv = lavaan(model=LVP2.lv, sample.cov = data1, sample.nobs=120, fixed.x=FALSE)

summary(fit.LVP2.lv)

fitMeasures(fit.LVP2.lv, fit.measures = 'all')

modindices(fit.LVP2.lv)

#lavaan (0.5-12) converged normally after 257 iterations
#
#  Number of observations                           120
#
#  Estimator                                         ML
#  Minimum Function Test Statistic              156.869
#  Degrees of freedom                                66
#  P-value (Chi-square)                           0.000
#
#Parameter estimates:
#
#  Information                                 Expected
#  Standard Errors                             Standard
#
#                   Estimate  Std.err  Z-value  P(>|z|)
#Latent variables:
#  MomVocab =~
#    MomMLU            1.000
#    MomWordRoot      39.628    7.886    5.025    0.000
#  ChildVocab =~
#    MLU               1.000
#    WordRoot         91.119   22.397    4.068    0.000
#    RDLSComp          4.007    1.273    3.148    0.002
#    RDLSExpress       7.810    1.853    4.214    0.000
#    ELI             777.518  185.968    4.181    0.000
#    VABSComm         70.776   17.779    3.981    0.000
#
#Regressions:
#  MomVocab ~
#    ChildVocab        0.315    0.491    0.643    0.520
#  MomVerb ~
#    MomVocab         10.668    3.103    3.438    0.001
#  SES ~
#    MomVocab          8.070    2.482    3.251    0.001
#  Personality ~
#    MomVocab         -1.949    1.829   -1.066    0.287
#  VABSSoc ~
#    MomVocab          4.490    1.686    2.662    0.008
#  ParentAtt ~
#    MomVocab          0.098    0.087    1.132    0.258
#  ParentKnow ~
#    MomVocab          0.037    0.011    3.435    0.001
#  MomVerb ~
#    ChildVocab       -3.025    9.639   -0.314    0.754
#  SES ~
#    ChildVocab        9.950    8.161    1.219    0.223
#  Personality ~
#    ChildVocab       12.208    7.819    1.561    0.118
#  ParentAtt ~
#    ChildVocab        0.832    0.395    2.107    0.035
#  ParentKnow ~
#    ChildVocab        0.073    0.041    1.764    0.078
#  MomVerb ~
#    ParentKnow       18.517   24.868    0.745    0.457
#  SES ~
#    ParentKnow        7.293   20.214    0.361    0.718
#
#Covariances:
#  MomVerb ~~
#    SES              14.227   10.432    1.364    0.173
#  ELI ~~
#    VABSComm        150.951   64.304    2.347    0.019
#  RDLSComp ~~
#    RDLSExpress       0.029    0.060    0.492    0.622
#
#Variances:
#    MomVocab          0.264    0.065
#    ChildVocab        0.014    0.007
#    MLU               0.081    0.011
#    WordRoot         85.667   13.067
#    RDLSComp          1.041    0.141
#    RDLSExpress       0.176    0.053
#    ELI            3044.099  628.440
#    VABSComm         68.463   10.482
#    MomWordRoot     633.108  108.910
#    MomMLU            0.128    0.047
#    MomVerb         124.105   17.606
#    SES              83.272   11.657
#    VABSSoc          60.995    8.088
#    Personality      80.133   10.413
#    ParentAtt         0.179    0.023
#    ParentKnow        0.002    0.000
# 
# fitMeasures(fit.LVP2.lv, fit.measures = 'all')
#             fmin             chisq                df            pvalue    baseline.chisq       baseline.df 
#            0.654           156.869            66.000             0.000           614.109            91.000 
#  baseline.pvalue               cfi               tli              nnfi               rfi               nfi 
#            0.000             0.826             0.760             0.760             0.648             0.745 
#             pnfi               ifi               rni              logl unrestricted.logl              npar 
#            0.540             0.834             0.826         -4208.098         -4129.664            39.000 
#              aic               bic            ntotal              bic2             rmsea    rmsea.ci.lower 
#         8494.197          8602.909           120.000          8479.610             0.107             0.086 
#   rmsea.ci.upper      rmsea.pvalue               rmr        rmr_nomean              srmr       srmr_nomean 
#            0.129             0.000            62.202            62.202             0.113             0.113 
#            cn_05             cn_01               gfi              agfi              pgfi               mfi 
#           66.760            74.151             0.866             0.787             0.544             0.685 
#             ecvi 
#            1.957 

# Model 3 Structural (MY ALTERNATE MODEL)
LVP3.lv = 'MomVocab  =~ 1*MomMLU + MomWordRoot
           ChildVocab =~ 1*MLU + WordRoot + RDLSComp + RDLSExpress + ELI + VABSComm
           
           MomVocab ~~ MomVocab
           ChildVocab ~~ ChildVocab 
           MLU ~~ MLU
           WordRoot ~~ WordRoot
           RDLSComp ~~ RDLSComp
           RDLSExpress ~~ RDLSExpress
           ELI ~~ ELI
           VABSComm ~~ VABSComm 
           MomWordRoot ~~ MomWordRoot
           MomMLU ~~ 0*MomMLU
           
           MomVerb ~~ MomVerb
           SES ~~ SES
           VABSSoc ~~ VABSSoc          
           Personality ~~ Personality
           ParentAtt ~~ ParentAtt
           ParentKnow ~~ ParentKnow
           Gender ~~ Gender
           
           MomVocab ~ ChildVocab
           MomVerb ~ ChildVocab
           SES ~ ChildVocab
           Gender ~ ChildVocab
           VABSSoc ~ ChildVocab
           Personality ~ ChildVocab
          
           ParentAtt ~ MomVocab
           ParentKnow ~ MomVocab
           
           SES ~ ParentKnow
           Personality ~ VABSSoc
           
           SES ~~ MomVerb
           ELI ~~ VABSComm
           RDLSExpress ~~ RDLSComp
           WordRoot ~~ MLU
           MomWordRoot ~~ MomMLU'
          
fit.LVP3.lv = lavaan(model=LVP3.lv, sample.cov = data1, sample.nobs=120, fixed.x=FALSE)

summary(fit.LVP3.lv, standardized = TRUE)

fitMeasures(fit.LVP3.lv, fit.measures = 'all')

#lavaan (0.5-12) converged normally after 269 iterations
#
#  Number of observations                           120
#
#  Estimator                                         ML
#  Minimum Function Test Statistic              184.905
#  Degrees of freedom                                83
#  P-value (Chi-square)                           0.000
#
#Parameter estimates:
#
#  Information                                 Expected
#  Standard Errors                             Standard
#
#                   Estimate  Std.err  Z-value  P(>|z|)
#Latent variables:
#  MomVocab =~
#    MomMLU            1.000
#    MomWordRoot      50.379   14.639    3.441    0.001
#  ChildVocab =~
#    MLU               1.000
#    WordRoot         97.684   25.129    3.887    0.000
#    RDLSComp          4.691    1.540    3.045    0.002
#    RDLSExpress       8.372    2.239    3.739    0.000
#    ELI             891.495  238.511    3.738    0.000
#    VABSComm         83.057   22.960    3.617    0.000
#
#Regressions:
#  MomVocab ~
#    ChildVocab        0.357    0.506    0.706    0.480
#  MomVerb ~
#    ChildVocab        5.699   11.377    0.501    0.616
#  SES ~
#    ChildVocab       14.014    9.587    1.462    0.144
#  Gender ~
#    ChildVocab        1.497    0.576    2.599    0.009
#  VABSSoc ~
#    ChildVocab       37.672   11.719    3.215    0.001
#  Personality ~
#    ChildVocab        7.742    9.584    0.808    0.419
#  ParentAtt ~
#    MomVocab          0.062    0.057    1.097    0.273
#  ParentKnow ~
#    MomVocab          0.023    0.007    3.374    0.001
#  SES ~
#    ParentKnow       25.988   17.418    1.492    0.136
#  Personality ~
#    VABSSoc           0.151    0.117    1.288    0.198
#
#Covariances:
#  MomVerb ~~
#    SES              35.062   11.827    2.965    0.003
#  ELI ~~
#    VABSComm         75.139   60.925    1.233    0.217
#  RDLSComp ~~
#    RDLSExpress       0.019    0.059    0.317    0.751
#  MLU ~~
#    WordRoot          0.593    0.282    2.101    0.036
#  MomMLU ~~
#    MomWordRoot      -9.051    5.543   -1.633    0.103#
#
#Variances:
#    MomVocab          0.392    0.051
#    ChildVocab        0.011    0.006
#    MLU               0.084    0.011
#    WordRoot         92.898   13.741
#    RDLSComp          1.014    0.137
#    RDLSExpress       0.229    0.053
#    ELI            2425.078  603.201
#    VABSComm         59.749    9.926
#    MomWordRoot      49.266  546.134
#    MomMLU            0.000
#    MomVerb         158.568   20.476
#    SES              97.800   12.656
#    VABSSoc          50.096    6.694
#    Personality      79.816   10.314
#    ParentAtt         0.190    0.025
#    ParentKnow        0.002    0.000
#    Gender            0.222    0.029
#
# fitMeasures(fit.LVP3.lv, fit.measures = 'all')
#             fmin             chisq                df            pvalue    baseline.chisq       baseline.df 
#            0.770           184.905            83.000             0.000           639.822           105.000 
#  baseline.pvalue               cfi               tli              nnfi               rfi               nfi 
#            0.000             0.809             0.759             0.759             0.634             0.711 
#             pnfi               ifi               rni              logl unrestricted.logl              npar 
#            0.562             0.817             0.809         -4295.853         -4203.400            37.000 
#              aic               bic            ntotal              bic2             rmsea    rmsea.ci.lower 
#         8665.706          8768.844           120.000          8651.867             0.101             0.082 
#   rmsea.ci.upper      rmsea.pvalue               rmr        rmr_nomean              srmr       srmr_nomean 
#            0.121             0.000            40.766            40.766             0.111             0.111 
#            cn_05             cn_01               gfi              agfi              pgfi               mfi 
#           69.316            76.201             0.829             0.753             0.573             0.654 
#             ecvi 
#            2.158              
# modindices(fit.LVP3.lv)

#            lhs op         rhs       mi          epc       sepc.lv      sepc.all      sepc.nox
#1      MomVocab =~      MomMLU       NA           NA            NA            NA            NA
#2      MomVocab =~ MomWordRoot    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#3      MomVocab =~         MLU    0.125        0.013         0.008  2.700000e-02  2.700000e-02
#4      MomVocab =~    WordRoot    3.673       -2.531        -1.588 -1.120000e-01 -1.120000e-01
#5      MomVocab =~    RDLSComp    5.546        0.316         0.199  1.760000e-01  1.760000e-01
#6      MomVocab =~ RDLSExpress    6.942       -0.208        -0.130 -1.280000e-01 -1.280000e-01
#7      MomVocab =~         ELI    3.050       13.469         8.450  7.900000e-02  7.900000e-02
#8      MomVocab =~    VABSComm    0.249        0.517         0.324  2.800000e-02  2.800000e-02
#9    ChildVocab =~      MomMLU    4.185       -1.161        -0.124 -1.980000e-01 -1.980000e-01
#10   ChildVocab =~ MomWordRoot    1.219       30.072         3.217  9.900000e-02  9.900000e-02
#11   ChildVocab =~         MLU       NA           NA            NA            NA            NA
#12   ChildVocab =~    WordRoot    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#13   ChildVocab =~    RDLSComp    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#14   ChildVocab =~ RDLSExpress    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#15   ChildVocab =~         ELI    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#16   ChildVocab =~    VABSComm    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#17       MomMLU ~~      MomMLU    2.865        1.271         1.271  3.230000e+00  3.230000e+00
#18       MomMLU ~~ MomWordRoot    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#19     **MomMLU ~~         MLU    6.529        0.034         0.034  1.770000e-01  1.770000e-01
#20     **MomMLU ~~    WordRoot   22.629       -2.246        -2.246 -2.520000e-01 -2.520000e-01
#21       MomMLU ~~    RDLSComp    1.305        0.055         0.055  7.800000e-02  7.800000e-02
#22       MomMLU ~~ RDLSExpress    2.956       -0.048        -0.048 -7.500000e-02 -7.500000e-02
#23       MomMLU ~~         ELI    0.979        2.698         2.698  4.000000e-02  4.000000e-02
#24       MomMLU ~~    VABSComm    1.624        0.473         0.473  6.400000e-02  6.400000e-02
#25  MomWordRoot ~~ MomWordRoot    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#26**MomWordRoot ~~         MLU    6.366       -1.767        -1.767 -1.770000e-01 -1.770000e-01
#27**MomWordRoot ~~    WordRoot   10.633       80.154        80.154  1.740000e-01  1.740000e-01
#28  MomWordRoot ~~    RDLSComp    0.752        2.177         2.177  6.000000e-02  6.000000e-02
#29  MomWordRoot ~~ RDLSExpress    0.231       -0.693        -0.693 -2.100000e-02 -2.100000e-02
#30  MomWordRoot ~~         ELI    0.122       49.591        49.591  1.400000e-02  1.400000e-02
#31  MomWordRoot ~~    VABSComm    1.553      -24.068       -24.068 -6.300000e-02 -6.300000e-02
#32          MLU ~~         MLU    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#33          MLU ~~    WordRoot    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#34          MLU ~~    RDLSComp    0.295        0.014         0.014  4.100000e-02  4.100000e-02
#35          MLU ~~ RDLSExpress    1.585        0.020         0.020  6.400000e-02  6.400000e-02
#36          MLU ~~         ELI    0.946       -1.519        -1.519 -4.600000e-02 -4.600000e-02
#37          MLU ~~    VABSComm    0.289       -0.109        -0.109 -3.000000e-02 -3.000000e-02
#38     WordRoot ~~    WordRoot    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#39     WordRoot ~~    RDLSComp    7.482       -2.654        -2.654 -1.660000e-01 -1.660000e-01
#40     WordRoot ~~ RDLSExpress    9.883        2.501         2.501  1.730000e-01  1.730000e-01
#41     WordRoot ~~         ELI    0.146      -25.933       -25.933 -1.700000e-02 -1.700000e-02
#42     WordRoot ~~    VABSComm    0.039       -1.522        -1.522 -9.000000e-03 -9.000000e-03
#43     RDLSComp ~~    RDLSComp    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#44     RDLSComp ~~ RDLSExpress    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#45   **RDLSComp ~~         ELI    1.251        7.181         7.181  5.900000e-02  5.900000e-02
#46     RDLSComp ~~    VABSComm    0.758       -0.651        -0.651 -4.900000e-02 -4.900000e-02
#47  RDLSExpress ~~ RDLSExpress    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#48  RDLSExpress ~~         ELI    0.107       -1.833        -1.833 -1.700000e-02 -1.700000e-02
#49  RDLSExpress ~~    VABSComm    0.805       -0.529        -0.529 -4.400000e-02 -4.400000e-02
#50          ELI ~~         ELI    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#51          ELI ~~    VABSComm    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#52     VABSComm ~~    VABSComm    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#53      MomVerb ~~     MomVerb    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#54      MomVerb ~~         SES    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#55      MomVerb ~~      Gender    3.431       -0.969        -0.969 -1.540000e-01 -1.540000e-01
#56      MomVerb ~~     VABSSoc    2.281       11.988        11.988  1.170000e-01  1.170000e-01
#57      MomVerb ~~ Personality    3.351      -17.932       -17.932 -1.560000e-01 -1.560000e-01
#58      MomVerb ~~   ParentAtt    0.175        0.202         0.202  3.600000e-02  3.600000e-02
#59      MomVerb ~~  ParentKnow    2.259        0.081         0.081  1.290000e-01  1.290000e-01
#60          SES ~~         SES    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#61          SES ~~      Gender    1.406        0.488         0.488  9.700000e-02  9.700000e-02
#62          SES ~~     VABSSoc    1.021        6.306         6.306  7.700000e-02  7.700000e-02
#63          SES ~~ Personality    0.002       -0.346        -0.346 -4.000000e-03 -4.000000e-03
#64          SES ~~   ParentAtt    0.044        0.080         0.080  1.800000e-02  1.800000e-02
#65        **SES ~~  ParentKnow    5.963       -0.301        -0.301 -5.990000e-01 -5.990000e-01
#66       Gender ~~      Gender    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#67       Gender ~~     VABSSoc    1.835       -0.422        -0.422 -1.040000e-01 -1.040000e-01
#68       Gender ~~ Personality    0.223        0.182         0.182  4.000000e-02  4.000000e-02
#69       Gender ~~   ParentAtt    0.374       -0.012        -0.012 -5.300000e-02 -5.300000e-02
#70       Gender ~~  ParentKnow    0.057        0.000         0.000  2.000000e-02  2.000000e-02
#71      VABSSoc ~~     VABSSoc    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#72      VABSSoc ~~ Personality       NA           NA            NA            NA            NA
#73    **VABSSoc ~~   ParentAtt    1.899        0.394         0.394  1.100000e-01  1.100000e-01
#74      VABSSoc ~~  ParentKnow    0.149        0.012         0.012  2.900000e-02  2.900000e-02
#75  Personality ~~ Personality    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#76  Personality ~~   ParentAtt    3.232       -0.636        -0.636 -1.590000e-01 -1.590000e-01
#77  Personality ~~  ParentKnow    0.001        0.001         0.001  3.000000e-03  3.000000e-03
#78    ParentAtt ~~   ParentAtt    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#79    ParentAtt ~~  ParentKnow    0.156        0.001         0.001  3.400000e-02  3.400000e-02
#80   ParentKnow ~~  ParentKnow    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#81     MomVocab ~~    MomVocab    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#82     MomVocab ~~  ChildVocab       NA           NA            NA            NA            NA
#83   ChildVocab ~~  ChildVocab    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#84     MomVocab  ~     MomVerb   15.233        0.016         0.026  3.230000e-01  3.230000e-01
#85     MomVocab  ~         SES   11.968        0.019         0.030  3.030000e-01  3.030000e-01
#86     MomVocab  ~      Gender    2.665       -0.181        -0.288 -1.430000e-01 -1.430000e-01
#87     MomVocab  ~     VABSSoc    5.056        0.017         0.027  2.180000e-01  2.180000e-01
#88     MomVocab  ~ Personality    5.056        0.093         0.148  1.352000e+00  1.352000e+00
#89     MomVocab  ~   ParentAtt    7.048       -5.963        -9.504 -4.164000e+00 -4.164000e+00
#90     MomVocab  ~  ParentKnow    5.150      -46.538       -74.180 -3.694000e+00 -3.694000e+00
#91     MomVocab  ~  ChildVocab    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#92    **MomVerb  ~    MomVocab    9.569        4.959         3.111  2.470000e-01  2.470000e-01
#93      MomVerb  ~         SES    6.354        2.242         2.242  1.794000e+00  1.794000e+00
#94      MomVerb  ~      Gender    3.431       -4.359        -4.359 -1.720000e-01 -1.720000e-01
#95      MomVerb  ~     VABSSoc    2.281        0.239         0.239  1.550000e-01  1.550000e-01
#96      MomVerb  ~ Personality    3.797       -0.238        -0.238 -1.730000e-01 -1.730000e-01
#97      MomVerb  ~   ParentAtt    0.497        1.774         1.774  6.200000e-02  6.200000e-02
#98      MomVerb  ~  ParentKnow    6.354       58.211        58.211  2.300000e-01  2.300000e-01
#99      MomVerb  ~  ChildVocab    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#100         SES  ~    MomVocab    5.963        3.189         2.001  1.980000e-01  1.980000e-01
#101         SES  ~     MomVerb       NA           NA            NA            NA            NA
#102         SES  ~      Gender    1.406        2.194         2.194  1.080000e-01  1.080000e-01
#103         SES  ~     VABSSoc    1.021        0.126         0.126  1.020000e-01  1.020000e-01
#104         SES  ~ Personality    0.030       -0.017        -0.017 -1.500000e-02 -1.500000e-02
#105         SES  ~   ParentAtt    0.184        0.849         0.849  3.700000e-02  3.700000e-02
#106         SES  ~  ParentKnow    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#107         SES  ~  ChildVocab    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#108      Gender  ~    MomVocab    2.665       -0.102        -0.064 -1.290000e-01 -1.290000e-01
#109      Gender  ~     MomVerb    2.506       -0.005        -0.005 -1.380000e-01 -1.380000e-01
#110      Gender  ~         SES    0.417        0.003         0.003  5.700000e-02  5.700000e-02
#111      Gender  ~     VABSSoc    1.835       -0.008        -0.008 -1.380000e-01 -1.380000e-01
#112      Gender  ~ Personality    0.216        0.002         0.002  4.100000e-02  4.100000e-02
#113      Gender  ~   ParentAtt    0.580       -0.075        -0.075 -6.600000e-02 -6.600000e-02
#114      Gender  ~  ParentKnow    0.097       -0.270        -0.270 -2.700000e-02 -2.700000e-02
#115      Gender  ~  ChildVocab    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#116     VABSSoc  ~    MomVocab    5.056        2.141         1.343  1.650000e-01  1.650000e-01
#117     VABSSoc  ~     MomVerb    3.497        0.098         0.098  1.510000e-01  1.510000e-01
#118     VABSSoc  ~         SES    2.653        0.107         0.107  1.330000e-01  1.330000e-01
#119     VABSSoc  ~      Gender    1.835       -1.901        -1.901 -1.160000e-01 -1.160000e-01
#120     VABSSoc  ~ Personality    5.056       -1.432        -1.432 -1.607000e+00 -1.607000e+00
#121   **VABSSoc  ~   ParentAtt    2.506        2.370         2.370  1.270000e-01  1.270000e-01
#122     VABSSoc  ~  ParentKnow    1.245       14.701        14.701  9.000000e-02  9.000000e-02
#123   **VABSSoc  ~  ChildVocab    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#124 Personality  ~    MomVocab    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#125 Personality  ~     MomVerb    3.691       -0.124        -0.124 -1.710000e-01 -1.710000e-01
#126 Personality  ~         SES    0.331       -0.047        -0.047 -5.200000e-02 -5.200000e-02
#127 Personality  ~      Gender    0.223        0.818         0.818  4.500000e-02  4.500000e-02
#128 Personality  ~     VABSSoc    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#129**Personality  ~   ParentAtt    3.232       -3.337        -3.337 -1.600000e-01 -1.600000e-01
#130 Personality  ~  ParentKnow    0.001        0.593         0.593  3.000000e-03  3.000000e-03
#131 Personality  ~  ChildVocab    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#132   ParentAtt  ~    MomVocab    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#133   ParentAtt  ~     MomVerb    0.387        0.002         0.002  5.700000e-02  5.700000e-02
#134   ParentAtt  ~         SES    0.579        0.003         0.003  6.900000e-02  6.900000e-02
#135   ParentAtt  ~      Gender    0.055        0.019         0.019  2.100000e-02  2.100000e-02
#136   ParentAtt  ~     VABSSoc    5.906        0.012         0.012  2.210000e-01  2.210000e-01
#137   ParentAtt  ~ Personality    1.326       -0.005        -0.005 -1.050000e-01 -1.050000e-01
#138   ParentAtt  ~  ParentKnow    0.156        0.329         0.329  3.700000e-02  3.700000e-02
#139 **ParentAtt  ~  ChildVocab    7.048        1.040         0.111  2.540000e-01  2.540000e-01
#140  ParentKnow  ~    MomVocab    0.000        0.000         0.000  0.000000e+00  0.000000e+00
#141  ParentKnow  ~     MomVerb    1.899        0.000         0.000  1.190000e-01  1.190000e-01
#142  ParentKnow  ~         SES    0.039        0.000         0.000 -3.900000e-02 -3.900000e-02
#143  ParentKnow  ~      Gender    0.839        0.008         0.008  7.900000e-02  7.900000e-02
#144  ParentKnow  ~     VABSSoc    1.954        0.001         0.001  1.210000e-01  1.210000e-01
#145  ParentKnow  ~ Personality    0.195        0.000         0.000  3.800000e-02  3.800000e-02
#146  ParentKnow  ~   ParentAtt    0.156        0.004         0.004  3.400000e-02  3.400000e-02
#147**ParentKnow  ~  ChildVocab    5.150        0.096         0.010  2.060000e-01  2.060000e-01
#148  ChildVocab  ~    MomVocab       NA           NA            NA            NA            NA
#149  ChildVocab  ~     MomVerb 4524.938 -1919726.407 -17947037.651 -2.262608e+08 -2.262608e+08
#150  ChildVocab  ~         SES    5.150        0.019         0.175  1.770000e+00  1.770000e+00
#151  ChildVocab  ~      Gender       NA           NA            NA            NA            NA
#152  ChildVocab  ~     VABSSoc 2952.395 -2192982.857 -20501643.239 -1.670032e+08 -1.670032e+08
#153  ChildVocab  ~ Personality       NA           NA            NA            NA            NA
#154  ChildVocab  ~   ParentAtt    7.048        0.062         0.584  2.560000e-01  2.560000e-01
#155  ChildVocab  ~  ParentKnow    5.150        0.487         4.555  2.270000e-01  2.270000e-01

# Model 4 Structural (Borenstein et al. Final Model)
LVP4.lv = 'MomVocab  =~ 1*MomMLU + MomWordRoot
           ChildVocab =~ 1*MLU + WordRoot + RDLSComp + RDLSExpress + ELI + VABSComm
           
           MomVocab ~~ MomVocab
           ChildVocab ~~ ChildVocab 
           MLU ~~ MLU
           WordRoot ~~ WordRoot
           RDLSComp ~~ RDLSComp
           RDLSExpress ~~ RDLSExpress
           ELI ~~ ELI
           VABSComm ~~ VABSComm 
           MomWordRoot ~~ MomWordRoot
           MomMLU ~~ MomMLU
           
           MomVerb ~~ MomVerb
           SES ~~ SES
           VABSSoc ~~ VABSSoc          
           Personality ~~ Personality
           ParentAtt ~~ ParentAtt
           ParentKnow ~~ ParentKnow
           Gender ~~ Gender
           
           MomVocab ~ ChildVocab
           MomVocab ~ RDLSComp
           MomVocab ~ VABSComm
           MomVocab ~ ELI
           MomVocab ~ VABSSoc

           Personality ~ VABSSoc
           Personality ~ ELI           
           
           MomVerb ~ ParentKnow
           MomVerb ~ MomVocab
           
           ParentAtt ~ VABSSoc
           ParentAtt ~ ChildVocab
           
           ParentKnow ~ MomVocab

           VABSSoc ~ ChildVocab
           
		  Gender ~ ChildVocab
           
           SES ~ MomVocab
           
           SES ~~ MomVerb
           VABSSoc ~~ VABSComm
           WordRoot ~~ MLU'
          
fit.LVP4.lv = lavaan(model=LVP4.lv, sample.cov = data1, sample.nobs=120, fixed.x=FALSE)

summary(fit.LVP4.lv)

fitMeasures(fit.LVP4.lv, fit.measures = 'all')


#lavaan (0.5-12) converged normally after 287 iterations
#
#  Number of observations                           120
#
#  Estimator                                         ML
#  Minimum Function Test Statistic              117.608
#  Degrees of freedom                                79
#  P-value (Chi-square)                           0.003
#
#Parameter estimates:
#
#  Information                                 Expected
#  Standard Errors                             Standard
#
#                   Estimate  Std.err  Z-value  P(>|z|)
#Latent variables:
#  MomVocab =~
#    MomMLU            1.000
#    MomWordRoot      38.007    7.589    5.008    0.000
#  ChildVocab =~
#    MLU               1.000
#    WordRoot        103.485   27.833    3.718    0.000
#    RDLSComp          4.915    1.659    2.963    0.003
#    RDLSExpress       8.825    2.479    3.559    0.000
#    ELI             956.630  268.322    3.565    0.000
#    VABSComm         89.973   25.832    3.483    0.000
#
#Regressions:
#  MomVocab ~
#    ChildVocab       -5.999    2.828   -2.121    0.034
#    RDLSComp          0.136    0.051    2.642    0.008
#    VABSComm          0.011    0.008    1.360    0.174
#    ELI               0.004    0.002    2.443    0.015
#    VABSSoc           0.012    0.008    1.560    0.119
#  Personality ~
#    VABSSoc           0.128    0.110    1.161    0.246
#    ELI               0.011    0.008    1.360    0.174
#  MomVerb ~
#    ParentKnow       14.459   23.839    0.607    0.544
#    MomVocab         10.475    3.052    3.432    0.001
#  ParentAtt ~
#    VABSSoc           0.009    0.005    1.571    0.116
#    ChildVocab        0.752    0.499    1.507    0.132
#  ParentKnow ~
#    MomVocab          0.039    0.011    3.590    0.000
#  VABSSoc ~
#    ChildVocab       38.070   12.533    3.037    0.002
#  Gender ~
#    ChildVocab        1.620    0.629    2.576    0.010
#  SES ~
#    MomVocab          8.373    2.218    3.774    0.000
#
#Covariances:
#  MomVerb ~~
#    SES              14.180   10.448    1.357    0.175
#  VABSComm ~~
#    VABSSoc          18.798    5.774    3.255    0.001
#  MLU ~~
#    WordRoot          0.656    0.281    2.339    0.019
#
#Variances:
#    MomVocab          0.185    0.058
#    ChildVocab        0.010    0.006
#    MLU               0.085    0.011
#    WordRoot         92.974   13.376
#    RDLSComp          1.020    0.135
#    RDLSExpress       0.237    0.046
#    ELI            2194.951  497.197
#    VABSComm         56.204    8.474
#    MomWordRoot     653.811  106.367
#    MomMLU            0.119    0.044
#    MomVerb         124.956   17.553
#    SES              84.928   11.801
#    VABSSoc          51.570    6.869
#    Personality      79.203   10.225
#    ParentAtt         0.176    0.023
#    ParentKnow        0.002    0.000
#    Gender            0.221    0.029
#
# 
# fitMeasures(fit.LVP4.lv, fit.measures = 'all')
#             fmin             chisq                df            pvalue    baseline.chisq       baseline.df 
#            0.490           117.608            79.000             0.003           639.822           105.000 
#  baseline.pvalue               cfi               tli              nnfi               rfi               nfi 
#            0.000             0.928             0.904             0.904             0.756             0.816 
#             pnfi               ifi               rni              logl unrestricted.logl              npar 
#            0.614             0.931             0.928         -4262.204         -4203.400            41.000 
#              aic               bic            ntotal              bic2             rmsea    rmsea.ci.lower 
#         8606.408          8720.696           120.000          8591.073             0.064             0.038 
#   rmsea.ci.upper      rmsea.pvalue               rmr        rmr_nomean              srmr       srmr_nomean 
#            0.087             0.172            27.269            27.269             0.071             0.071 
#            cn_05             cn_01               gfi              agfi              pgfi               mfi 
#          103.798           114.405             0.895             0.840             0.589             0.851 
#             ecvi 
#            1.663            
            
# Model 5 Structural (MY ADJUSTED ALTERNATE MODEL)
LVP5.lv = 'MomVocab  =~ 1*MomMLU + MomWordRoot
           ChildVocab =~ 1*MLU + WordRoot + RDLSComp + RDLSExpress + ELI + VABSComm
           
           MomVocab ~~ MomVocab
           ChildVocab ~~ ChildVocab 
           MLU ~~ MLU
           WordRoot ~~ WordRoot
           RDLSComp ~~ RDLSComp
           RDLSExpress ~~ RDLSExpress
           ELI ~~ ELI
           VABSComm ~~ VABSComm 
           MomWordRoot ~~ MomWordRoot
           MomMLU ~~ MomMLU
           
           MomVerb ~~ MomVerb
           SES ~~ SES
           VABSSoc ~~ VABSSoc          
           Personality ~~ Personality
           ParentAtt ~~ ParentAtt
           ParentKnow ~~ ParentKnow
           Gender ~~ Gender
           
           MomVocab ~ ChildVocab
           VABSSoc ~ ChildVocab
           Gender ~ ChildVocab
           
           MomVerb ~ MomVocab
           VABSSoc ~ MomVocab
           ParentKnow ~ MomVocab
           SES ~ MomVocab
                    
           Personality ~ VABSSoc
           ParentAtt ~ VABSSoc

           WordRoot ~~ MLU
           MomWordRoot ~~ MomMLU
           MomWordRoot ~~ MLU
           MomWordRoot ~~ WordRoot
           MomMLU ~~ MLU
           MomMLU ~~ WordRoot'
          
fit.LVP5.lv = lavaan(model=LVP5.lv, sample.cov = data1, sample.nobs=120, fixed.x=FALSE)

summary(fit.LVP5.lv, standardized = TRUE)

fitMeasures(fit.LVP5.lv, fit.measures = 'all')

modindices(fit.LVP5.lv)

#lavaan (0.5-12) converged normally after 208 iterations
#
#  Number of observations                           120
#
#  Estimator                                         ML
#  Minimum Function Test Statistic              114.029
#  Degrees of freedom                                82
#  P-value (Chi-square)                           0.011
#
#Parameter estimates:#
#
#  Information                                 Expected
#  Standard Errors                             Standard
#
#                   Estimate  Std.err  Z-value  P(>|z|)   Std.lv  Std.all
#Latent variables:
#  MomVocab =~
#    MomMLU            1.000                               0.402    0.647
#    MomWordRoot      39.385    7.880    4.998    0.000   15.830    0.487
#  ChildVocab =~
#    MLU               1.000                               0.108    0.348
#    WordRoot         89.132   21.474    4.151    0.000    9.633    0.696
#    RDLSComp          4.633    1.477    3.136    0.002    0.501    0.445
#    RDLSExpress       8.063    2.107    3.826    0.000    0.871    0.858
#    ELI             904.955  234.492    3.859    0.000   97.801    0.911
#    VABSComm         86.374   22.911    3.770    0.000    9.335    0.792
#
#Regressions:
#  MomVocab ~
#    ChildVocab        0.785    0.480    1.637    0.102    0.211    0.211
#  VABSSoc ~
#    ChildVocab       35.485   11.030    3.217    0.001    3.835    0.471
#  Gender ~
#    ChildVocab        1.426    0.553    2.577    0.010    0.154    0.310
#  MomVerb ~
#    MomVocab         18.508    4.496    4.116    0.000    7.439    0.590
#  VABSSoc ~
#    MomVocab          4.658    2.099    2.219    0.026    1.872    0.230
#  ParentKnow ~
#    MomVocab          0.056    0.016    3.562    0.000    0.023    0.453
#  SES ~
#    MomVocab         13.009    3.370    3.861    0.000    5.229    0.512
#  Personality ~
#    VABSSoc           0.201    0.100    2.005    0.045    0.201    0.180
#  ParentAtt ~
#    VABSSoc           0.013    0.005    2.708    0.007    0.013    0.240
#
#Covariances:
#  MLU ~~
#    WordRoot          0.669    0.288    2.325    0.020    0.669    0.231
#  MomMLU ~~
#    MomWordRoot       4.334    1.965    2.206    0.027    4.334    0.322
#  MomWordRoot ~~
#    MLU              -0.940    0.814   -1.154    0.248   -0.940   -0.114
#    WordRoot         29.157   28.757    1.014    0.311   29.157    0.103
#  MomMLU ~~
#    MLU               0.012    0.015    0.850    0.395    0.012    0.090
#    WordRoot         -1.784    0.540   -3.305    0.001   -1.784   -0.378
#
#Variances:
#    MomVocab          0.154    0.050                      0.955    0.955
#    ChildVocab        0.012    0.006                      1.000    1.000
#    MLU               0.085    0.011                      0.085    0.879
#    WordRoot         98.984   13.993                     98.984    0.516
#    RDLSComp          1.016    0.134                      1.016    0.802
#    RDLSExpress       0.272    0.048                      0.272    0.264
#    ELI            1965.332  468.520                   1965.332    0.170
#    VABSComm         51.647    7.923                     51.647    0.372
#    MomWordRoot     804.870  130.294                    804.870    0.763
#    MomMLU            0.225    0.046                      0.225    0.582
#    MomVerb         103.599   18.250                    103.599    0.652
#    SES              76.849   11.989                     76.849    0.738
#    VABSSoc          45.111    6.200                     45.111    0.680
#    Personality      80.335   10.371                     80.335    0.968
#    ParentAtt         0.181    0.023                      0.181    0.942
#    ParentKnow        0.002    0.000                      0.002    0.795
#    Gender            0.224    0.029                      0.224    0.904
# fitMeasures(fit.LVP5.lv, fit.measures = 'all')
#             fmin             chisq                df            pvalue    baseline.chisq       baseline.df 
#            0.475           114.029            82.000             0.011           639.822           105.000 
#  baseline.pvalue               cfi               tli              nnfi               rfi               nfi 
#            0.000             0.940             0.923             0.923             0.772             0.822 
#             pnfi               ifi               rni              logl unrestricted.logl              npar 
#            0.642             0.943             0.940         -4260.415         -4203.400            38.000 
#              aic               bic            ntotal              bic2             rmsea    rmsea.ci.lower 
#         8596.830          8702.754           120.000          8582.616             0.057             0.028 
#   rmsea.ci.upper      rmsea.pvalue               rmr        rmr_nomean              srmr       srmr_nomean 
#            0.081             0.310            27.778            27.778             0.075             0.075 
#            cn_05             cn_01               gfi              agfi              pgfi               mfi 
#          110.592           121.701             0.894             0.844             0.611             0.875 
#             ecvi 
#            1.584  