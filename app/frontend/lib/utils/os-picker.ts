export function getOS(): string {
  const userAgent = window.navigator.userAgent,
    platform =
      window.navigator?.userAgentData?.platform || window.navigator.platform,
    macosPlatforms = ['macOS', 'Macintosh', 'MacIntel', 'MacPPC', 'Mac68K'],
    windowsPlatforms = ['Win32', 'Win64', 'Windows', 'WinCE'],
    iosPlatforms = ['iPhone', 'iPad', 'iPod']
  let os = null

  if (macosPlatforms.indexOf(platform) !== -1) {
    os = 'macos'
  } else if (iosPlatforms.indexOf(platform) !== -1) {
    os = 'ios'
  } else if (windowsPlatforms.indexOf(platform) !== -1) {
    os = 'windows'
  } else if (/Android/.test(userAgent)) {
    os = 'android'
  } else if (/Linux/.test(platform)) {
    os = 'linux'
  }

  return os
}
