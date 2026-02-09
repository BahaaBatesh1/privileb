import UIKit
import Foundation

class CustomTabBarController: UITabBarController {
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColor.black
        self.automaticallyAdjustsScrollViewInsets = false
        setupMiddleButton()
    }
    
    // MARK: - Setups
    
    func setupMiddleButton() {
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height - 10
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame
        
        menuButton.backgroundColor = UIColor.clear
        //menuButton.layer.cornerRadius = menuButtonFrame.height/2
        
        menuButton.imageView?.frame.origin.y = menuButton.bounds.height
        
//        menuButton.layer.cornerRadius = menuButton.layer.frame.width / 2
        menuButton.setImage(UIImage(named: "king_mark"), for: .normal)
        menuButton.setImage(UIImage(named: "king_mark"), for: .selected)
        menuButton.tag = 100
        menuButton.adjustsImageWhenHighlighted = false
        menuButton.showsTouchWhenHighlighted = false
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
       menuButton.setBackgroundImage(UIImage(named:"circle_select"), for: .normal)
        view.addSubview(menuButton)
        view.layoutIfNeeded()
    }
    
    
    // MARK: - Actions
    
    @objc private func menuButtonAction(sender: UIButton) {
        (self.view.viewWithTag(100) as! UIButton).setBackgroundImage(UIImage(named:"circle_select"), for: .normal)
            selectedIndex = 2
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == tabBar.items?[2] {
            (self.view.viewWithTag(100) as! UIButton).setBackgroundImage(UIImage(named:"circle_select"), for: .normal)
        }else{
            (self.view.viewWithTag(100) as! UIButton).setBackgroundImage(UIImage(named:"circle_select"), for: .normal)
        }
    }
}
