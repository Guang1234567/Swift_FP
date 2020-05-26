import Foundation
import Swift_FP

public final class DIContainer {

    var services: [ServiceKey: Provider<Any>]

    weak var parent: DIContainer?

    deinit {
        self.services.removeAll()
        parent = nil
        print("DIContainer deinit")
    }

    public init(parent: DIContainer? = nil) {
        self.services = [:]
        self.parent = parent
    }

    public func register<Service>(_ serviceType: Service.Type, name: String? = nil, isSingleton: Bool = false, _ getter: @escaping (DIContainer) -> Service) {
        self.registerProvider(serviceType, name: name) { container in
            if isSingleton {
                return ScopeProvider(getter: { [unowned container] in getter(container) })
            } else {
                return Provider(getter: { [unowned container] in getter(container) })
            }
        }
    }

    public func registerProvider<Service>(_ serviceType: Service.Type, name: String? = nil, _ provider: @escaping (DIContainer) -> Provider<Service>) {
        self.services[ServiceKey(serviceType: serviceType, name: name)] = provider(self).fmap {
            $0
        }
    }

    public func resolve<Service>(_ serviceType: Service.Type, name: String? = nil) -> Service? {
        return resolveProvider(serviceType, name: name)?.get()
    }

    public func resolveProvider<Service>(_ serviceType: Service.Type, name: String? = nil) -> Provider<Service>? {
        let pv = self.services[ServiceKey(serviceType: serviceType, name: name)]?.fmap {
            $0 as! Service
        }

        if pv != nil {
            return pv
        } else {
            if let parent = self.parent {
                return parent.resolveProvider(serviceType, name: name)
            } else {
                return nil
            }
        }
    }

    public func unregister<Service>(_ serviceType: Service.Type, name: String? = nil) {
        self.services[ServiceKey(serviceType: serviceType, name: name)] = nil
    }

    public func removeAll() {
        self.services.removeAll(keepingCapacity: true)
    }

}

struct ServiceKey {
    let serviceType: Any.Type
    let name: String?

    init(
            serviceType: Any.Type,
            name: String? = nil
    ) {
        self.serviceType = serviceType
        self.name = name
    }
}

extension ServiceKey: Hashable {
    public func hash(into hasher: inout Hasher) {
        ObjectIdentifier(serviceType).hash(into: &hasher)
        name?.hash(into: &hasher)
    }
}

extension ServiceKey: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.serviceType == rhs.serviceType
               && lhs.name == rhs.name
    }
}