calcQueue <- list() # 真正排队的人数
execQueue <- list() # 执行队列Size永远是 <= 2

# 等待队列大小
queueSize <- function() {
    return (length(calcQueue))
}

# 执行队列是否为空
queueIsEmpty <- function() {
    return (length(execQueue) == 0)
}

# 向队等待列末尾压入Element
queueAdd <- function(key, value) {
    calcQueue[[key]] <<- value
    if(length(execQueue) != 2 && length(calcQueue) != 0) {
        execQueue <<- append(execQueue, calcQueue[1])
        queuePoll()
    }
    # if (queueIsEmpty() && length(calcQueue) == 1) {
    #     execQueue <<- append(execQueue, calcQueue[1])
    #     queuePoll()
    # } else if (queueIsEmpty() && length(calcQueue) >= 2) {
    #     execQueue <<- append(execQueue, calcQueue[1])
    #     execQueue <<- append(execQueue, calcQueue[2])
    #     queuePoll()
    #     queuePoll()
    # } else if(length(execQueue) != 2 && length(calcQueue) != 0) {
    #     execQueue <<- append(execQueue, calcQueue[1])
    #     queuePoll()
    # }
    # queueExecUpdate()
}

# calcQueue返回头元素删除Element
queuePoll <- function() {
    calcQueue[[1]] <<- NULL
}

execQueuePoll <- function() {
   execQueue[[1]] <<- NULL 
}

# 更新执行队列，从排队队列取出Element压入其中
queueExecUpdate <- function() {
    execQueuePoll()
    if (queueIsEmpty() && length(calcQueue) == 1) {
        execQueue <<- append(execQueue, calcQueue[1])
        queuePoll()
    } else if (queueIsEmpty() && length(calcQueue) >= 2) {
        execQueue <<- append(execQueue, calcQueue[1])
        execQueue <<- append(execQueue, calcQueue[2])
        queuePoll()
        queuePoll()
    } else if(length(execQueue) != 2 && length(calcQueue) != 0) {
        execQueue <<- append(execQueue, calcQueue[1])
        queuePoll()
    }
}

# 获取执行队列
getQueueExec <- function() {
    return (execQueue)
}

getQueueExecNext <- function() {
    # execQueue[[1]] <<- NULL
    return (execQueue[1])
}

# 执行加入等待队列
queueAdd("a1", 112)
queueAdd("a2", 213)
queueAdd("a3", 432)
queueAdd("a4", 535)
queueAdd("a5", 356)
queueAdd("a6", 146)

print(getQueueExec())
queueExecUpdate()
print(calcQueue)

# Test
queueAdd("a1", 112)
queueAdd("a2", 213)
queueAdd("a3", 432)
queueAdd("a4", 535)
queueAdd("a5", 356)
queueAdd("a6", 146)
calc <- function() {
    while (TRUE) {
        if (!queueIsEmpty()) {
            print(getQueueExecNext())
            queueExecUpdate() # 计算完成之后更新
        }
    }
}
calc()
