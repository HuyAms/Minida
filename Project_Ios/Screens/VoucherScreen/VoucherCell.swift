

import UIKit

class VoucherCell: UITableViewCell {
    
    var onButtonTapped : (() -> Void)? = nil
    var voucherLoadingState: VoucherLoadingState!

    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var exchangeBtn: UIButton!
    @IBOutlet weak var qrCodeView: UIView!
    @IBOutlet weak var cellContentView: UIView!
    
    override func awakeFromNib() {
        exchangeBtn.setTitle("Exchange".localized, for: .normal)
    }
    
    func config(voucher: Voucher, voucherLoadingState: VoucherLoadingState) {
        self.voucherLoadingState = voucherLoadingState
        
        switch voucherLoadingState {
        case .loadMyVouchers:
            exchangeBtn.isHidden = true
        default:
            exchangeBtn.isHidden = false
        }
       
        let tapGesture = UITapGestureRecognizer(target: self
            , action: #selector(VoucherCell.changeQRCodeVisibility(_:)))
        cellContentView.addGestureRecognizer(tapGesture)
        
        discountLbl.text = voucher.discount
        nameLbl.text = voucher.name
        priceLbl.text = "%d points".localized(arguments: voucher.price)
        descriptionLbl.text = voucher.description
        dateLbl.text = AppUtil.shared.formantTimeStamp(isoDate: voucher.expiration)
        logoImg.load(imgUrl: voucher.imgPath)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        qrCodeView.isHidden = true
    }
    
    @objc private func changeQRCodeVisibility(_ sender: UITapGestureRecognizer) {
        if (qrCodeView.isHidden) {
            UIView.transition(with: self.cellContentView, duration: 0.7, options: .transitionFlipFromRight, animations: {
                self.qrCodeView.isHidden = false
            }, completion: nil)
        } else {
            UIView.transition(with: self.cellContentView, duration: 0.7 , options: .transitionFlipFromLeft, animations: {
                self.qrCodeView.isHidden = true
            }, completion: nil)
        }
    }

    @IBAction func exchangeBtnWasPressed(_ sender: Any) {
        if let onButtonTapped = self.onButtonTapped {
            onButtonTapped()
        }
    }

}
