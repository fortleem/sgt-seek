import { Controller, Get } from '@nestjs/common';

@Controller()
export class AppController {
  @Get()
  root() {
    return { 
      message: '🚗 SafeRide Egypt API Gateway is running!',
      status: '✅ Healthy',
      docs: '/api'
    };
  }
}
