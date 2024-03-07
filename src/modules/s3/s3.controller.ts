import { Controller, Get, Param } from '@nestjs/common';
import { S3Service } from './s3.service';

@Controller('s3')
export class S3Controller {
  constructor(private readonly s3Service: S3Service) {}

  @Get(':bucket_name/:s3_key')
  async getObjects(
    @Param('bucket_name') bucketName: string,
    @Param('s3_key') s3Key: string,
  ) {
    return this.s3Service.getObject(bucketName, s3Key);
  }
}
