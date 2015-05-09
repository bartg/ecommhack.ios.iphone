//let API_URL = "http://localhost:8082/"
let API_URL = "http://faces.hern.as/"

let hostPollingLatency:NSTimeInterval = 1
let influencerPollingLatency:NSTimeInterval = 1

func DLOG(@autoclosure message:() -> String) {
    let message = message()
    if (isDebug()) {
        CLSNSLogv("%@", getVaList([message]))
    } else {
        CLSLogv("%@", getVaList([message]))
    }
}

func isDebug() -> Bool {
    #if DEBUG
        let debug = true
        #else
        let debug = false
    #endif
    return debug
}