
enum Status {
  init,
  loading,
  success,
  error,
}
extension StatusX on Status{
  bool get isLoading => this == Status.loading;

  bool get isInit => this == Status.init;

  bool get isSuccess => this == Status.success;

  bool get isError => this == Status.error;
}