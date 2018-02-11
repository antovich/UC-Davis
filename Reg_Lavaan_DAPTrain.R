data = read.table('/Users/Dylan/Desktop/PTrainCov.txt')

rownames(data) = c('raw_CDI_under','diff_score')
colnames(data) = c('raw_CDI_under','diff_score')

data1 = as.matrix(data)

library(lavaan)

reg.lv1 = 'raw_CDI_under ~ diff_score
           raw_CDI_under ~~ raw_CDI_under
           diff_score ~~ diff_score'
          
fit.reg.lv1 = lavaan(model=reg.lv1, sample.cov = data1, sample.nobs=66, fixed.x=FALSE)

summary(fit.reg.lv1)

#lavaan (0.5-12) converged normally after  22 iterations
#
#  Number of observations                          1680
#
#  Estimator                                         ML
#  Minimum Function Test Statistic                0.000
#  Degrees of freedom                                 0
#  P-value (Chi-square)                           1.000
#
#Parameter estimates:
#
#  Information                                 Expected
#  Standard Errors                             Standard
#
#                   Estimate  Std.err  Z-value  P(>|z|)
#Regressions:
#  bd_p ~
#    age_50d          -4.832    0.281  -17.219    0.000
#
#Variances:
#    bd_p            429.761   14.828
#    age_50d           3.249    0.112




#lavaan(model = NULL, data = NULL, model.type = "sem", meanstructure = "default", int.ov.free = FALSE, int.lv.free = FALSE, fixed.x = "default", orthogonal = FALSE, std.lv = FALSE, auto.fix.first = FALSE, auto.fix.single = FALSE, auto.var = FALSE, auto.cov.lv.x = FALSE, auto.cov.y = FALSE, auto.th = FALSE, auto.delta = FALSE, std.ov = FALSE, missing = "default", ordered = NULL, sample.cov = NULL, sample.cov.rescale = "default", sample.mean = NULL, sample.nobs = NULL, ridge = 1e-05, group = NULL, group.label = NULL, group.equal = "", group.partial = "", cluster = NULL, constraints = "", estimator = "default", likelihood = "default", information = "default", se = "default", test = "default", bootstrap = 1000L, mimic = "default", representation = "default", do.fit = TRUE, control = list(), WLS.V = NULL, NACOV = NULL, zero.add = "default", zero.keep.margins = "default", start = "default", slotOptions = NULL, slotParTable = NULL, slotSampleStats = NULL, slotData = NULL, slotModel = NULL, verbose = FALSE, warn = TRUE, debug = FALSE)

#HS.model <- 'visual =~ x1 + x2 + x3 textual =~ x4 + x5 + x6'
#speed	=~ x7 + x8 + x9 􏰀
#fit <- lavaan(HS.model, data=HolzingerSwineford1939, auto.var=TRUE, auto.fix.first=TRUE,
#auto.cov.lv.x=TRUE) summary(fit, fit.measures=TRUE)