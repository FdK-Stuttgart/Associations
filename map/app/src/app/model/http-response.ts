export type MyHttpResponse<T> = {
  data?: T,
  success: boolean,
  errorMessage?: string
}
