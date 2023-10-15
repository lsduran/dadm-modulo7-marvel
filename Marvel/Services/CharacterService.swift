//
//  CharacterService.swift
//  Marvel
//
//  Created by Luis Sergio Duran Arenas on 06/10/23.
//

import Foundation

class CharacterService {
    
    private var characters: [Character] = []
    var total: Int = 0
    var limit: Int = 0
    var offset: Int = 0
    var maxItemsLoaded = false
    var isLoading = false
    
    func countCharacter() -> Int {
        return characters.count
    }
    
    func getCharacter(at index: Int) -> Character {
        return characters[index]
    }
    
    func loadCharactersData(queryString: String, completion: @escaping (APIResponse<Character>?) -> Void) {
        let url = URL(string: Constants.apiBaseUrl + Constants.apiCharactersEndpoint + queryString)!
        let session = URLSession.shared
        var httpResponse = HTTPURLResponse()
        var loadedCharacters : [Character] = []
        
        // Creates a data task with a URL request
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            // Check response
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("Invalid response")
                httpResponse = (response as? HTTPURLResponse)!
                print("statusCode: ", httpResponse.statusCode)
                return
            }
            
            // Check if there is any data
            guard let data = data else {
                print("No data received")
                return
            }
            
            // Parse and use the data
            do {
                let decodedResponse = try JSONDecoder().decode(APIResponse<Character>.self, from: data)
                
                print("Status Code:", decodedResponse.code )
                print("Status:", decodedResponse.status )
                print("copyright:", decodedResponse.copyright )
                print("attributionText:", decodedResponse.attributionText )
                print("attributionHTML:", decodedResponse.attributionHTML )
                print("etag:", decodedResponse.etag )
                print("data results:", decodedResponse.data.count )
                
                loadedCharacters = decodedResponse.data.results
                self.limit = decodedResponse.data.limit
                self.offset = decodedResponse.data.offset
                self.total = decodedResponse.data.total
                
                for character in loadedCharacters {
                    self.characters.append(character)
                    print("ch:", character.name)
                }
                
                print("count session: ",self.countCharacter())
                if self.countCharacter() == self.total{
                    self.maxItemsLoaded = true
                    print("All characters loaded")
                }
                completion(decodedResponse)
                
            } catch let error{
                loadedCharacters = []
                self.limit = 0
                self.offset = 0
                print("JSON parsing error: \(error)")
                completion(nil)
            }
        }
        
        // Start the task
        task.resume()
    }
}
