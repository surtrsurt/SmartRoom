// 校验工具
// 查拉图斯特拉如是说

export class ValidateUtils {
  static isEmpty(value: string): boolean {
    return !value || value.trim().length === 0
  }

  static isValidRoomNo(roomNo: string): boolean {
    return /^\d{4}$/.test(roomNo)
  }

  static isValidPassword(password: string): boolean {
    return password.length >= 4
  }

  static isValidName(name: string): boolean {
    return name.length >= 1 && name.length <= 20
  }
}