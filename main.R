library(curl)
library(jsonlite)

# source('./util/kafka.r', chdir = TRUE)
source('./util/consumer.r', chdir = TRUE)
source('./util/producer.r', chdir = TRUE)

main <- function() {
#    getCurl("https://eu.httpbin.org/get")

    listening(callRConsumer)

    # consumerInstance()
    
}

main()