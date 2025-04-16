import Combine
import Foundation
import SwiftData

protocol ExchangeRateRemoteDataSource {
    func fetchLive(for codes: [String]) async throws -> ExchangeRateDTO
    func fetchHistorical(for codes: [String]) async throws -> ExchangeRateDTO
}

final class ExchangeRateRemoteDataSourceImpl: ExchangeRateRemoteDataSource {
    private let session: URLSession
    private let baseURL = "https://api.exchangerate.host"
    private let accessKey = AppConstants.Keys.accessKey
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchLive(for codes: [String]) async throws -> ExchangeRateDTO {
        let targets = extractTargets(from: codes)
        let targetParam = targets.joined(separator: ",")
        var urlString: String = ""
        
        if AppConstants.Flags.simulateNetworkError {
            urlString = "simulated error string"
        } else {
            urlString = "\(baseURL)/live?access_key=\(accessKey)&currencies=\(targetParam)"
        }
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return try await fetch(from: url)
    }
    
    func fetchHistorical(for codes: [String]) async throws -> ExchangeRateDTO {
        let targets = extractTargets(from: codes)
        let targetParam = targets.joined(separator: ",")
        let date = yesterdayString()
        
        let urlString = "\(baseURL)/historical?access_key=\(accessKey)&date=\(date)&currencies=\(targetParam)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return try await fetch(from: url)
    }
    
    private func extractTargets(from codes: [String]) -> [String] {
        codes.compactMap { code in
            if code.count >= 6 {
                return String(code.suffix(3))
            } else {
                return nil
            }
        }
    }
    
    private func fetch<T: Decodable>(from url: URL) async throws -> T {
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    private func yesterdayString() -> String {
        let calendar = Calendar.current
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: yesterday)
    }
}

