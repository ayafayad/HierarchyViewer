//
//  APIManagerTests.swift
//  HierarchyViewerTests
//
//  Created by Aya Fayad on 11/04/2025.
//

import XCTest
@testable import HierarchyViewer

struct PersonName: Codable {
    var firstName: String
    var lastName: String
}

final class APIManagerTests: XCTestCase {
    
    var sut: APIManager!
    var urlSession: URLSession!
    let networkMonitor = MockNetworkMonitor(isReachable: true)

    override func setUpWithError() throws {
        super.setUp()
        
        // Configure URLSession with our custom URLProtocol
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
                
        // Instantiate our APIManager with the stubbed URLSession
        sut = APIManager(urlSession: urlSession,
                         networkMonitor: networkMonitor)
    }

    override func tearDownWithError() throws {
        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = nil
        sut = nil
        urlSession = nil
        try super.tearDownWithError()
    }
    
    func testInvalidUrl() async throws {
        // Given
        let url = "💥://example.com"
        let dummyData = [
            PersonName(firstName: "Aya", lastName: "Fayad"),
            PersonName(firstName: "Hassaan", lastName: "Elgarem")
        ]
        let jsonData = try JSONEncoder().encode(dummyData)
        var returnedError: Error?
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "💥://example.com")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            return (response, jsonData)
        }
        
        // When
        let response = await sut.request(url, type: [PersonName].self)
        if case .failure(let error) = response {
            returnedError = error
        }
        
        // Then
        let networkError = try XCTUnwrap(returnedError as? NetworkError)
        let expectedError = NetworkError.invalidUrl(url)
        XCTAssertEqual(networkError.errorDescription, expectedError.errorDescription)
    }
    
    func testStatusCodeError() async throws {
        // Given
        let url = "https://example.com"
        let dummyData = [
            PersonName(firstName: "Aya", lastName: "Fayad"),
            PersonName(firstName: "Hassaan", lastName: "Elgarem")
        ]
        let jsonData = try JSONEncoder().encode(dummyData)
        var returnedError: Error?
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                           statusCode: 404,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            return (response, jsonData)
        }
        
        // When
        let response = await sut.request(url, type: [PersonName].self)
        if case .failure(let error) = response {
            returnedError = error
        }
        
        // Then
        let networkError = try XCTUnwrap(returnedError as? NetworkError)
        let expectedError = NetworkError.statusCodeError(404)
        XCTAssertEqual(networkError.errorDescription, expectedError.errorDescription)
    }
    
    func testDecodingError() async throws {
        // Given
        let invalidJSON = """
                { "invalidKey": "invalidValue" }
                """
        let jsonData = Data(invalidJSON.utf8)
        let url = "https://example.com"
        var returnedError: Error?
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            return (response, jsonData)
        }
        
        // When
        let response = await sut.request(url, type: PersonName.self)
        if case .failure(let error) = response {
            returnedError = error
        }
      
        
        // Then
        let networkError = try XCTUnwrap(returnedError as? NetworkError)
        if case .decodingFailed = networkError {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected NetworkError.decodingFailed")
        }
    }
    
    func testNoInternetConnectionError() async throws {
        // Given
        let url = "https://example.com"
        let dummyData = PersonName(firstName: "Aya", lastName: "Fayad")
        let jsonData = try JSONEncoder().encode(dummyData)
        networkMonitor.isNetworkReachable = false
        var returnedError: Error?
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            return (response, jsonData)
        }
        
        // When
        let response = await sut.request(url, type: PersonName.self)
        if case .failure(let error) = response {
            returnedError = error
        }
        
        // Then
        let networkError = try XCTUnwrap(returnedError as? NetworkError)
        if case .noInternetConnection = networkError {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected NetworkError.noInternetConnection")
        }
    }
    
    func testSuccess() async throws {
        let url = "https://example.com"
        let dummyData = PersonName(firstName: "Aya", lastName: "Fayad")
        let jsonData = try JSONEncoder().encode(dummyData)
        var returnedData: PersonName?
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            return (response, jsonData)
        }
        
        // When
        let response = await sut.request(url, type: PersonName.self)
        if case .success(let data) = response {
            returnedData = data
        }
        
        // Then
        XCTAssertEqual(returnedData?.firstName, "Aya")
        XCTAssertEqual(returnedData?.lastName, "Fayad")
    }

}
