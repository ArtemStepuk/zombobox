import Foundation

protocol NetworkService {
    func playlist(from url: URL, completion: @escaping (Result<RawPlaylist>) -> Void )
}

protocol M3U8ParserService {
    func extractChannelsFromRawString(_ string: String) -> [Channel]
}

struct IPTVNetworkService {
    let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
}

extension IPTVNetworkService: NetworkService {
    func playlist(from url: URL, completion: @escaping (Result<RawPlaylist>) -> Void) {
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(Result(error: error))
            } else {

                if let data = data, let string = String(data: data, encoding: .utf8) {
                    completion(Result(value: RawPlaylist(url: url, content: string)))
                } else {
                    completion(Result(error: IPTVError.unknownServerDataFormat))
                }
            }
        }
        task.resume()
    }
}

struct IPTVM3U8PareserService {
}

extension IPTVM3U8PareserService: M3U8ParserService {
    func extractChannelsFromRawString(_ string: String) -> [Channel] {
        var channels = [Channel]()
        string.enumerateLines { line, shouldStop in
            if line.hasPrefix("#EXTINF:") {
                let infoLine = line.replacingOccurrences(of: "#EXTINF:", with: "")
                let infoItems = infoLine.components(separatedBy: ",")
                if let title = infoItems.last {
                    let channel = Channel(title: title, url: nil)
                    channels.append(channel)
                }
            } else {
                if var channel = channels.popLast() {
                    channel.url = URL(string: line)
                    channels.append(channel)
                }
            }
        }
        return channels
    }
}
