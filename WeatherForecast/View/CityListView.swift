import SwiftUI

struct CityListView: View {

    @StateObject var viewModel = CityListViewModel(CityList.make())
    @State private var navigateToCityForecast: CityViewModel?

    var body: some View {

        NavigationView {

            List {

                ForEach(viewModel.cities) { city in

                    Button {
                        navigateToCityForecast = city
                    } label: {
                        CityCellView(viewModel: city)
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
                        CityForecastView(viewModel: CityForecastViewModel(cityViewModel: city))
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
        CityListView()
    }
}
#endif
