//
//  ViewController.swift
//  AVExample
//
//  Created by Muhammad Tafani Rabbani on 23/04/21.
//

import UIKit
import AVFoundation //audio video

class ViewController: UIViewController {

    var player : AVAudioPlayer?
    
    var speech = SpeechPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        speech.say("Haloo semuanya apa kabar?")
        speech.say("Rajaa")
    }

    func playMusic(){
        //akses alamat
        let path = Bundle.main.path(forResource: "music", ofType:"wav")!
        //ubah alamatnya jadi url
        let url = URL(fileURLWithPath: path)
        do {
            //masukin url ke audio player
            player = try AVAudioPlayer(contentsOf: url)
            //player di mainkan
            player?.play()
        } catch {
            // couldn't load file :(
        }
    }

    @IBAction func startMusic(_ sender: Any) {
        playMusic()
    }
    @IBAction func stopMusic(_ sender: Any) {
        player?.stop()
    }
}

class SpeechPlayer{
    
    let synthesizer  = AVSpeechSynthesizer()
    
    func say(_ phrase:String){
        
        let utterence = AVSpeechUtterance(string: phrase)
        utterence.voice = AVSpeechSynthesisVoice(language: "id-ID")
//        print(utterence.rate)
//        utterence.rate = 0.3
        
        synthesizer.speak(utterence)
        
    }
    
}
