library(curl)
library(jsonlite)
library(uuid)

# source('./util/kafka.r', chdir = TRUE)
source('./util/consumer.r', chdir = TRUE)


main <- function() {
#    getCurl("https://eu.httpbin.org/get")

    # consumerInstance()

    listening(callRConsumer, "", "")
   
}

main()