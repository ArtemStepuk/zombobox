import UIKit
import NVActivityIndicatorView

private let channelsURLString = "https://smarttvnews.ru/apps/iptvchannels.m3u"

class ConnectionViewController: UIViewController {

    @IBOutlet var activityView: NVActivityIndicatorView!
    private var playlist: Playlist?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        activityView.type = .ballScaleMultiple
        activityView.color = .white
        activityView.startAnimating()
        
        loadChannels { playlist in
            DispatchQueue.main.async {
                self.playlist = playlist
                self.activityView.stopAnimating()
                self.performSegue(withIdentifier: "channels", sender: self)
            }
        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let target = segue.destination as? ChannelsViewController
        if let playlist = playlist {
            target?.channels = m3u8parser(data: playlist.content)
        } else {
        }
    }

    private func loadChannels(completion: @escaping (Playlist?) -> Void) {
        if let url = URL(string: channelsURLString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let string = String(data: data, encoding: .utf8) {
                    completion(Playlist(title: "Default", url: url, content: string))
                } else {
                    completion(nil)
                }
            }
            task.resume()
        } else {
        }
    }
}
