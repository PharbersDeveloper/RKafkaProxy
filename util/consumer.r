source('./util/kafka.r', chdir = TRUE)

# 监听器
listening <- function(fun) {
    while(TRUE) {
        fun()
        Sys.sleep(1)
    }
}

# go -> 调用R计算
callRConsumer <- function() {
    consumerInstance() # 获取Consumer实例，有就用，没有会自动创建
    # 接收到消息后执行你的计算，完成后将消息发送出去
    # print(Sys.time())
}


