import SwiftUI

struct CityForecastCellView: View {

    let viewModel: PeriodViewModel

    var body: some View {

        DisclosureGroup(
            content: {
                VStack {
                    if let temperatureTrend = viewModel.temperatureTrend {
                        HStack {
                            Text("Tempereture trend:")
                            Spacer()
                            Text(temperatureTrend)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(5)
                    }
                    HStack {
                        Text("Wind speed:")
                        Spacer()
                        Text(viewModel.windSpeed)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(5)
                    HStack {
                        Text(viewModel.detailedForecast)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(5)
                }
                .font(.caption)
                .padding(0)
            },
            label: {
                CityForecastCellBriefView(viewModel: viewModel)
            })
        .padding([.horizontal], 7)
        .padding([.vertical], 20)
    }
}

struct CityForecastCellBriefView: View {

    let viewModel: PeriodViewModel

    var body: some View {

        HStack {

            Text(viewModel.name)
                .padding([.horizontal], 5)

            Spacer()

            TemperatureView(
                sourceTemperature: viewModel.temperature,
                sourceTemperatureUnit: viewModel.temperatureUnit
            )
            .padding([.horizontal], 5)

            AsyncImageView(url: viewModel.iconURL) {
                Text("Loading preview...")
                    .foregroundColor(.gray)
                    .frame(width: 100, height: 100)
            } image: {
                Image(uiImage: $0)
                    .resizable()
                    .interpolation(.medium)
                    .aspectRatio(1, contentMode: .fit)
                    .frame(height: 100)
                    .cornerRadius(5)
            }
            .shadow(color: Color.black.opacity(0.5), radius: 2, x: 2, y: 2)
            .padding([.horizontal], 5)

        }
    }
}


#if DEBUG
struct CityForecastCellView_Previews: PreviewProvider {
    static var previews: some View {
        return CityForecastCellView(viewModel: PeriodViewModel(name: "Today", iconURL: URL(string: "https://api.weather.gov/icons/land/night/tsra_hi,20/fog?size=medium"), temperature: 20, temperatureUnit: .fahrenheit, temperatureTrend: nil, windSpeed: "bla-bla-bla", shortForecast: "bla", detailedForecast: "bla-bla-bla"))
    }
}
#endif
