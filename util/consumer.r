source('./util/kafka.r', chdir = TRUE)

# 监听器
listening <- function(fun) {
    while(TRUE) {
        fun()
        Sys.sleep(1)
    }
}

# go -> 调用R计算
#  curl -X GET -H "Accept: application/vnd.kafka.json.v2+json" \
    #   http://localhost:8082/consumers/my_json_consumer/instances/my_consumer_instance/records
callRConsumer <- function() {
    # consumerInstance() # 获取Consumer实例，有就用，没有会自动创建
    # 接收到消息后执行你的计算，完成后将消息发送出去
    # print(Sys.time())

    # uri <- "http://127.0.0.1:8082" ## 我这里暂时写死，这个后续应该提到配置文件中
    # handle <- createHandle()
    # url <- paste0(uri, "/consumers/my_json_consumer/instances/my_consumer_instance/records")
    # print(url)
    # con <- curl(url, handle = handle)
    # open(con, "rb", blocking = FALSE)
    # while(isIncomplete(con)) {
    #     out <- readLines(con, warn=FALSE)
    #     print("Fuck")
    #     print(out)
    #     print(jsonlite::prettify(paste(out, collapse = "")))
    # }
    # close(con)
}


