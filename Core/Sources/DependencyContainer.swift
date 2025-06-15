import Foundation
@preconcurrency import Swinject

public final class DependencyContainer: Sendable {
    public static let shared = DependencyContainer()
    
    nonisolated(unsafe) private let container = Container()
    
    private init() {
        setupDependencies()
    }
    
    private func setupDependencies() {
        // Register core services here
    }
    
    public func resolve<T>(_ type: T.Type) -> T? {
        return container.resolve(type)
    }
    
    public func register<T>(_ type: T.Type, factory: @escaping @Sendable (Resolver) -> T) {
        container.register(type, factory: factory)
    }
    
  public func addAssembly(_ assembly: Swinject.Assembly) {
        assembly.assemble(container: container)
    }
}

public protocol Assembly: Sendable {
    func assemble(container: Container)
}
