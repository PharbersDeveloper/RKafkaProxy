
getCurl <- function(url) {
    h <- createHandle(FALSE)
    print(h)
    con <- curl(url, handle = h)
    open(con, "rb", blocking = FALSE)
    while(isIncomplete(con)) {
        out <- readLines(con, warn=FALSE)
        print(jsonlite::prettify(paste(out, collapse = "")))
    }
    close(con)
}

createHandle <- function(method) {
    h <- new_handle()
    handle_setheaders(h, 
        "Content-Type" = "application/vnd.kafka.v2+json", 
        "Cache-Control" = "no-cache", 
        "Accept" = "application/vnd.kafka.v2+json")
    
    return (h)
}

consumerInstance <- function() {
    uri <- "http://192.168.100.116:8082"## 我这里暂时写死，这个后续应该提到配置文件中
    handle <- createHandle(TRUE)
    data = jsonlite::toJSON(list(name = "my_consumer_instance", format = "json", "auto.offset.reset" = "earliest"), auto_unbox = TRUE)
    handle_setopt(handle, copypostfields = data);
    url <- paste0(uri, "/consumers/my_json_consumer")
    print(url)
    con <- curl(url, handle = handle)
    open(con, "rb", blocking = FALSE)
    while(isIncomplete(con)) {
        out <- readLines(con, warn=FALSE)
        print("fuck")
        print(jsonlite::prettify(paste(out, collapse = "")))
    }
    close(con)
}