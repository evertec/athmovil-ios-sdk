import Foundation

class NewRelicConfig {

    static func sendEventToNewRelic(
    eventType: String,
    paymentStatus: String?,
    buildType: TargetEnviroment?,
    paymentReference: String?
    ) {
        let insertKey = NrConstantUtils.NR.NRCONSTANT.replacingOccurrences(of: "[@!$#]", with: "", options: .regularExpression)
        let url = NrConstantUtils.NR.URLCONSTANT.replacingOccurrences(of: "[@!$#]", with: "", options: .regularExpression)
        

        let event: [String: Any?] = [
            "eventType": eventType,
            "timestamp": Int(Date().timeIntervalSince1970 * 1000),
            "payment_reference": paymentReference ?? nil,
            "sdk_platform": "iOS_Nativo",
            "build_type": buildType?.rawValue,
            "payment_status":paymentStatus ?? nil,
            "merchant_app_id":Bundle.main.infoDictionary?["CFBundleName"],
            "sdk_version": Bundle(for: Self.self).infoDictionary?["CFBundleShortVersionString"],
            "device_os_version": UIDevice.current.systemVersion,
            "device_os_model": UIDevice.current.model        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: event),
        let requestURL = URL(string: url) else {
            debugPrint("Error creating request")
            return
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.setValue(insertKey, forHTTPHeaderField: "X-Insert-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                debugPrint("New Relic Event API error: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    debugPrint("Event sent to New Relic successfully")
                } else {
                    debugPrint("New Relic API response error: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
}


