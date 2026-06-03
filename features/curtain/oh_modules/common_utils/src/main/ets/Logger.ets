// 日志工具
// 查拉图斯特拉如是说

export class Logger {
  private static readonly PREFIX = '[SmartRoom]'

  static debug(tag: string, message: string, ...params: Object[]): void {
    console.debug(`${Logger.PREFIX}[${tag}] ${message}`, params)
  }

  static info(tag: string, message: string, ...params: Object[]): void {
    console.info(`${Logger.PREFIX}[${tag}] ${message}`, params)
  }

  static warn(tag: string, message: string, ...params: Object[]): void {
    console.warn(`${Logger.PREFIX}[${tag}] ${message}`, params)
  }

  static error(tag: string, message: string, ...params: Object[]): void {
    console.error(`${Logger.PREFIX}[${tag}] ${message}`, params)
  }
}