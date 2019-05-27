
getCurl <- function(url) {
    h <- createHandle()
    print(h)
    con <- curl(url, handle = h)
    open(con, "rb", blocking = FALSE)
    while(isIncomplete(con)) {
        out <- readLines(con, warn=FALSE)
        print(jsonlite::prettify(paste(out, collapse = "")))
    }
    close(con)
}

createHandle <- function() {
    h <- new_handle()
    handle_setheaders(h, 
        "Content-Type" = "application/vnd.kafka.v2+json", 
        "Cache-Control" = "no-cache", 
        "Accept" = "application/vnd.kafka.json.v2+json")
    
    return (h)
}

# curl -X POST -H "Content-Type: application/vnd.kafka.v2+json" --data '{"topics":["jsontest"]}' \
#  http://localhost:8082/consumers/my_json_consumer/instances/my_consumer_instance/subscription
consumerInstance <- function() {
    uri <- "http://127.0.0.1:8082" ## 我这里暂时写死，这个后续应该提到配置文件中
    handle <- createHandle()
    data = jsonlite::toJSON(list(name = "my_consumer_instance", format = "json", "auto.offset.reset" = "earliest"), auto_unbox = TRUE)
    handle_setopt(handle, copypostfields = data);
    url <- paste0(uri, "/consumers/my_json_consumer")
    print(url)
    con <- curl(url, handle = handle)
    open(con, "rb", blocking = FALSE)
    while(isIncomplete(con)) {
        out <- readLines(con, warn=FALSE)
        print("Consumer Instance")
        print(jsonlite::prettify(paste(out, collapse = "")))
    }
    close(con)

    handle <- createHandle()
    data = jsonlite::toJSON(list(topics = list("jsontest")), auto_unbox = TRUE)
    handle_setopt(handle, copypostfields = data);
    url <- paste0(uri, "/consumers/my_json_consumer/instances/my_consumer_instance/subscription")
    print(url)
    con <- curl(url, handle = handle)
    open(con, "rb", blocking = FALSE)
    close(con)

}