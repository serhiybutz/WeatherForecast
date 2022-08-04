import Combine
import SwiftUI

struct CityForecastCellView: View {

    @StateObject var viewModel: PeriodViewModel

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
                        .padding(Constants.Forecast.Cell.elementPadding)
                    }
                    HStack {
                        Text("Wind speed:")
                        Spacer()
                        Text(viewModel.windSpeed)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(Constants.Forecast.Cell.elementPadding)
                    HStack {
                        Text(viewModel.detailedForecast)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(Constants.Forecast.Cell.elementPadding)
                }
                .font(.caption)
                .padding(0)
            },
            label: {
                CityForecastCellBriefView(viewModel: viewModel)
            })
        .padding([.horizontal], Constants.Forecast.Cell.DisclosureGroup.horizontalPadding)
        .padding([.vertical], Constants.Forecast.Cell.DisclosureGroup.verticalPadding)
    }
}

struct CityForecastCellBriefView: View {

    @ObservedObject var viewModel: PeriodViewModel

    var body: some View {

        HStack {

            Text(viewModel.name)
                .padding([.horizontal], Constants.Forecast.Cell.elementPadding)

            Spacer()

            TemperatureView(
                sourceTemperature: viewModel.temperature,
                sourceTemperatureUnit: viewModel.temperatureUnit
            )
            .padding([.horizontal], Constants.Forecast.Cell.elementPadding)

            Group {
                if let icon = viewModel.icon {

                    Image(uiImage: icon)
                        .resizable()
                        .interpolation(.medium)
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: Constants.Forecast.Cell.Image.width, height: Constants.Forecast.Cell.Image.height)
                        .cornerRadius(Constants.Forecast.Cell.Image.cornerRadius)

                } else {

                    ProgressView()
                        .frame(width: Constants.Forecast.Cell.Image.width, height: Constants.Forecast.Cell.Image.height)
                        .foregroundColor(.gray)

                }
            }
            .shadow(
                color: Color.black.opacity(Constants.Forecast.Cell.Image.Shadow.opacity),
                radius: Constants.Forecast.Cell.Image.Shadow.radius,
                x: Constants.Forecast.Cell.Image.Shadow.Offset.x,
                y: Constants.Forecast.Cell.Image.Shadow.Offset.y)
            .padding([.horizontal], Constants.Forecast.Cell.elementPadding)

        }
        .onAppear {

            viewModel.load()
        }
    }
}

#if DEBUG
struct CityForecastCellView_Previews: PreviewProvider {
    static var previews: some View {
        return CityForecastCellView(
            viewModel: PeriodViewModel(
                from: PeriodModel(
                    number: 1,
                    name: "Today",
                    startTime: "",
                    endTime: "",
                    isDatetime: nil,
                    temperature: 20,
                    temperatureUnit: "f",
                    temperatureTrend: nil,
                    windSpeed: "bla-bla-bla",
                    windDirection: "bla",
                    icon: "https://api.weather.gov/icons/land/night/tsra_hi,20/fog?size=medium",
                    shortForecast: "bla",
                    detailedForecast: "bla-bla-bla"),
                iconLoader:
                    Empty()
                    .setOutputType(to: UIImage.self)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            )
        )
    }
}
#endif
