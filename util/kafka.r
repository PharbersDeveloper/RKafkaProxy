
# Test
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
    return (h)
}

consumerInstance <- function() {
    uri = "http://127.0.0.1:8082" ## 我这里暂时写死，这个后续应该提到配置文件中
    groupName = "r_consumer_group"
    consumerName = paste0(UUIDgenerate(TRUE),"_consumer") #"001" # paste0(UUIDgenerate(TRUE),"_consumer")
    handle <- createHandle()
    handle_setheaders(handle, "Content-Type" = "application/vnd.kafka.v2+json")
    data = jsonlite::toJSON(list(name = consumerName, format = "json", "auto.offset.reset" = "earliest"), auto_unbox = TRUE)
    handle_setopt(handle, copypostfields = data);

    tryCatch({
        url <- paste0(uri, "/consumers/", groupName)
        print(url)
        con <- curl(url, handle = handle)
        open(con, "rb", blocking = FALSE)
        while(isIncomplete(con)) {
            out <- readLines(con, warn=FALSE)
            print("Consumer Instance")
            print(jsonlite::prettify(paste(out, collapse = "")))
        }
        close(con)
    }, error = function(e){
         if (conditionMessage(e) == "HTTP error 409.") {
            return (list(consumerName = consumerName, groupName = groupName))
         }
    })
    
    return (list(consumerName = consumerName, groupName = groupName))
}

subscription <- function(groupName, consumerName) {
    uri = "http://127.0.0.1:8082" ## 我这里暂时写死，这个后续应该提到配置文件中
    handle <- createHandle()
    handle_setheaders(handle, "Content-Type" = "application/vnd.kafka.v2+json") 
    data = jsonlite::toJSON(list(topics = list("jsontest")), auto_unbox = TRUE)
    handle_setopt(handle, copypostfields = data);
    # my_json_consumer
    # my_consumer_instance
    url <- paste0(uri, "/consumers/", groupName, "/instances/", consumerName, "/subscription")
    print(url)
    con <- curl(url, handle = handle)
    open(con, "rb", blocking = FALSE)
    close(con)
}