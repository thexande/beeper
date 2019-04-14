//
//  ViewController.swift
//  beeper_example
//
//  Created by Alexander Murphy on 4/13/19.
//  Copyright © 2019 Alexander Murphy. All rights reserved.
//

import UIKit
import beeper
import CommonCrypto
import Anchorage

extension String {
    
    func sha512() -> String {
        let data = self.data(using: .utf8) ?? Data()
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        data.withUnsafeBytes({
            _ = CC_SHA512($0, CC_LONG(data.count), &digest)
        })
        return digest.map({ String(format: "%02hhx", $0) }).joined(separator: "")
    }
    
}

struct Dummy {
    static let properties: ViewController.Properties =
        .init(pages: Array(repeating:
            .init(sections: Array(repeating:
                .init(title: String(Int.random(in: 0...1000)),
                      rows: Array(repeating: .init(title: String(Int.random(in: 0...1000)),
                                                   subtitle: String(Int.random(in: 0...1000)).sha512()), count: 5)), count: 10)), count: 10))
}


class ViewController: PagerViewController  {
    
    struct Properties {
        
        struct Page {
            
            struct Section {
                
                struct Row {
                    let title: String
                    let subtitle: String
                }
                
                let title: String
                var rows: [Row]
            }
            
            var sections: [Section]
        }
        
        var pages: [Page]
    }
    
    var properties: Properties = .init(pages: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        properties = Dummy.properties
        delegate = self
        datasource = self
        
        reloadData()
    }
}

extension ViewController: PagerViewDelegate, PagerViewDatasource {
    public func titleForPage() -> String {
        return "woot"
    }
    
    public func view(for index: Int) -> UIView {
        let view = ListView()
        view.render(properties.pages[index].sections)
        return view
    }
    
    public func numberOfPages() -> Int {
        return self.properties.pages.count
    }
}

final class ListView: UIView, ViewRendering {
    
    typealias Properties = [ViewController.Properties.Page.Section]
    private let table = UITableView(frame: .zero, style: .grouped)
    var properties: Properties = []
    
    func render(_ properties: [ViewController.Properties.Page.Section]) {
        self.properties = properties
        table.reloadData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(table)
        table.edgeAnchors == edgeAnchors
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: String(describing: UITableViewCell.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ListView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return properties.count
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return properties[section].rows.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))
        cell?.textLabel?.text = properties[indexPath.section].rows[indexPath.row].title
        cell?.detailTextLabel?.text = properties[indexPath.section].rows[indexPath.row].subtitle
        return cell ?? UITableViewCell()
    }
    
    
}

protocol ViewRendering {
    associatedtype Properties
    func render(_ properties: Properties)
}
