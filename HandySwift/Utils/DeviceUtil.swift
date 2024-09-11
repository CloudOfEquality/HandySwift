//
//  DeviceUtil.swift
//  WetestCloudgame
//
//  Created by xiutongmu on 2024/7/3.
//

import CoreTelephony
import Foundation
import SystemConfiguration

class DeviceUtil {

    class func localIPAddress() -> String {
        var address = "error"
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil

        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }

                if let interface = ptr?.pointee, interface.ifa_addr.pointee.sa_family == UInt8(AF_INET) {
                    let name = String(cString: interface.ifa_name)
                    if name == "en0" {
                        var addr = interface.ifa_addr.pointee
                        let addrIn = withUnsafePointer(to: &addr) {
                            $0.withMemoryRebound(to: sockaddr_in.self, capacity: 1) { $0.pointee }
                        }
                        address = String(cString: inet_ntoa(addrIn.sin_addr))
                    }
                }
            }
            freeifaddrs(ifaddr)
        }

        return address
    }

    class func deviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)

        let code = withUnsafePointer(to: &systemInfo.machine.0) { ptr in
            String(cString: ptr)
        }

        if let filePath = Bundle.main.path(forResource: "device_model_map", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
           let deviceModelMap = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
            return deviceModelMap[code] ?? code
        } else {
            NSLog("Error reading device_model_map.json")
            return code
        }
    }

    class func currentNetwork() -> String {
        var networkType = "unknown"
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let reachabilityRef = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, $0)
            }
        }

        var flags = SCNetworkReachabilityFlags()
        if let reachabilityRef, SCNetworkReachabilityGetFlags(reachabilityRef, &flags) {
            if flags.contains(.reachable) {
                if flags.contains(.isWWAN) {
                    let telephonyInfo = CTTelephonyNetworkInfo()
                    let radioAccessTechnology = telephonyInfo.serviceCurrentRadioAccessTechnology?.values.first

                    if #available(iOS 14.1, *) {
                        switch radioAccessTechnology {
                        case CTRadioAccessTechnologyLTE:
                            networkType = "4G"
                        case CTRadioAccessTechnologyNRNSA, CTRadioAccessTechnologyNR:
                            networkType = "5G"
                        default:
                            networkType = "Cellular"
                        }
                    } else {
                        switch radioAccessTechnology {
                        case CTRadioAccessTechnologyLTE:
                            networkType = "4G"
                        default:
                            networkType = "Cellular"
                        }
                    }
                } else {
                    networkType = "Wifi"
                }
            } else {
                networkType = "None"
            }
        }
        return networkType
    }
}
