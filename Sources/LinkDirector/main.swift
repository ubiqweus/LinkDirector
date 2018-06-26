
import PerfectHTTPServer
import PerfectHTTP
import PerfectMustache
import Foundation

// ...
import PerfectPostgreSQL
import PerfectRedis

#if os(macOS)
let httpPort = 8080
#else
let httpPort = 80
#endif

let appStoreURL = "https://itunes.apple.com/app/qbiq/id1183031049"
let shareTemplate = "./templates/share.mustache"

struct BiqIdRequest: Codable {
	let biqid: String
	let token: UUID?
}

extension HTTPResponse {
	func debug() {
		var accum = "\n\n--\n\n"
		let headers = request.headers
		for (name, value) in headers {
			accum += "\(name.standardName): \(value)\n"
		}
		accum += "\n--\n\n"
		let queryParams = request.queryParams
		for (name, value) in queryParams {
			accum += "\(name)=\(value)\n"
		}
		accum += "\n--\n\n"
		let postParams = request.postParams
		for (name, value) in postParams {
			accum += "\(name)=\(value)\n"
		}
		accum += "\n--\n\n"
		print(accum)
	}
}

func handleStore(request: HTTPRequest, response: HTTPResponse) {
	response.setHeader(.location, value: appStoreURL)
	response.completed(status: .movedPermanently)
}

func handleRest(request: HTTPRequest, response: HTTPResponse) {
	StaticFileHandler(documentRoot: "./webroot", allowResponseFilters: true)
		.handleRequest(request: request, response: response)
}

func handleTokenBiqURL(request: HTTPRequest, response: HTTPResponse) {
	guard let biqRequest: BiqIdRequest = try? request.decode() else {
		return handleRest(request: request, response: response)
	}
	let qBiqUrl: String
	if let token = biqRequest.token {
		qBiqUrl = "qbiq://qbiq/\(token)/\(biqRequest.biqid)"
	} else {
		qBiqUrl = "qbiq://qbiq/\(biqRequest.biqid)"
	}
	let map: [String:Any] = ["appStoreURL":appStoreURL, "qBiqUrl":qBiqUrl]
	let ctx = MustacheEvaluationContext(templatePath: shareTemplate, map: map)
	let collector = MustacheEvaluationOutputCollector()
	do {
		let txt = try ctx.formulateResponse(withCollector: collector)
		response.setBody(string: txt).completed(status: .found)
	} catch {
		response.setBody(string: "\(error)").completed(status: .internalServerError)
	}
}

var routes = Routes()
routes.add(method: .get, uri: "/**", handler: handleRest)
routes.add(method: .get, uri: "/", handler: handleStore)
routes.add(method: .get, uri: "/{biqid}", handler: handleTokenBiqURL)
routes.add(method: .get, uri: "/{token}/{biqid}", handler: handleTokenBiqURL)

try HTTPServer.launch(name: "ubiqwe.us", port: httpPort, routes: routes)
