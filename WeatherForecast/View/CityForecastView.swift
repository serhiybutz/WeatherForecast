import Combine
import SwiftUI

struct CityForecastView: View {

    @StateObject var viewModel: CityForecastViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.currentTemperatureUnit) var currentTemperatureUnit

    var body: some View {

        let err = Binding.constant($viewModel.state.wrappedValue?.error ?? nil)

        List {

            ForEach(viewModel.periods) { period in

                Group {
                    CityForecastCellView(viewModel: viewModel.periodViewModelFor(period))
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
        .navigationTitle(viewModel.city.name)
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
                message: Text(error.clientPresentableMessage),
                dismissButton: .default(Text("OK"), action: {
                    viewModel.state = nil
                    dismiss()
                })
            )
        })
        .onAppear {
            
            viewModel.load()
        }
    }
}

#if DEBUG
struct CityForecastView_Previews: PreviewProvider {

    static var previews: some View {
        
        CityForecastView(
            viewModel: CityForecastViewModel(
                city: City(name: "Chicago", latitude: 41.8781136, longitude: -87.6297982),
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
    }
}
#endif
