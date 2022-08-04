import Combine
import XCTest
@testable import WeatherForecast

class CityForecastViewModelTests: XCTestCase {

    enum TestError: Error { case missmatch1, missmatch2 }

    let testPoint = PointModel(lat: 41.8781136, lon: -87.6297982)
    lazy var testCity = City(name: "Chicago", latitude: testPoint.lat, longitude: testPoint.lon)
    let testGridId = "WFO"
    let testGridX = 5
    let testGridY = 12
    let testCity2 = City(name: "Denver", latitude: 43, longitude: 50)

    lazy var testLocationMetadataDataPublisher = { (point: PointModel) -> AnyPublisher<LocationMetadataModel, Error> in
        if point == self.testPoint {
            return Just(LocationMetadataModel(properties: .init(gridId: self.testGridId, gridX: self.testGridX, gridY: self.testGridY)))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: TestError.missmatch1)
                .eraseToAnyPublisher()
        }
    }

    let testPeriods: [PeriodModel] = [
        .init(number: 0, name: "Today", startTime: "1pm", endTime: "2pm", isDatetime: false, temperature: 10, temperatureUnit: "F", temperatureTrend: "falling", windSpeed: "5mph", windDirection: "S", icon: "http://bla-bla-bla", shortForecast: "bla", detailedForecast: "bla-bla-bla"),
        .init(number: 0, name: "Tonight", startTime: "1am", endTime: "2am", isDatetime: true, temperature: 5, temperatureUnit: "C", temperatureTrend: "raising", windSpeed: "1mph", windDirection: "SE", icon: "http://bla-bla-bla2", shortForecast: "bla2", detailedForecast: "bla-bla-bla2")
    ]

    lazy var testWeeklyForecastPublisher = { (wfo: String, x: Int, y:  Int) -> AnyPublisher<WeeklyForecastModel, Error> in
        if wfo == self.testGridId && x == self.testGridX && y == self.testGridY {
            return Just(WeeklyForecastModel(properties: .init(periods: self.testPeriods)))
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

        let city = City(name: "Chicago", latitude: 41.8781136, longitude: -87.6297982)

        // When

        let sut = CityForecastViewModel(
            city: city,
            locationMetadataDataPublisher: { _ in
                Just(LocationMetadataModel(
                    properties: .init(
                        gridId: "foo",
                        gridX: 100,
                        gridY: 200)))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
            },
            weeklyForecastPublisher: { _, _ ,_  in
                Just(WeeklyForecastModel(
                    from: .init(properties: .init(periods: []))))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
            }, iconPublisher: { _ in
                Empty()
                    .setOutputType(to: UIImage.self)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        )

        // Then

        XCTAssertEqual(sut.city, city)
    }

    func testWorkflowSuccess() {

        // Given

        let expectation = expectation(description: "")

        // When

        let sut = CityForecastViewModel(
            city: testCity,
            locationMetadataDataPublisher: testLocationMetadataDataPublisher,
            weeklyForecastPublisher: testWeeklyForecastPublisher,
            iconPublisher: { _ in
                Empty()
                    .setOutputType(to: UIImage.self)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
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

        sut.load()

        waitForExpectations(timeout: 3)

        // Then

        XCTAssertNil(sut.state!.error)
        XCTAssertEqual(sut.periods, testPeriods)
    }

    func testWorkflowFail() {

        // Given

        let expectation = expectation(description: "")

        // When

        let sut = CityForecastViewModel(
            city: testCity2,
            locationMetadataDataPublisher: testLocationMetadataDataPublisher,
            weeklyForecastPublisher: testWeeklyForecastPublisher,
            iconPublisher: { _ in
                Empty()
                    .setOutputType(to: UIImage.self)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
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

        sut.load()

        waitForExpectations(timeout: 3)

        // Then

        XCTAssertNotNil(sut.state!.error)
        XCTAssertEqual(sut.periods, [])
    }
}
