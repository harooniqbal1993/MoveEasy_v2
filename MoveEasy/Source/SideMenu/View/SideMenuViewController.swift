//
//  SideMenuViewController.swift
//  MoveEasy
//
//  Created by Apple on 09/12/1443 AH.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    struct SideMenuModel {
        var icon: String?
        var name: String?
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var sideMenuTableView: UITableView!
    @IBOutlet weak var rideCountLabel: UILabel!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var yearsCountLabel: UILabel!
    @IBOutlet weak var statsOuterStackView: UIStackView!
    @IBOutlet weak var rideStackView: UIStackView!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var yearStackView: UIStackView!
    
    var menuItems: [SideMenuModel] = [SideMenuModel(icon: "home", name: "Home"), SideMenuModel(icon: "map-marked-alt", name: "My trips"), SideMenuModel(icon: "bell", name: "Notification"), SideMenuModel(icon: "calendar-day", name: "Schedule pickup"), SideMenuModel(icon: "user-plus", name: "Refer a driver"), SideMenuModel(icon: "comment-alt", name: "Feedback"), SideMenuModel(icon: "cog", name: "Setting"), SideMenuModel(icon: "sign-in-alt", name: "Logout")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadViews()
    }
    
    func configure() {
        sideMenuTableView.register(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
    }
    
    func loadViews() {
        profileImage.round()
        statsOuterStackView.border(color: .systemGray4, radius: 0.0, width: 1.0)
        rideStackView.addRightBorderWithColor(color: .systemGray4, width: 1.0)
        ratingStackView.addLeftBorderWithColor(color: .systemGray4, width: 1.0)
        ratingStackView.addRightBorderWithColor(color: .systemGray4, width: 1.0)
        yearStackView.addLeftBorderWithColor(color: .systemGray4, width: 1.0)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        //        self.revealViewController().revealToggle(self)
        performSegue(withIdentifier: "profile_segue", sender: nil)
    }
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.icon.image = UIImage(named: menuItems[indexPath.row].icon!)
        cell.nameLabel.text = menuItems[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let loginViewController: LoginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let nav = UINavigationController(rootViewController: loginViewController)
//        UIApplication.shared.keyWindow?.rootViewController = nav
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
//        let rootVC = window?.rootViewController
        window?.rootViewController = nav
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}
