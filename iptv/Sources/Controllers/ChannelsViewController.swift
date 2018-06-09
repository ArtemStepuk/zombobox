
import UIKit
import AVKit

class ChannelCollectionCell: UICollectionViewCell {
    @IBOutlet var title: UILabel!

    override func didUpdateFocus(in context: UIFocusUpdateContext,
                                 with coordinator: UIFocusAnimationCoordinator) {
        if isFocused {
            layer.borderWidth = 2
            layer.borderColor = UIColor.blue.cgColor
            layer.transform = CATransform3DMakeScale(1.15, 1.15, 1);
        } else {
            layer.borderWidth = 0
            layer.borderColor = UIColor.white.cgColor
            layer.setAffineTransform(.identity)
        }
    }
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellsIDs.channel.rawValue,
                                                      for: indexPath)
        if let cell = cell as? ChannelCollectionCell {
            cell.title.text = channels[indexPath.row].title
        }

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        selectedChannel = channels[indexPath.row]
        performSegue(withIdentifier: SeguesIDs.player.rawValue, sender: self)
    }
}

extension ChannelsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? AVPlayerViewController,
            let channel = selectedChannel,
            let channelURL = channel.url {

            target.player = AVPlayer(url: channelURL)
            target.player?.play()
        } else {
            print("error") //TODO:
        }
    }
}
