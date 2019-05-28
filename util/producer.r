source('./util/kafka.r', chdir = TRUE)

## Produce a message using JSON with the value ${body} to the topic
sendResultMessage <- function(uri, topic, body) {
    handle <- createHandle()
    handle_setheaders(handle, 
        "Content-Type" = "application/vnd.kafka.json.v2+json",
        "Accept" = "application/vnd.kafka.v2+json"
    )
    handle_setopt(handle, copypostfields = body);

    url <- paste0(uri, "/" ,topic)
    con <- curl(url, handle = handle)
    open(con, "rb", blocking = FALSE)
    # while(isIncomplete(con)) {
    #     print("SendMessage")
    # }
    # close(con)
}
