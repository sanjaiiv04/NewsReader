
import Foundation
final class APICaller
{
    static let shared=APICaller() //instance for the class
    //url for the API call
    static let topHeadlinesURL=URL(string:"https://newsapi.org/v2/top-headlines?country=us&apiKey=bb932b77e968499fbb4d0f2090fae70b")
    
    private init(){}
    
    //the function is going to return a list of articles as result.
    public func getStories(completion: @escaping(Result<[Article],Error>)->Void)
    {
        //unwrapping the url for the website
        guard let url=APICaller.topHeadlinesURL else{
            return
        }
        //creating a URLSession for the connection of API with the given apiKey
        let task=URLSession.shared.dataTask(with: url, completionHandler: {data,_,error in
            //if we get error print the error
            if let error=error {
                completion(.failure(error))
            }
            //if we get data then decode the result we receive from the API. We decode the results we get into the APIResponse structure because the json file that is returned has the list of article objects.
            else if let data=data{
                do{
                    let result=try JSONDecoder().decode(APIResponse.self , from: data)
                    completion(.success(result.articles))
                }
                catch{
                    completion(.failure(error))
                }
            }
        })
        task.resume()
    }
}
//see the structure of the json that we get from the API call and create structures accordingly to decode the information into the result variable
struct APIResponse:Codable
{
    let articles:[Article]
}
struct Article:Codable
{
    let source:Source
    let title:String
    let description:String?
    let url:String?
    let urlToImage:String?
    let publishedAt:String
}
struct Source:Codable
{
    let name:String
}
