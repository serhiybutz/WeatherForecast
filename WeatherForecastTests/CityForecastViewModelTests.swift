import Combine
import XCTest
@testable import WeatherForecast

class CityForecastViewModelTests: XCTestCase {

    enum TestError: Error { case missmatch1, missmatch2 }

    let testPoint = WeatherGovWebAPI.Point(lat: 41.8781136, lon: -87.6297982)
    lazy var testCityViewModel = CityViewModel(City(name: "Chicago", latitude: testPoint.lat, longitude: testPoint.lon))
    let testGridId = "WFO"
    let testGridX = 5
    let testGridY = 12
    let testCityViewModel2 = CityViewModel(City(name: "Denver", latitude: 43, longitude: 50))

    lazy var testLocationMetadataDataPublisher = { (point: WeatherGovWebAPI.Point) -> AnyPublisher<WeatherGovWebAPI.LocationMetadata, Error> in
        if point == self.testPoint {
            return Just(WeatherGovWebAPI.LocationMetadata(properties: .init(gridId: self.testGridId, gridX: self.testGridX, gridY: self.testGridY)))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: TestError.missmatch1)
                .eraseToAnyPublisher()
        }
    }

    let testPeriods: [WeatherGovWebAPI.Period] = [
        .init(number: 0, name: "Today", startTime: "1pm", endTime: "2pm", isDatetime: false, temperature: 10, temperatureUnit: "F", temperatureTrend: "falling", windSpeed: "5mph", windDirection: "S", icon: "http://bla-bla-bla", shortForecast: "bla", detailedForecast: "bla-bla-bla"),
        .init(number: 0, name: "Tonight", startTime: "1am", endTime: "2am", isDatetime: true, temperature: 5, temperatureUnit: "C", temperatureTrend: "raising", windSpeed: "1mph", windDirection: "SE", icon: "http://bla-bla-bla2", shortForecast: "bla2", detailedForecast: "bla-bla-bla2")
    ]

    lazy var testWeeklyForecastPublisher = { (wfo: String, x: Int, y:  Int) -> AnyPublisher<WeatherGovWebAPI.WeeklyForecast, Error> in
        if wfo == self.testGridId && x == self.testGridX && y == self.testGridY {
            return Just(WeatherGovWebAPI.WeeklyForecast(properties: .init(periods: self.testPeriods)))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: TestError.missmatch2)
                .eraseToAnyPublisher()
        }
    }

    var subscriptions: Set<AnyCancellable> = []

    func testCtreates() {

        // Given

        let viewModel = CityViewModel(City(name: "Chicago", latitude: 41.8781136, longitude: -87.6297982))

        // When

        let sut = CityForecastViewModel(cityViewModel: viewModel)

        // Then

        XCTAssertEqual(sut.cityViewModel, viewModel)
    }

    func testWorkflowSuccess() {

        // Given

        let expectation = expectation(description: "")

        // When

        let sut = CityForecastViewModel(
            cityViewModel: testCityViewModel,
            locationMetadataDataPublisher: testLocationMetadataDataPublisher,
            weeklyForecastPublisher: testWeeklyForecastPublisher
        )

        sut.$state.sink(receiveValue: {
            switch $0 {
            case .result:
                expectation.fulfill()
            case .error:
                expectation.fulfill()
            default:
                break
            }
        })
        .store(in: &subscriptions)

        waitForExpectations(timeout: 3)

        // Then

        XCTAssertNil(sut.state!.error)
        XCTAssertEqual(sut.periods, testPeriods.map { PeriodViewModel($0) })
    }

    func testWorkflowFail() {

        // Given

        let expectation = expectation(description: "")

        // When

        let sut = CityForecastViewModel(
            cityViewModel: testCityViewModel2,
            locationMetadataDataPublisher: testLocationMetadataDataPublisher,
            weeklyForecastPublisher: testWeeklyForecastPublisher
        )

        sut.$state.sink(receiveValue: {
            switch $0 {
            case .result:
                expectation.fulfill()
            case .error:
                expectation.fulfill()
            default:
                break
            }
        })
        .store(in: &subscriptions)

        waitForExpectations(timeout: 3)

        // Then

        XCTAssertNotNil(sut.state!.error)
        XCTAssertEqual(sut.periods, [])
    }
}
