// HTTP服务封装
// 查拉图斯特拉如是说

import { http } from '@kit.NetworkKit'
import { BASE_URL, REQUEST_TIMEOUT } from './ApiConfig.ets'
import type { ApiResponse } from './ApiResponse.ets'

export class HttpService {
  private static instance: HttpService
  private httpRequest: http.HttpRequest

  private constructor() {
    this.httpRequest = http.createHttp()
  }

  static getInstance(): HttpService {
    if (!HttpService.instance) {
      HttpService.instance = new HttpService()
    }
    return HttpService.instance
  }

  private createRequestOptions(method: http.RequestMethod, url: string, token?: string): http.HttpRequestOptions {
    const header: Record<string, string> = {
      'Content-Type': 'application/json',
      'Authorization': token ? `Bearer ${token}` : ''
    }
    return {
      method: method,
      url: url,
      connectTimeout: REQUEST_TIMEOUT,
      readTimeout: REQUEST_TIMEOUT,
      header: header
    } as http.HttpRequestOptions
  }

  async request<T>(method: http.RequestMethod, url: string, token?: string, extraData?: string): Promise<ApiResponse<T>> {
    const options = this.createRequestOptions(method, `${BASE_URL}${url}`, token)
    if (extraData) {
      options.extraData = extraData
    }

    try {
      const result = await this.httpRequest.request(`${BASE_URL}${url}`, options)
      return JSON.parse(result.result as string) as ApiResponse<T>
    } catch (error) {
      return {
        code: -1,
        msg: '网络请求失败'
      }
    }
  }

  async get<T>(url: string, token?: string): Promise<ApiResponse<T>> {
    return this.request<T>(http.RequestMethod.GET, url, token)
  }

  async post<T>(url: string, token?: string, extraData?: string): Promise<ApiResponse<T>> {
    return this.request<T>(http.RequestMethod.POST, url, token, extraData)
  }
}