#if canImport(Android)
  import Android
#elseif canImport(Glibc)
  import Glibc
#elseif canImport(Darwin)
  import Darwin
#elseif canImport(WASILibc)
  import WASILibc
#else
  #if Foundation && canImport(Foundation)
    @preconcurrency import Foundation
  #endif
#endif

#if canImport(WinSDK)
  import WinSDK
#endif

@usableFromInline
func printError(_ message: String) {
  #if canImport(Android) || canImport(Glibc) || canImport(Darwin) || canImport(WASILibc)
    let bytes = Array("\(message)\n".utf8)
    bytes.withUnsafeBytes { buffer in
      _ = write(2, buffer.baseAddress, buffer.count)
    }
  #elseif Foundation && canImport(Foundation)
    fputs("\(message)\n", stderr)
  #else
    print(message)
  #endif
}
