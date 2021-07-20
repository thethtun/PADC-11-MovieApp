//
//  YouTubePlayerViewController.swift
//  Starter
//
//  Created by Thet Htun on 6/6/21.
//

import UIKit
import YouTubePlayer


class YouTubePlayerViewController: UIViewController {

    @IBOutlet var videoPlayer: YouTubePlayerView!

    var youtubeId : String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let id = youtubeId {
            videoPlayer.loadVideoID(id)
            videoPlayer.play()
        } else {
            //invalid youTube ID
            print("Invalid YouTubeID")
        }

    }


    @IBAction func onClickDismiss(_ sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
