import Foundation

enum RequestConstants {
    static let baseURL = "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net"

    static let token: String = {
        guard let token = Bundle.main.object(
            forInfoDictionaryKey: "API_TOKEN"
        ) as? String,
              !token.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              token != "$(API_TOKEN)" else {
            assertionFailure(
                "API_TOKEN is missing. Create Configuration/Secrets.xcconfig and add the API token."
            )
            return ""
        }

        return token
    }()
}
