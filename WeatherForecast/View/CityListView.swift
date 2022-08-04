import Combine
import SwiftUI

struct CityListView: View {

    @StateObject var viewModel: CityListViewModel

    @State private var navigateToCityForecast: City?

    var body: some View {

        NavigationView {

            List {

                ForEach(viewModel.cities) { city in

                    Button {
                        navigateToCityForecast = city
                    } label: {
                        viewModel.cityCellViewFor(city)
                            .frame(maxWidth: Constants.CityList.itemsMaxWidth)
                    }
                    .buttonStyle(NeuCapsuleButtonStyle())
                    .padding(Constants.CityList.itemsPadding)
                    .frame(maxWidth: .infinity)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.element)
            }
            .listStyle(.plain)
            .background(Color.element)
            .navigationTitle("Weather Forecast")
            .onAppear {

                navigateToCityForecast = nil
            }
            // Trick to hide disclosure arrows
            .background(
                NavigationLink(isActive: Binding.constant($navigateToCityForecast.wrappedValue != nil)) {

                    if let city = navigateToCityForecast {

                        viewModel.cityForecastViewFor(city)
                    } else {

                        EmptyView()
                    }
                } label: {}
                .hidden()
            )
        }
    }
}

#if DEBUG
struct CityListView_Previews: PreviewProvider {
    static var previews: some View {
        CityListView(viewModel: CityListViewModel(
            cityList: CityList.make(),
            cityCellViewFor: {
                CityCellView(viewModel: CityViewModel($0))
            },
            cityForecastViewFor: {
                CityForecastView(
                    viewModel: CityForecastViewModel(
                        city: $0,
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
                )
            })
        )
    }
}
#endif
