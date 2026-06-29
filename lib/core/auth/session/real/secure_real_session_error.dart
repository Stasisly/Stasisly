enum SecureRealSessionError {
  missingSession,
  expiredSession,
  refreshFailed,
  backendBlocked,
  productionBlocked,
  misconfiguredEnvironment,
  unexpected,
}
