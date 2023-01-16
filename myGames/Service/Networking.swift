//
//  Networking.swift
//  myGames
//
//  Created by YILDIRIM on 15.01.2023.
//

import Foundation
protocol NetworkingProtocol {
    func networkRequest<T:Decodable>(request:EndPoints,completion: @escaping((Result<T,Error>)) -> Void)
}

class GameNetwork: NetworkingProtocol {
    
    static let shared = GameNetwork()
    
    func networkRequest<T>(request: EndPoints, completion: @escaping ((Result<T, Error>)) -> Void) where T : Decodable {
        
        guard let url = request.url else { return print("Error at URL /GameNetwork Class/") }
        
        let task = URLSession.shared.dataTask(with: url) { data, resp, error in
            if error != nil || data == nil {
                completion(.failure(error!))
                return
            }
            do {
                let result = try JSONDecoder().decode(T.self, from: data!)
                completion(.success(result))
            }catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    
}
