import SwiftUI

struct CityForecastView: View {

    @ObservedObject var viewModel: CityForecastViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.currentTemperatureUnit) var currentTemperatureUnit

    var body: some View {

        let err = Binding.constant($viewModel.state.wrappedValue?.error ?? nil)

        List {

            ForEach(viewModel.periods) { period in

                Group {
                    CityForecastCellView(viewModel: period)
                }
                .background(
                    ZStack {
                        Rectangle()
                            .fill(Color.element)
                            .topLeftShadow(radius: Constants.Forecast.Shadow.cornerRadius, offset: Constants.Forecast.Shadow.cornerOffset)
                        Rectangle()
                            .inset(by: Constants.Forecast.InnerRect.inset)
                            .fill(Color.element)
                            .rightBottomShadow(radius: Constants.Forecast.Shadow.cornerRadius, offset: Constants.Forecast.Shadow.cornerOffset)
                    }
                )
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.element)
            .listRowInsets(.none)
        }
        .navigationTitle(viewModel.cityViewModel.name)
        .listStyle(.plain)
        .background(Color.element)
        .navigationBarItems(
            trailing: Button(action: {
                currentTemperatureUnit.wrappedValue.toggle()
            }, label: {
                Text(currentTemperatureUnit.wrappedValue == .celsius ? "Celsius" : "Fahrenheit")
            })
        )
        .alert(isPresented: Binding.constant(err.wrappedValue != nil), content: {
            let error = err.wrappedValue!
            return Alert(
                title: Text("Error!"),
                message: Text((error as? WeatherGovWebAPI.Error)?.localizedDescription ?? error.localizedDescription),
                dismissButton: .default(Text("OK"), action: {
                    viewModel.state = nil
                    dismiss()
                }))
        })
    }
}

struct CityForecastView_Previews: PreviewProvider {
    static var previews: some View {
        CityForecastView(viewModel: CityForecastViewModel(cityViewModel: CityViewModel(City(name: "Chicago", latitude: 41.8781136, longitude: -87.6297982))))
    }
}

