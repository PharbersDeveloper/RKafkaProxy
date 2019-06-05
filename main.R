library(curl)
library(jsonlite)
library(uuid)

# source('./util/kafka.r', chdir = TRUE)
source('./util/consumer.r', chdir = TRUE)
# Topic的名称
# Go -> R Topic Name => GoCallRTopic
# R -> Go Topic Name => RReturnResult

main <- function() {
#    getCurl("https://eu.httpbin.org/get")

    # consumerInstance()

    listening(callRConsumer, "", "")
   
}

main()