import XCTest
@testable import cautious_barnacle

class WordServiceTests: XCTestCase {
    
    func testResources() {
        
        let wordsResource = makeSearchResource(for: "Hello", at: 1, size: 20)
        let meaningResource = makeMeaningResource(for: "1,2,3")
        
        let responses = [
            ResourceAndResponse(resource: wordsResource, response: mockWordsData),
            ResourceAndResponse(resource: meaningResource, response: [Meaning(id: "1", wordId: 1, text: "text", soundUrl: "", transcription: "", updatedAt: "", translation: Translation(text: "", note: ""), images: [Meaning.Image(url: "")])]),
        ]
        
        let testSession = TestSession(responses: responses)
        let env = Environment(session: testSession)
        
        let wordsService = WordsServiceImp(environment: env)
        wordsService.loadWords(by: "Hello", page: 1, perPage: 20) { (result) in
            switch result {
            case .success(let words):
                XCTAssertEqual(words, mockWordsData)
            case .failure(let error):
                XCTAssertFalse(true, "Error is not expected \(error)")
            }
        }
        
        wordsService.loadMeanings(ids: "1,2,3") { (result) in
            switch result {
            case .success(let m):
                print(m)
            case .failure(let error):
                print(error)
            }
        }
        
        XCTAssertTrue(testSession.verify(), "resource fetching failed")
    }
}
