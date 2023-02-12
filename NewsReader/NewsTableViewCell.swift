// custom table view cell

import UIKit

class NewsTableViewCellViewModel
{
    let title:String
    let subtitle:String
    let imageURL:URL?
    var imageData:Data?=nil
    
    init(title: String, subtitle: String, imageURL: URL?, imageData: Data? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.imageData = imageData
    }
}
class NewsTableViewCell: UITableViewCell {
    static let identifier="NewsTableViewCell"
    
    private let newsTitleLabel:UILabel={
        let label=UILabel()
        label.font = .systemFont(ofSize: 25,weight: .medium)
        return label
    }()
    private let subtitleLabel:UILabel={
        let label=UILabel()
        label.font = .systemFont(ofSize: 18,weight: .regular)
        return label
    }()
    private let newsImageView:UIImageView={
        let image=UIImageView()
        image.backgroundColor = .red
        image.clipsToBounds=true
        image.contentMode = .scaleAspectFill
        return image
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsImageView)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(newsTitleLabel)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        newsTitleLabel.frame=CGRect(x: 5, y: 0, width: contentView.frame.size.width-120, height: 70)
        subtitleLabel.frame=CGRect(x: 10, y: 70, width: contentView.frame.size.width-200, height: contentView.frame.size.height/2)
        newsImageView.frame=CGRect(x: contentView.frame.size.width-200, y:75, width: 190, height: contentView.frame.size.height-10)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        newsImageView.image=nil
        newsTitleLabel.text=nil
        subtitleLabel.text=nil
    }
    
    func configure(with viewModel:NewsTableViewCellViewModel)
    {
        newsTitleLabel.text=viewModel.title
        subtitleLabel.text=viewModel.subtitle
        
        if let data=viewModel.imageData
        {
            newsImageView.image=UIImage(data: data)
        }
        else if let url=viewModel.imageURL
        {
            //fetch
            URLSession.shared.dataTask(with: url, completionHandler: {data,_,error in
                guard let data=data, error==nil else
                {
                    return
                }
                viewModel.imageData=data
                DispatchQueue.main.async {
                    self.newsImageView.image=UIImage(data: data)
                }
            })
        }
    }
}
