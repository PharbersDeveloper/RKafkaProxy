source('./util/kafka.r', chdir = TRUE)

## Produce a message using JSON with the value ${body} to the topic

# --data '{"records":[{"value":{"foo":"bar"}}]}' "http://localhost:8082/topics/jsontest"
sendResultMessage <- function(uri, topic, body) {
    handle <- createHandle(TRUE)

    # meta <- list(list(value = list(foo = "bar")))
    # data = jsonlite::toJSON(list(records = jsonlite::toJSON(meta, auto_unbox = TRUE)), auto_unbox = TRUE    

    handle_setopt(handle, copypostfields = body);

    url <- paste0(uri, topic)
    con <- curl(url, handle = handle)
    open(con, "rb", blocking = FALSE)
    while(isIncomplete(con)) {
        out <- readLines(con, warn=FALSE)
        print("SendMessage")
        print(jsonlite::prettify(paste(out, collapse = "")))
    }
    close(con)
}
