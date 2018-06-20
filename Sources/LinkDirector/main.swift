
import PerfectHTTPServer
import PerfectHTTP
import Foundation

#if os(macOS)
let httpPort = 8080
#else
let httpPort = 80
#endif

struct BiqIdRequest: Codable {
	let biqid: String
	let token: UUID?
}

func handleRoot(request: HTTPRequest, response: HTTPResponse) {
	response.setBody(string: "Ubiqwe.us link director")
	response.completed()
}

func handleTokenBiqURL(request: HTTPRequest, response: HTTPResponse) {
	guard let request: BiqIdRequest = try? request.decode() else {
		return response.setBody(string: "Not found").completed(status: .notFound)
	}
	response.setBody(string: "Ubiqwe.us token/biq request: \(request)")
	response.completed()
}

func handleBiqURL(request: HTTPRequest, response: HTTPResponse) {
	guard let request: BiqIdRequest = try? request.decode() else {
		return response.setBody(string: "Not found").completed(status: .notFound)
	}
	response.setBody(string: "Ubiqwe.us biq request: \(request)")
	response.completed()
}

var routes = Routes()
routes.add(method: .get, uri: "/", handler: handleRoot)
routes.add(method: .get, uri: "/{biqid}", handler: handleBiqURL)
routes.add(method: .get, uri: "/{token}/{biqid}", handler: handleTokenBiqURL)

try HTTPServer.launch(name: "ubiqwe.us", port: httpPort, routes: routes)
