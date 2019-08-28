//
//  DetailEventVC.swift
//  cycle
//
//  Created by Azmi Muhammad on 24/08/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import UIKit

class DetailEventVC: UIViewController {

    @IBOutlet weak var startButton: UIButton! {
        didSet {
            startButton.setupRadius(type: .custom(12.0))
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.estimatedRowHeight = UITableView.automaticDimension
            tableView.register(UINib(nibName: MapCell.identifier, bundle: nil), forCellReuseIdentifier: MapCell.identifier)
            tableView.register(UINib(nibName: DetailCell.identifier, bundle: nil), forCellReuseIdentifier: DetailCell.identifier)
            tableView.register(UINib(nibName: TeamCell.identifier, bundle: nil), forCellReuseIdentifier: TeamCell.identifier)
            tableView.estimatedRowHeight = UITableView.automaticDimension
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavController(title: "Detail Event", prefLargeTitle: true, isHidingBackButton: false)
        view.backgroundColor = UIColor(hex: "#F9F9F9")
    }
    
    @IBAction func onStartTapped(_ sender: UIButton) {
        
        let temp = UIApplication.shared.delegate as! AppDelegate
        
        temp.subscribe()
        
        
        /*fR
            Activity(activityID: "2265", routes: [__C.CLLocationCoordinate2D(latitude: 37.323223111566776, longitude: -122.02272713184357), __C.CLLocationCoordinate2D(latitude: 37.3691563, longitude: -122.0384235)], messageID: 0, message: "", userID: "", date: 1566661515, ref: Optional(https://boyedata.firebaseio.com/activities/-Lmz8r61znXJhysB1S6g), key: "-Lmz8r61znXJhysB1S6g")
        */
    }
}

extension DetailEventVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return cellForMapView(tableView, indexPath)
        case 1:
            return cellForDetailView(tableView, indexPath)
        case 2:
            return cellForMemberView(tableView, indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    private func cellForMapView(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MapCell.identifier, for: indexPath) as? MapCell else { return UITableViewCell() }
        
        return cell
    }
    
    private func cellForDetailView(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell.identifier, for: indexPath) as? DetailCell else { return UITableViewCell() }
        cell.setupView()
        return cell
    }

    private func cellForMemberView(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TeamCell.identifier, for: indexPath) as? TeamCell else { return UITableViewCell() }
        
        return cell
    }
}
