source('./util/kafka.r', chdir = TRUE)
source('./util/producer.r', chdir = TRUE)

# 监听器
listening <- function(fun, ...) {
    while(TRUE) {
        # 只是用来测试，这步骤应该放到计算完成后调用
        data = jsonlite::toJSON(list(records = list(list(value = list(foo = "bar")))),auto_unbox = TRUE)  
        sendResultMessage("http://127.0.0.1:8082/topics", "jsontest", data)

        fun(...)
        Sys.sleep(1)
    }
}

# go -> 调用R计算
callRConsumer <- function(consumerName, groupName) {
    # 接收到消息后执行你的计算，完成后将消息发送出去

    tryCatch({
        uri <- "http://127.0.0.1:8082" ## 我这里暂时写死，这个后续应该提到配置文件中
        handle <- createHandle()
        handle_setheaders(handle, "Accept" = "application/vnd.kafka.json.v2+json")
        url <- paste0(uri, "/consumers/", groupName ,"/instances/", consumerName, "/records")
        # print(url)
        con <- curl(url, handle = handle)
        open(con, "rb", blocking = FALSE)
        while(isIncomplete(con)) {
            out <- readLines(con, warn=FALSE)
            print(jsonlite::prettify(paste(out, collapse = "")))
        }
        close(con)
    }, error = function(e) {
        if (conditionMessage(e) == "HTTP error 404.") {
            res <- consumerInstance() # 获取Consumer实例
            subscription(res$groupName, res$consumerName) # 订阅
            listening(callRConsumer, res$consumerName, res$groupName) # 重新监听
        }
    })
    
}


