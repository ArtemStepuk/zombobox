import UIKit

class ConnectionViewController: UIViewController {

    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    private var playlist: RawPlaylist?
    private let networkService: NetworkService = IPTVNetworkService()
    private let parserService: M3U8ParserService = IPTVM3U8PareserService()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.activityIndicator.startAnimating()
        networkService.playlist(from: Config.playlistURL) { result in
            switch result {
            case .value(let rawPlaylist):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.playlist = rawPlaylist
                    self.performSegue(withIdentifier: SeguesIDs.channels.rawValue, sender: self)
                }
            case .error(let error):
                print(error) //TODO:
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let playlist = playlist, let target = segue.destination as? ChannelsViewController {
            target.channels = parserService.extractChannelsFromRawString(playlist.content)
        } else {
        }
    }
}
