//
//  ViewController.swift
//  d06
//
//  Created by Zenande GODONGWANA on 2018/10/08.
//  Copyright © 2018 Zenande GODONGWANA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var itemView: Item!
    
    
    @IBAction func tapEvent(_ sender: UITapGestureRecognizer) {
        
        let point = sender.location(in: itemView)
        itemView.add(point: point)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        itemView.animation = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        itemView.animation = false

    }
}
