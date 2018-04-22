

import UIKit

class VoucherCell: UITableViewCell {

    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    func config(voucher: Voucher) {
        discountLbl.text = voucher.discount
        nameLbl.text = voucher.name
        priceLbl.text = "\(String(voucher.price)) points"
        descriptionLbl.text = voucher.description
        dateLbl.text = AppUtil.shared.formantTimeStamp(isoDate: voucher.expiration)
        logoImg.load(imgUrl: voucher.imgPath)
    }

    @IBAction func exchangeBtnWasPressed(_ sender: Any) {
    }

}
