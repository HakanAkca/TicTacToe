//
//  ModalOnlineController.swift
//  TicTacToe
//
//  Created by SUP'Internet 04 on 27/06/2018.
//  Copyright © 2018 Hakan Akca. All rights reserved.
//

import UIKit

class ModalOnlineController: UIViewController {

    @IBOutlet weak var playerAdverse: UILabel!
    @IBOutlet weak var playerTurn: UILabel!
    @IBOutlet weak var winnerText: UILabel!
    
    
    var data: Any?
    var turn: String = ""
    var playerX = ""
    var playerO = ""
    
    @IBAction func stop(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        TTTSocket.sharedInstance.socket.emit("leave_game")
    }
    
    
    @IBAction func handleClick(_ sender: UIButton) {
        if((self.turn == "o" && self.playerO == "hakan") || (self.turn == "x" && self.playerX == "hakan")){
            if(self.playerO == "hakan"){
                sender.setImage(UIImage(named: "Nought.png"), for: .normal)
            }else{
                sender.setImage(UIImage(named: "Cross.png"), for: .normal)
            }
            TTTSocket.sharedInstance.socket.emit("movement", (sender.tag - 1) )
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paramsArray = data as! NSArray
        let unwrappedDictJson = paramsArray[0] as! [String: Any]
        playerX = unwrappedDictJson["playerX"]! as! String
        playerO = unwrappedDictJson["playerO"]! as! String
        if(playerX == "hakan"){
            playerAdverse.text = "Vous jouez avec \(playerO)"
        }else{
            playerAdverse.text = "Vous jouez avec \(playerX)"
        }
        
        turn = unwrappedDictJson["currentTurn"]! as! String
        checkTurn(param: turn)
        
        TTTSocket.sharedInstance.socket.on("movement", callback: { (data, ack) in
            let tmpJson = data as NSArray
            let jsonParsed = tmpJson[0] as! [String: Any]
            print(jsonParsed)
            self.turn = jsonParsed["player_play"]! as! String
            self.checkTurn(param: self.turn)
            if( (jsonParsed["player_played"]! as! String == "x" && self.playerX == "hakan2") || (self.playerO == "hakan2" && jsonParsed["player_played"]! as! String == "o" )){
                let tmpTag = (jsonParsed["index"]! as! Int) + 1
                let imgToPut = self.view .viewWithTag(tmpTag) as? UIButton
                imgToPut?.setImage(UIImage(named: "Cross.png"), for: .normal)
                if(self.playerX == "hakan2"){
                    
                    imgToPut?.setImage(UIImage(named: "Cross.png"), for: .normal)
                }else{
                    imgToPut?.setImage(UIImage(named: "Nought.png"), for: .normal)
                }
            }
            let win = jsonParsed["win"]! as! Bool
            if(win == true){
                if(jsonParsed["player_played"] as! String == self.playerX){
                    self.winnerText.text = "\(self.playerX) à gagner !"
                }else{
                    self.winnerText.text = "\(self.playerO) à gagner !"
                }
            }
        })
    }
    
    
    func checkTurn(param: String){
        if((param == "x" && self.playerX == "hakan") || (param == "o" && self.playerO == "hakan") ){
            playerTurn.text = "Votre tour"
        }else{
            playerTurn.text = "à l'adversaire"
        }
    }
}
