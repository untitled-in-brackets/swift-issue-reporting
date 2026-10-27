#if canImport(Android)
  @preconcurrency import Android
#elseif canImport(Glibc)
  @preconcurrency import Glibc
#elseif canImport(Musl)
  @preconcurrency import Musl
#elseif canImport(Darwin)
  @preconcurrency import Darwin
#elseif canImport(WASILibc)
  @preconcurrency import WASILibc
#elseif canImport(ucrt)
  @preconcurrency import ucrt
#endif

@usableFromInline
func printError(_ message: String) {
  fputs("\(message)\n", stderr)
}
