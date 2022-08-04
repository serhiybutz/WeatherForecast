import Foundation

extension Error {

    var clientPresentableMessage: String {

        func getText(_ error: Error) -> String {
            
            (error as? WeatherGovWebAPI.Error)?.localizedDescription ?? error.localizedDescription
        }

        switch self {
        case let repoError as RepositoryError:

            if case .weatherGovWebRepoError(let underlying) = repoError {

                return getText(underlying)
            }
        default:

            break
        }

        return getText(self)
    }
}
