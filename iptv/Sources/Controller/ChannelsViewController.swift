
import UIKit
import AVKit

class ChannelCollectionCell: UICollectionViewCell {
    @IBOutlet var title: UILabel!
}

class ChannelsViewController: UICollectionViewController {

    var channels: [Channel] = []
    var selectedChannel: Channel?

    override func viewDidLoad() {
        super.viewDidLoad()
        clearsSelectionOnViewWillAppear = true
    }
}

extension ChannelsViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return channels.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "channel",
                                                      for: indexPath)
        if let cell = cell as? ChannelCollectionCell {
            cell.title.text = channels[indexPath.row].title
        }

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedChannel = channels[indexPath.row]
        performSegue(withIdentifier: "player", sender: self)
    }
}

extension ChannelsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? AVPlayerViewController,
            let channel = selectedChannel, let channelURL = channel.url {

            target.player = AVPlayer(url: channelURL)
            target.player?.play()
        } else {
        }
    }
}
