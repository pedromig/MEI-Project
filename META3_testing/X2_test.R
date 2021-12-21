library(SciViews)

#load datasets
df1 <- read.csv(file = 'code_1_data.csv')
df2 <- read.csv(file = 'code_2_data.csv')

goodness_of_fit_test <- function(data, prob, k, alpha) {
    filtered_rows <- data$probability == prob
    data <- data[filtered_rows, ]

    mean_data_time <- mean(data$time)
    l <- 1 / mean_data_time

    p <- 1 / k
    a <- matrix(0.0, 1, k)

    # get the intervals of the exponential distribution
    for (i in 1 : k) {
        #- ( 1 / l ) ln (1 - ip)
        a[1, i] <- - (1 / l) * ln(1 - i * p)
    }


    freq <- matrix(0.0, 1, k)
    for (i in 1 : k) {
        freq[1, i] <- length(data$time[data$time < a[1, i]])
    }

    for (i in k : 2) {
        freq[1, i] <- freq[1, i] - freq[1, i - 1]
    }

    expected <- matrix(sum(freq) / k, 1, k)

    diff <- matrix(0.0, 1, k)

    for (i in 1 : k) {
        #(Oi  - Ei )2 / Oi
        diff[1, i] <- (freq[1, i] - expected[1, i])^2 / freq[1, i]
    }

    chi_square <- sum(diff)

    #print(freq)
    #print(a)

    return(chi_square)
}

get_result <- function(data, prob, k, alpha) {
    chi_square <- goodness_of_fit_test(data, prob, k, alpha)
    print(sprintf("Test statistic value: %f.", chi_square))

    chisquare_distribution <- qchisq(1 - alpha, df = k - 1 - 1, lower.tail = FALSE)
    print(sprintf("Chi square value for df = k - s - 1 = %d - 1 - 1 = %d and alpha = %.2f -> %f", k, k - 1 - 1, alpha, chisquare_distribution))
    
    if (chisquare_distribution < chi_square){
        print(sprintf("The critical value is %f and the test statistic is %f. %f < %f, so we reject H0.", chisquare_distribution, chi_square, chisquare_distribution, chi_square))
    }
    else{
        print(sprintf("The critical value is %f and the test statistic is %f. %f > %f, so we do not reject H0.", chisquare_distribution, chi_square, chisquare_distribution, chi_square))
    }
}


#---------- main -------#
# #code1
# k <- 15
# alpha <- 0.05
# prob <- 0.2

# print(sprintf("Goodness of fit test for prob: %.1f.", prob))
# get_result(df1, prob, k, alpha)

# cat("\n")

# prob <- 0.9
# k <- 4
# print(sprintf("Goodness of fit test for prob: %.1f.", prob))
# get_result(df1, prob, k, alpha)


#code2
k <- 15
alpha <- 0.05
prob <- 0.2

print(sprintf("Goodness of fit test for prob: %.1f.", prob))
get_result(df2, prob, k, alpha)

cat("\n")

prob <- 0.9
k <- 4
print(sprintf("Goodness of fit test for prob: %.1f.", prob))
get_result(df2, prob, k, alpha)