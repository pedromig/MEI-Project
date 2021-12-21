#load datasets
df <- read.csv(file = '/Users/gabriel/Downloads/data-3.csv')
df1 <- read.csv(file = 'code_1_data.csv')
df2 <- read.csv(file = 'code_2_data.csv')

df1$individual <- 1 : length(df1[,1])
df2$individual <- 1 : length(df2[,1])


inputs <- matrix(0, length(df[,1]), 1)
counter <- 1
for (i in 1 : (length(df[, 1]) / 2)) {
    inputs[counter, 1] <- i
    inputs[counter + 1, 1] <- i
    counter <- counter + 2
}
df$individual <- inputs

###--------
# o as.factor() é para o anova interpretar esses dados como categorical (assim calcula os graus de liberdade corretamente)
###------

# one way anova for the 4th hypothesis
aov4_1.out <- aov(time ~ instance_seed, data = df1)
aov4_2.out <- aov(time ~ instance_seed, data = df2)

print("One way anova para a instance seed (4)")
print("df1")
print(summary(aov4_1.out))
plot(aov4_1.out)

print("df2")
print(summary(aov4_2.out))
plot(aov4_2.out)

#-------- Krsukal pois as assumptions não foram verificadas -------#
#Kruskal-Wallis
print("Kruskal-Wallis para a instance seed (4)")
kruskal4_1 <- kruskal.test(time ~ as.factor(instance_seed), data = df1)
print("df1")
print(kruskal4_1)

kruskal4_2 <- kruskal.test(time ~ as.factor(instance_seed), data = df2)
print("df2")
print(kruskal4_2)

#--------------------------------------------------#

# one way anova for the 5th hypothesis
aov5_1.out <- aov(time ~ solver_seed, data = df1)
aov5_2.out <- aov(time ~ solver_seed, data = df2)

print("One way anova para a solver seed (5)")
print("df1")
print(summary(aov5_1.out))
plot(aov5_1.out)

print("df2")
print(summary(aov5_2.out))
plot(aov5_2.out)

#-------- Krsukal pois as assumptions não foram verificadas -------#
#Kruskal-Wallis
print("Kruskal-Wallis para a instance seed (5)")
kruskal5_1 <- kruskal.test(time ~ as.factor(solver_seed), data = df1)
print("df1")
print(kruskal5_1)

kruskal5_2 <- kruskal.test(time ~ as.factor(solver_seed), data = df2)
print("df2")
print(kruskal5_2)

#----------------------------------------#
# one way repeated measures for hypothesis 3
#aovrm3.out <- aov_car(time ~ as.factor(solver) + Error(individual), data = df)
aovrm3.out <- aov(time ~ as.factor(solver) + Error(individual), data = df)

print("One way repeated measures anova.")
print(summary(aovrm3.out))