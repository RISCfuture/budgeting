declare module 'config/secrets.js' {
  interface Secrets {
    bugsnagAPIKey: string
  }
  const secrets: Secrets
  export default secrets
}

declare module '*.svg' {
  const URL: string
  export default URL
}
