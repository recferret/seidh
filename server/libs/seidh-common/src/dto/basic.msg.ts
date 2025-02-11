export interface BasicServiceRequest {}

export interface BasicServiceResponse {
  success: boolean;
  message?: string;
  errorCode?: number;
}
