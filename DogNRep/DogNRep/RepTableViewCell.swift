//
//  RepTableViewCell.swift
//  DogNRep
//
//  Created by Megan Schmoyer on 12/5/23.
//

import UIKit

class RepTableViewCell: UITableViewCell {
    @IBOutlet weak var repNameLabel: UILabel!
    var name: String? = nil {
        didSet {
            if oldValue != name {
                setNeedsUpdateConfiguration()
            }
            repNameLabel.text = name
        }
    }
    @IBOutlet weak var repPartyLabel: UILabel!
    var party: String? = nil {
        didSet {
            if oldValue != party {
                setNeedsUpdateConfiguration()
            }
            repPartyLabel.text = party
        }
    }
    @IBOutlet weak var repLinkLabel: UILabel!
    var link: String? = nil {
        didSet {
            if oldValue != link {
                setNeedsUpdateConfiguration()
            }
            repLinkLabel.text = link
        }
    }
    override func updateConfiguration(using state: UICellConfigurationState) {
        var content = defaultContentConfiguration().updated(for: state)
        content.text = name
        content.secondaryText = party
        content.secondaryText = link
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
