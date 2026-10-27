#if canImport(Android)
  import Android

  @usableFromInline
  final class RecursiveLock: @unchecked Sendable {
    private var mutex = pthread_mutex_t()

    @usableFromInline
    init() {
      var attributes = pthread_mutexattr_t()
      pthread_mutexattr_init(&attributes)
      pthread_mutexattr_settype(&attributes, Int32(PTHREAD_MUTEX_RECURSIVE))
      pthread_mutex_init(&mutex, &attributes)
      pthread_mutexattr_destroy(&attributes)
    }

    deinit {
      pthread_mutex_destroy(&mutex)
    }

    @usableFromInline
    func withLock<Result>(_ operation: () throws -> Result) rethrows -> Result {
      pthread_mutex_lock(&mutex)
      defer { pthread_mutex_unlock(&mutex) }
      return try operation()
    }
  }
#elseif Foundation && canImport(Foundation)
  import Foundation

  @usableFromInline
  final class RecursiveLock: @unchecked Sendable {
    private let mutex = NSRecursiveLock()

    @usableFromInline
    func withLock<Result>(_ operation: () throws -> Result) rethrows -> Result {
      mutex.lock()
      defer { mutex.unlock() }
      return try operation()
    }
  }
#else
  import Synchronization

  @usableFromInline
  final class RecursiveLock: @unchecked Sendable {
    private let mutex = Mutex(())

    @usableFromInline
    func withLock<Result>(_ operation: () throws -> Result) rethrows -> Result {
      try mutex.withLock { _ in try operation() }
    }
  }
#endif
