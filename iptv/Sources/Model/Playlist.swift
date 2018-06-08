//
//  Playlist.swift
//  iptv
//
//  Created by Artem Stepuk on 6/8/18.
//  Copyright © 2018 Artem Stepuk. All rights reserved.
//

import Foundation

struct Playlist {
    let title: String
    let url: URL
    let content: String
}

func m3u8parser(data: String) -> [Channel] {
    var channels = [Channel]()
    data.enumerateLines { line, shouldStop in
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
