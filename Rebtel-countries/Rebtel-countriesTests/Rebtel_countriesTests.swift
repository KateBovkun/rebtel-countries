//
//  Rebtel_countriesTests.swift
//  Rebtel-countriesTests
//
//  Created by Ekaterina Zyryanova on 2022-08-25.
//

import XCTest
@testable import Rebtel_countries

class Rebtel_countriesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    func testDecoder() throws {
        let decoder = FactoriesContainer().makeDecoder()
        let dict = [[
            "name":["common":"Finland"],
            "cca2":"FI",
            "ccn3":"246",
            "cca3":"FIN",
            "cioc":"FIN",
            "borders":["NOR","SWE","RUS"],
            "flags":["png":"https://flagcdn.com/w320/fi.png","svg":"https://flagcdn.com/fi.svg"]
        ],[
            "name":["common":"Guatemala"],
            "cca3":"GTM",
            "borders":["BLZ","SLV","HND","MEX"],
            "flags":["png":"https://flagcdn.com/w320/gt.png","svg":"https://flagcdn.com/gt.svg"]
        ]]
        let data = try JSONSerialization.data(withJSONObject: dict)
        let response = try decoder.decode([CountryResponse].self, from: data)
        XCTAssertFalse(response.isEmpty)
    }

    func testGraphBuilder() {
        let countries = [
            CountryResponse(borders: ["A", "B", "C"], cca3: "A", flags: CountryFlagResponse(png: nil), name: CountryNameResponse(common: "A")),
            CountryResponse(borders: ["A", "B", "C"], cca3: "B", flags: CountryFlagResponse(png: nil), name: CountryNameResponse(common: "B")),
            CountryResponse(borders: ["A", "B", "C"], cca3: "C", flags: CountryFlagResponse(png: nil), name: CountryNameResponse(common: "C"))
        ]
        let graph = GraphBuilder().buildGraph(with: countries)
        XCTAssertTrue(graph.vertexes().count == 3)
        let element = graph.randomElement()!
        XCTAssertTrue(element.1.count == 3)
    }

}
