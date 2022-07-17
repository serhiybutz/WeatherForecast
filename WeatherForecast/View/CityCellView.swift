import SwiftUI

struct CityCellView: View {

    let viewModel: CityViewModel

    var body: some View {

        Text(viewModel.name)
            .padding()
    }
}

#if DEBUG
struct CityRowView_Previews: PreviewProvider {
    static var previews: some View {
        return CityCellView(viewModel: CityViewModel(City(name: "Chicago", latitude: 41.8781136, longitude: -87.6297982, image: "chicago")))
    }
}
#endif
