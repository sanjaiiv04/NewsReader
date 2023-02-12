
import UIKit
import SafariServices
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    private var viewModels=[NewsTableViewCellViewModel]()
    private var articles=[Article]()
    //protocol subs for table view cell
    
    /// this part of the function is not working. Check why.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier,for: indexPath) as? NewsTableViewCell
        guard let cell=cell else
        {
            return UITableViewCell()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article=articles[indexPath.row]
        guard let url=URL(string: article.url ?? "") else
        {
            return
        }
        let vc=SFSafariViewController(url: url)
        present(vc,animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    //creating a tableView for the news articles
    private let tableView:UITableView={
        let table=UITableView()
        //registering for the cell in the table view
        table.register(UITableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title="News"
        view.addSubview(tableView)
        tableView.delegate=self
        tableView.dataSource=self
        view.backgroundColor = .lightGray
        //calling the APICaller class from the APICaller file
        APICaller.shared.getStories(completion: {[weak self]result in
            switch result{
            case .success(let articles):
                self?.articles = articles
                self?.viewModels=articles.compactMap({NewsTableViewCellViewModel(title: $0.title, subtitle: $0.description ?? "No description", imageURL: URL(string: $0.urlToImage ?? ""))})
                
                //reloads data everytime
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //frame for the table view
        tableView.frame=view.bounds
    }
}



