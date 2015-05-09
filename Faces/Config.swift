let API_URL = "https://api.sharklist.it/"
let SPOTIFY_CLIENT_ID = "a7551c3c61e7456e93aae7e54cefa238"
let SPOTIFY_CALLBACK_URL = "sharklist://spotify-callback"
let SPOTIFY_TOKEN_SWAP_URL = "\(API_URL)auth/swap"
let SPOTIFY_TOKEN_REFRESH_URL = "\(API_URL)auth/refresh"

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