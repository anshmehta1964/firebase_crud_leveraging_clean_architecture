abstract class UseCaseWithParams<Type, Params> {
  const UseCaseWithParams();
  call(Params params);
}

abstract class UseCaseWithoutParams<Type> {
  const UseCaseWithoutParams();
  call();
}