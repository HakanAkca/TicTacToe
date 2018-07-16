//
//  OnlineController.swift
//  TicTacToe
//
//  Created by SUP'Internet 04 on 27/06/2018.
//  Copyright © 2018 Hakan Akca. All rights reserved.
//

import UIKit
import SwiftSpinner

class OnlineController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        TTTSocket.sharedInstance.socket.on("join_game", callback: { (data, ack) in
            SwiftSpinner.hide()
            self.performSegue(withIdentifier: "seguePlayOnline", sender: data)
            print(data)
        })
        
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "seguePlayOnline"){
            let controller = segue.destination as! ModalOnlineController
            controller.data = sender
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var loadText: UILabel!
    
    @IBAction func playButton(_ sender: UIButton) {
        SwiftSpinner.show("Chargement en cours")
        TTTSocket.sharedInstance.socket.emit("join_queue", "hakan")
    }

}
