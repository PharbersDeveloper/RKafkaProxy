# R Kafka Proxy
#

library(httr)
library(jsonlite)
# library(uuid)

#' Push R message to pharber/blackmirror message queue
#' @param content the message json buffer pushed to the kafka type => list()
#' @export
PushMessage <- function(content) {
    uri <- Sys.getenv("KAFKA_PROXY_URI");
    topic <- Sys.getenv("KAFKA_PROXY_R_CAL_TOPIC");

	# {"value_schema": "{\"type\": \"record\", \"name\": \"User\", \"fields\": [{\"name\": \"name\", \"type\": \"string\"}]}", "records": [{"value": {"name": "testUser"}}]}

	schema <- '{"type": "record", "name": "ListeningJobTask", "namespace": "com.pharbers.kafka.schema", "fields": [{"name": "JobId", "type": "string"}, {"name": "Status", "type": "string"}, {"name": "Message", "type": "string"}]}'

	value <- list(
		list(
			"value" = content
		)
	)
		
	avro <- jsonlite::toJSON(list("value_schema" = schema, "records" = value), auto_unbox = TRUE)

	print(avro)
	
	header <- add_headers("Content-Type" = "application/vnd.kafka.avro.v2+json", 
							Accept = "application/vnd.kafka.v2+json")
	
	url <- paste0(uri, "/", topic)

	print(url)

	r <- POST(url, body = avro, header)
	print(r)
}

#' Get Or Create Pharbers/Blackmirror Comsumer Instance
#' @export
GetOrCreateConsumerInstance <- function() {
    uri <- Sys.getenv("KAFKA_PROXY_URI")
    groupName = Sys.getenv("KAFKA_PROXY_R_GROUP")
    topic <- Sys.getenv("KAFKA_PROXY_R_CAL_TOPIC")
    consumerName <- Sys.getenv("KAFKA_PROXY_R_CONSSUMER_NAME")

    handle <- createHandle()
    handle_setheaders(handle, "Content-Type" = "application/vnd.kafka.v2+json")
    data = jsonlite::toJSON(list(name = consumerName, format = "json", "auto.offset.reset" = "earliest"), auto_unbox = TRUE)
    handle_setopt(handle, copypostfields = data);

    tryCatch({
        url <- paste0(uri, "/consumers/", groupName)
        con <- curl(url, handle = handle)
        open(con, "rb", blocking = FALSE)
        while(isIncomplete(con)) {
            out <- readLines(con, warn=FALSE)
        }
        close(con)
        return(TRUE)
    }, error = function(e){
        # http error 409: consumer instance already exist
        if (conditionMessage(e) == "HTTP error 409.") {
            return(TRUE)
        } else {
            return(FALSE)
        }
    })
}

#' Subscribe consumer with topic
#' @export
Subscribe <- function() {
    uri <- Sys.getenv("KAFKA_PROXY_URI")
    groupName = Sys.getenv("KAFKA_PROXY_R_GROUP")
    consumerName <- Sys.getenv("KAFKA_PROXY_R_CONSSUMER_NAME")

    handle <- createHandle()
    handle_setheaders(handle, "Content-Type" = "application/vnd.kafka.v2+json")
    data = jsonlite::toJSON(list(topics = list("GoCallRTopic")), auto_unbox = TRUE)
    handle_setopt(handle, copypostfields = data);

    url <- paste0(uri, "/consumers/", groupName, "/instances/", consumerName, "/subscription")
    con <- curl(url, handle = handle)
    open(con, "rb", blocking = FALSE)
    close(con)
}

#' Consumer One Message
#' @export
ConsumerMessages <- function(consumer_func) {
    uri <- Sys.getenv("KAFKA_PROXY_URI")
    groupName = Sys.getenv("KAFKA_PROXY_R_GROUP")
    topic <- Sys.getenv("KAFKA_PROXY_R_CAL_TOPIC")
    consumerName <- Sys.getenv("KAFKA_PROXY_R_CONSSUMER_NAME")

    handle <- createHandle()
    handle_setheaders(handle, "Accept" = "application/vnd.kafka.json.v2+json")
    url <- paste0(uri, "/consumers/", groupName ,"/instances/", consumerName, "/records")

    con <- curl(url, handle = handle)
    open(con, "rb", blocking = FALSE)
    out <- NULL
    while(isIncomplete(con)) {
        out <- readLines(con, warn=FALSE)
    }
    if (!is.null(out)) {
        consumer_func(out)
    }
    close(con)
}
